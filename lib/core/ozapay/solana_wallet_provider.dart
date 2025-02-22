import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:solana/base58.dart' as base58;
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart' hide Instruction;
import 'package:solana/solana.dart';

import 'cluster_api_url.dart';
import 'models/token_balance_result.dart';
import 'models/transaction_history.dart';

class SolanaWalletProvider {
  static final instance = SolanaWalletProvider._();

  SolanaWalletProvider._() {
    rootBundle.loadString('assets/tokens/solana.tokenlist.json').then((value) {
      solanaTokenList = json.decode(value);
    });
  }

  factory SolanaWalletProvider() => instance;

  static final _clusterUrl = clusterApiUrl(Cluster.fromString(
    dotenv.get(kSolanaNetwork),
  ));

  Map<String, dynamic> solanaTokenList = {};

  static const kBaseFee = 1000;
  static const kMaxFee = 1000000;
  static const kMinFee = 1000;

  static final client = SolanaClient(
    rpcUrl: Uri.parse(_clusterUrl.rpcUrl),
    websocketUrl: Uri.parse(_clusterUrl.websocketUrl),
    timeout: Duration(seconds: 60),
  );

  final _dio = Dio(BaseOptions(contentType: "application/json"));

  /// ************
  /// About wallet
  /// ************

  /// Generate mnemonic phrase
  /// Returns [String]
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  /// Import wallet from Mnemonic
  /// Input [String]
  /// Return [Ed25519HDKeyPair]
  Future<Ed25519HDKeyPair> getKeypairFromMnemonic(final String mnemonic) {
    try {
      return Ed25519HDKeyPair.fromMnemonic(mnemonic, account: 0, change: 0);
    } catch (e) {
      throw Exception("Mnemonic phrase incorrect !");
    }
  }

  /// Import wallet from Secret Key
  /// Input [String] ListString or Base64String
  /// Return [Ed25519HDKeyPair]
  Future<Ed25519HDKeyPair> getKeypairFromPrivateKey(final String source) {
    final privateKey = decodePrivateKey(source);

    try {
      return Ed25519HDKeyPair.fromPrivateKeyBytes(
        privateKey: privateKey.sublist(0, 32),
      );
    } catch (e) {
      throw Exception("Secret Key incorrect !");
    }
  }

  /// Get Balance
  /// Input [String]
  /// Return [double]
  Future<double> getBalance(final String walletAddress) async {
    try {
      final balance = await client.rpcClient.getBalance(walletAddress);
      return balance.value / lamportsPerSol;
    } catch (e) {
      e.log();

      rethrow;
    }
  }

  /// Get Solana price & currency
  /// Returns [double]
  Future<Map<String, dynamic>> getPrices({required List<String> coins}) async {
    try {
      _dio.options.baseUrl = dotenv.get(kJupiterApi);
      final result = await _dio
          .get('/price/v2', queryParameters: {"ids": coins.join(",")});
      return result.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  /// Get Transactions history
  ///
  Future<List<TransactionHistory>> getTransactionHistory(String wallet,
      [int? limit]) async {
    double getSolBalance(Meta? meta) {
      final preBalance = meta?.preBalances.first ?? 0;
      final postBalance = meta?.postBalances.first ?? 0;
      final balanceChange = (preBalance - postBalance) / lamportsPerSol;

      return balanceChange;
    }

    DateTime getTimestamp(int? blockTime) {
      final normalizedTimestamp = (blockTime ?? 0) * 1000;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        normalizedTimestamp,
        isUtc: true,
      );

      return timestamp;
    }

    Future<Map<String, dynamic>?> getMeta(String source) async {
      Map<String, dynamic>? metadata = await getTokenMetadata(
        (await getTokenMint(source)).toBase58(),
      );

      _dio.options.baseUrl = metadata['uri'];
      await _dio.get('').then((response) {
        metadata['uri'] = response.data['image'];
      });

      return metadata;
    }

    Future<InstructionInfo?> getInstruction(dynamic info) async {
      if (info is SplTokenTransferCheckedInfo) {
        final amount = double.parse(info.tokenAmount.uiAmountString!);
        final meta = await getMeta(info.source);
        final ata = await client.getAssociatedTokenAccount(
          owner: Ed25519HDPublicKey.fromBase58(wallet),
          mint: meta!["mint"],
        );
        final isSender = ata?.pubkey == info.source;

        return InstructionInfo(
          amount: amount * (isSender ? -1 : 1),
          source: info.source,
          destination: info.destination,
        );
      }

      if (info is SplTokenTransferInfo) {
        final tokenMint = await getTokenMint(info.source);
        final decimals = (await client.getMint(address: tokenMint)).decimals;
        final amount = double.parse(info.amount) / pow(10, decimals);
        final meta = await getMeta(info.source);
        final ata = await client.getAssociatedTokenAccount(
          owner: Ed25519HDPublicKey.fromBase58(wallet),
          mint: Ed25519HDPublicKey.fromBase58(meta!["mint"]),
        );
        final isSender = ata?.pubkey == info.source;

        return InstructionInfo(
          amount: amount * (isSender ? -1 : 1),
          source: info.source,
          destination: info.destination,
        );
      }

      return null;
    }

    try {
      final signatures = await client.rpcClient
          .getSignaturesForAddress(wallet, limit: limit ?? 10);

      List<TransactionHistory> transactions = [];

      for (var signature in signatures) {
        final txn = await client.rpcClient.getTransaction(
          signature.signature,
          encoding: Encoding.jsonParsed,
          commitment: Commitment.processed,
        );

        if (txn == null) continue;

        final transaction = txn.transaction as ParsedTransaction;
        final instructions = transaction.message.instructions
            .where((it) => it.runtimeType.toString() != 'SimpleInstruction');
        String? memo;
        InstructionInfo? instructionInfo;
        Map<String, dynamic>? tokenMetadata;

        for (Instruction instruction in instructions) {
          if (instruction is ParsedInstruction) {
            await instruction.mapOrNull(
              memo: (ParsedInstructionMemo value) {
                memo = value.memo;
              },
              system: (ParsedInstructionSystem systemIx) {
                systemIx.parsed.mapOrNull(
                  transfer: (ParsedSystemTransferInstruction value) {},
                  transferChecked:
                      (ParsedSystemTransferCheckedInstruction value) {},
                );
              },
              splToken: (ParsedInstructionSplToken splIx) async {
                splIx.parsed.mapOrNull(
                  transfer: (ParsedSplTokenTransferInstruction value) async {
                    instructionInfo = await getInstruction(value.info);
                    tokenMetadata = await getMeta(value.info.source);
                  },
                  transferChecked:
                      (ParsedSplTokenTransferCheckedInstruction value) async {
                    instructionInfo = await getInstruction(value);
                    tokenMetadata = await getMeta(value.info.source);
                  },
                  generic: (ParsedSplTokenGenericInstruction value) async {
                    "generic".log();
                    instructionInfo = await getInstruction(value);

                    tokenMetadata = await getMeta(value.info.source);
                  },
                );
              },
            );
          }
        }

        if (instructionInfo != null) {
          final history = TransactionHistory(
            signature: signature.signature,
            timestamp: getTimestamp(txn.blockTime),
            instruction: instructionInfo!.copyWith(memo: memo),
            token: tokenMetadata,
          );
          transactions.add(history);
        }
      }

      return transactions.where((it) => it.instruction.amount != 0.0).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// ***********
  /// About token
  /// ***********

  /// Get Tokens By owner
  /// Return list of mint address
  Future<List<SplTokenAccountDataInfo>> getAllTokens(
      final String walletAddress) async {
    try {
      final now = DateTime.now();
      final tokenAccounts = await client.rpcClient.getTokenAccountsByOwner(
        walletAddress,
        TokenAccountsFilterByProgramId(TokenProgram.programId),
        encoding: Encoding.jsonParsed,
        commitment: Commitment.processed,
      );

      List<SplTokenAccountDataInfo> result = [];

      for (var tokenAccount in tokenAccounts.value) {
        final info = ((tokenAccount.account.data as ParsedAccountData).parsed
                as TokenAccountData)
            .info;

        result.add(info);
      }

      final getTokenTime = DateTime.now().difference(now).inSeconds;

      "[Get All Tokens] Time: $getTokenTime".log();

      return result;
    } catch (e) {
      e.log();
      rethrow;
    }
  }

  /// Get Token metadata
  /// Return [Map]
  Future<Map<String, String>> getTokenMetadata(final String tokenMint) async {
    final metadataPDA = await findMetadataPDA(tokenMint);
    final accountInfo = await client.rpcClient.getAccountInfo(
      metadataPDA,
      commitment: Commitment.processed,
      encoding: Encoding.base64,
    );

    Map<String, String> metadata = {};

    if (accountInfo.value != null) {
      metadata = decodeMetadata(
        (accountInfo.value!.data as BinaryAccountData).data,
      );
    } else {
      try {
        // Fallback on Jupiter
        _dio.options.baseUrl = dotenv.get(kJupiterApi);
        final result = await _dio.get('/tokens/v1/token/$tokenMint');
        if (result.statusCode == HttpStatus.ok) {
          metadata = {
            'updateAuthority': '',
            'mint': result.data['address'],
            'name': result.data['name'],
            'symbol': result.data['symbol'],
            'logoURI': result.data['logoURI'],
            'uri': '',
          };
        }

        // Fallback on Solana token list
      } catch (_) {
        final token = solanaTokenList['tokens']
            .firstWhere((it) => it['address'] == tokenMint, orElse: () => null);

        if (token != null) {
          metadata = {
            'updateAuthority': '',
            'mint': token['address'],
            'name': token['name'],
            'symbol': token['symbol'],
            'logoURI': token['logoURI'],
            'uri': '',
          };
        }
      }
    }

    return metadata;
  }

  /// Get All tokens
  /// Input [String]
  /// Return [List]
  Future<List<TokenBalanceInfoModel>> getAllTokenBalances(
      final String walletAddress) async {
    try {
      final tokens = await getAllTokens(walletAddress);
      final now = DateTime.now();

      List<TokenBalanceInfoModel> tokenBalances = [];

      final metadatas = await Future.wait(
          tokens.map((it) async => await getTokenMetadata(it.mint)).toList());

      final futures = await Future.wait([
        getPrices(coins: [kSolanaAddress, ...tokens.map((it) => it.mint)]),
        getBalance(walletAddress),
      ]);

      final prices = futures.first as Map;
      final solBalance = futures.last as double;
      final solInCurrency =
          solBalance * double.parse(prices[kSolanaAddress]['price']);

      final solana = TokenBalanceInfoModel(
        address: kSolanaAddress,
        associatedAccount: "",
        balance: solBalance,
        balanceInCurrency: solInCurrency,
        info: TokenInfo(
          name: "Solana",
          symbol: "SOL",
          image: "assets/images/solana-logo.png",
        ),
      );

      tokenBalances.add(solana);

      for (var metadata in metadatas) {
        final uri = metadata["uri"];

        String image = "https://placehold.co/50/png?text=${metadata['symbol']}";

        if (uri!.isNotEmpty) {
          _dio.options.baseUrl = uri;

          try {
            final result = await _dio.get("");
            image = result.data['image'];
          } catch (_) {}
        } else if (metadata['logoURI'] != null) {
          image = metadata['logoURI']!;
        } else {
          image =
              "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/${metadata["mint"]}/logo.png";
        }

        final token = tokens.where((it) => it.mint == metadata["mint"]).first;
        final tokenBalance = num.parse(token.tokenAmount.uiAmountString ?? '0');
        final price = prices[metadata["mint"]];
        double balanceInCurrency = 0;

        if (price != null) {
          balanceInCurrency = double.parse(price['price']) * tokenBalance;
        } else if (metadata["mint"] == dotenv.get(kTokenMint)) {
          balanceInCurrency = tokenBalance * 0.03;
        }

        Map<String, dynamic> json = {
          "address": metadata["mint"],
          "associatedAccount": "",
          "balance": tokenBalance,
          "balanceInCurrency": balanceInCurrency,
          "info": {
            "name": metadata["name"],
            "symbol": metadata["symbol"],
            "image": image,
          }
        };

        tokenBalances.add(TokenBalanceInfoModel.fromJson(json));
      }

      final getTokenTime = DateTime.now().difference(now).inSeconds;

      "[Get All Token Balances] Time: $getTokenTime".log();

      return tokenBalances;
    } catch (e) {
      e.log();
      throw Exception('Failed to fetch token balances: $e');
    }
  }

  /// Utils
  List<int> decodePrivateKey(final String source) {
    /// List
    if (source.startsWith("[") && source.endsWith("]")) {
      return List.from(json.decode(source));
    }

    /// Base 58
    try {
      return base58.base58decode(source);
    } catch (_) {}

    /// Base 64
    try {
      return base64Decode(source);
    } catch (_) {}

    throw Exception("Unable to decode source");
  }

  /// Find metadata PDA
  /// Return [String]
  Future<String> findMetadataPDA(final String address) async {
    const metadataAddress = "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s";

    final seeds = [
      "metadata".codeUnits,
      Ed25519HDPublicKey.fromBase58(metadataAddress).bytes,
      Ed25519HDPublicKey.fromBase58(address).bytes,
    ];

    final programId = Ed25519HDPublicKey.fromBase58(metadataAddress);

    final pda = await Ed25519HDPublicKey.findProgramAddress(
      seeds: seeds,
      programId: programId,
    );

    return pda.toBase58();
  }

  /// Decode metadata
  /// Return [Map]
  Map<String, String> decodeMetadata(final List<int> data) {
    final buffer = ByteData.sublistView(Uint8List.fromList(data));
    var offset = 0;

    offset += 1;

    final updateAuthority =
        base58.base58encode(data.sublist(offset, offset + 32));
    offset += 32;

    final mint = base58.base58encode(data.sublist(offset, offset + 32));
    offset += 32;

    // Read string lengths and data
    // For strings, first 4 bytes represent the length
    final nameLength = buffer.getUint32(offset, Endian.little);
    offset += 4;
    final name = String.fromCharCodes(
        data.sublist(offset, offset + nameLength).where((byte) => byte != 0));
    offset += nameLength;

    final symbolLength = buffer.getUint32(offset, Endian.little);
    offset += 4;
    final symbol = String.fromCharCodes(
        data.sublist(offset, offset + symbolLength).where((byte) => byte != 0));
    offset += symbolLength;

    final uriLength = buffer.getUint32(offset, Endian.little);
    offset += 4;
    final uri = String.fromCharCodes(
        data.sublist(offset, offset + uriLength).where((byte) => byte != 0));

    return {
      'updateAuthority': updateAuthority,
      'mint': mint,
      'name': name,
      'symbol': symbol,
      'uri': uri,
    };
  }

  /// Get token mint
  /// Return String
  Future<Ed25519HDPublicKey> getTokenMint(final String address) async {
    final accountInfo = await client.rpcClient.getAccountInfo(
      address,
      encoding: Encoding.base64,
    );
    final data = accountInfo.value!.data as BinaryAccountData;

    return Ed25519HDPublicKey(data.data.sublist(0, 32));
  }

  /// Calculate optimal fee
  Future<int> calculateOptimalFee() async {
    Future<double> getNetworkLoad() async {
      try {
        final performance =
            await client.rpcClient.getRecentPerformanceSamples(10);

        if (performance.isEmpty) return 0.5;

        double total = 0;
        for (var sample in performance) {
          final double utilisation = sample.numTransactions / sample.numSlots;
          total += utilisation;
        }

        return min(1.0, total / performance.length / 50000);
      } catch (e) {
        return 0.5;
      }
    }

    int computeDynamicFee(double networkLoad) {
      // Exponential fee scaling based on network load
      final double loadFactor = exp(4 * networkLoad) - 1;

      // Calculate fee with bounds
      final int dynamicFee = kBaseFee + (kBaseFee * loadFactor).round();
      return min(kMaxFee, max(kMinFee, dynamicFee));
    }

    final networkLoad = await getNetworkLoad();
    return computeDynamicFee(networkLoad);
  }

  /// Send token
  /// Input:
  ///   Sender Secret Key [String]
  ///   Recipient Secret Key [String]
  ///   Token mint address [String]
  ///   Amount to transfer [double]
  ///   Token decimals [int]
  ///   Memo: transaction description [String] or [Null]
  Future<String> transferToken({
    required String senderPrivateKey,
    required String recipientAddress,
    required String mintAddress,
    required double amount,
    String? memo,
  }) async {
    final funder = await getKeypairFromPrivateKey(senderPrivateKey);
    final owner = Ed25519HDPublicKey.fromBase58(recipientAddress);
    final mint = Ed25519HDPublicKey.fromBase58(mintAddress);
    final decimals = (await client.getMint(address: mint)).decimals;
    final rawAmount = BigInt.from(amount * pow(10, decimals)).toInt();

    int retry = 0, maxRetries = 3;

    while (retry < maxRetries) {
      try {
        final now = DateTime.now();

        final senderAta = await client.getAssociatedTokenAccount(
          mint: mint,
          owner: funder.publicKey,
          commitment: Commitment.confirmed,
        );

        final recipientAta = await client.getAssociatedTokenAccount(
          mint: mint,
          owner: owner,
          commitment: Commitment.confirmed,
        );

        if (recipientAta == null) {
          throw Exception("Recipient ATA not found");
        }

        int optimalFee = await calculateOptimalFee();

        final message = Message(
          instructions: [
            ComputeBudgetInstruction.setComputeUnitPrice(
              microLamports: optimalFee * 2,
            ),
            ComputeBudgetInstruction.setComputeUnitLimit(units: 200000),
            TokenInstruction.transferChecked(
              amount: rawAmount,
              decimals: decimals,
              source: Ed25519HDPublicKey.fromBase58(senderAta!.pubkey),
              destination: Ed25519HDPublicKey.fromBase58(recipientAta.pubkey),
              mint: mint,
              owner: funder.publicKey,
            ),
            if (memo != null) MemoInstruction(signers: [owner], memo: memo),
          ],
        );

        final signature = await client.rpcClient.signAndSendTransaction(
          message,
          [funder],
          commitment: Commitment.confirmed,
        );

        "[Transfer] signature: $signature".log();

        DateTime.now().difference(now).inSeconds.log();

        return signature;
      } on TimeoutException catch (_) {
        retry++;

        if (retry >= maxRetries) {
          "[Transfer] TimeoutException".log();
          rethrow;
        }

        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        "[Transfer] Error: $e".log();
        rethrow;
      }
    }

    throw Exception("Transfer failed unexpectedly");
  }

  /// Swap token
  /// Input:
  /// [String] senderPrivateKey
  /// [String] inputMint
  /// [String] outputMint
  /// [double] amount
  Future<void> swapToken({
    required String senderPrivateKey,
    required String inputMint,
    required String outputMint,
    required double amount,
  }) async {
    final sender = await getKeypairFromPrivateKey(senderPrivateKey);
    final input = Ed25519HDPublicKey.fromBase58(inputMint);
    final decimals = (await client.getMint(address: input)).decimals;
    final rawAmount = BigInt.from(amount * pow(10, decimals)).toInt();

    _dio.options.baseUrl = dotenv.get(kJupiterApi);

    try {
      final responseQuote = await _dio.get("/swap/v1/quote", queryParameters: {
        "inputMint": inputMint,
        "outputMint": outputMint,
        "amount": rawAmount,
        "slippageBps": 50,
      });
      final quote = responseQuote.data;

      final swapResponse = await _dio.post('/swap/v1/swap', data: {
        "quoteResponse": quote,
        "userPublicKey": sender.publicKey.toBase58(),
      });

      final swapTx = swapResponse.data;

      final swapTransactionBs58 =
          base58.base58encode(base64Decode(swapTx['swapTransaction']));

      final compiledMessage =
          CompiledMessage(ByteArray.fromString(swapTransactionBs58));

      final SignedTx signedTx = SignedTx(compiledMessage: compiledMessage);

      await client.rpcClient.sendTransaction(
        signedTx.encode(),
        preflightCommitment: Commitment.processed,
        maxRetries: 3,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// [String] address
  Future<void> createAssociatedTokenAccount({
    required final String senderPrivateKey,
    required final String recipientAddress,
    required final String mintAdress,
  }) async {
    final mint = Ed25519HDPublicKey.fromBase58(mintAdress);
    final owner = Ed25519HDPublicKey.fromBase58(recipientAddress);
    final sender = await getKeypairFromPrivateKey(senderPrivateKey);
    final now = DateTime.now();

    try {
      bool recipientHasATA = await client.hasAssociatedTokenAccount(
        mint: mint,
        owner: owner,
        commitment: Commitment.confirmed,
      );

      if (!recipientHasATA) {
        final derivedAddress = await findAssociatedTokenAddress(
          owner: owner,
          mint: mint,
          tokenProgramType: TokenProgramType.tokenProgram,
        );

        final createATAIx = AssociatedTokenAccountInstruction.createAccount(
          mint: mint,
          address: derivedAddress,
          owner: owner,
          funder: sender.publicKey,
        );

        final optimalFee = await calculateOptimalFee();

        final message = Message(
          instructions: [
            ComputeBudgetInstruction.setComputeUnitPrice(
              microLamports: (optimalFee * 2).toInt(),
            ),
            ComputeBudgetInstruction.setComputeUnitLimit(units: 100000),
            createATAIx,
          ],
        );

        final signature = await client.rpcClient.signAndSendTransaction(
          message,
          [sender],
          commitment: Commitment.confirmed,
        );

        "[ATA Creation] signature: $signature".log();

        DateTime.now().difference(now).inSeconds.log();

        final statuses = await client.rpcClient.getSignatureStatuses(
          [signature],
          searchTransactionHistory: true,
        ).value;

        if (statuses[0]?.confirmationStatus == Commitment.confirmed) {
          "[ATA Creation] Status confirmed".log();
        } else {
          "[ATA Creation] ${statuses[0]?.confirmationStatus.name}".log();
        }
      }
    } catch (e) {
      "[ATA Creation] Error: $e".log();
      rethrow;
    }
  }

  /// Subscribe to websocket
  void subscribeToWebsocket(final String address) {
    final subClient = client.createSubscriptionClient();

    subClient.accountSubscribe(address).listen((event) {
      event.toJson().log();
    });
  }
}
