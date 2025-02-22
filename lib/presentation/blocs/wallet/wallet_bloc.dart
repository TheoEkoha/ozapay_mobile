import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/core/ozapay/models/wallet_account.dart';
import 'package:ozapay/core/ozapay/ozapay.dart';
import 'package:ozapay/data/datasources/user_datasource.dart';
import 'package:ozapay/data/services/prefs/prefs_service.dart';
import 'package:solana/solana.dart';

import '../bloc_status.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends HydratedBloc<WalletEvent, WalletState> {
  final SolanaWalletProvider _solanaService;
  final UserDatasource _datasource;
  final PrefsService _prefs;

  WalletBloc(this._solanaService, this._datasource, this._prefs)
      : super(WalletState()) {
    on<OnTokenGot>(_onTokenGot, transformer: droppable());

    // import
    on<OnWalletImportedFromMnemonic>(_onWalletImportedFromMnemonic,
        transformer: droppable());
    on<OnWalletImportedFromPrivateKey>(_onWalletImportedFromPrivateKey,
        transformer: droppable());
    on<OnWalletImportedFromAddress>(_onWalletImportedFromAddress,
        transformer: droppable());

    // Balance
    on<OnWalletBalanceGot>(_onGetWalletBalance, transformer: droppable());
    on<OnWalletGot>(_onWalletGot, transformer: droppable());

    // Create
    on<OnMnemonicGenerated>(_onMnemonicGenerated, transformer: droppable());
    on<OnWalletCreated>(_onWalletCreated, transformer: droppable());
    on<OnATACreated>(_onATACreated);

    // Transaction
    on<OnTransactionHistoryGot>(_onTransactionHistoryGot,
        transformer: droppable());
    on<OnTokenTransfered>(_onTokenTransfered, transformer: droppable());
    on<OnWalletDeleted>(_onWalletDeleted);
    on<OnSubscribeToWebsocket>(_onSubscribeToWebsocket);
  }

  int? get _userId => _prefs.getUserId();

  String? get address => state.keypair?.address ?? state.address?.toBase58();

  // Get Wallet Address
  _onWalletGot(OnWalletGot event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    final keypair = await _datasource.getWallet(_userId!);
    final address = await _datasource.getAddress(_userId!);

    emit(state.copyWith(
      status: keypair != null || address != null
          ? WalletGotStatus()
          : NoWalletStatus(),
      keypair: keypair,
      address: address,
      error: null,
    ));
  }

  // Import from mnemonic
  _onWalletImportedFromMnemonic(
      OnWalletImportedFromMnemonic event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      await _datasource
          .saveWallet(_userId!, wallet: WalletAccount(mnemonic: event.mnemonic))
          .then((_) {
        emit(state.copyWith(
          status: WalletImportedStatus(),
          error: null,
        ));
      });
    } on UnAuthorizedWalletOperation catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure([e.message]),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Error importing wallet"]),
      ));
    }
  }

  // Import from secret key
  _onWalletImportedFromPrivateKey(
      OnWalletImportedFromPrivateKey event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      final secretKey = _solanaService.decodePrivateKey(event.privateKey);
      await _datasource
          .saveWallet(_userId!, wallet: WalletAccount(secretKey: secretKey))
          .then((_) {
        emit(state.copyWith(
          status: WalletImportedStatus(),
          error: null,
        ));
      });
    } on UnAuthorizedWalletOperation catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: WalletFailure([e.message]),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Erreur pendant l'importation du wallet"]),
      ));
    }
  }

  // Import from address
  _onWalletImportedFromAddress(OnWalletImportedFromAddress event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      await _datasource
          .saveWallet(_userId!, wallet: WalletAccount(address: event.address))
          .then((_) {
        emit(state.copyWith(
          status: WalletImportedStatus(),
          error: null,
        ));
      });
    } on UnAuthorizedWalletOperation catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: WalletFailure([e.message]),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Erreur pendant l'importation du wallet"]),
      ));
    }
  }

  // Generate new keypair
  _onMnemonicGenerated(OnMnemonicGenerated event, emit) {
    try {
      emit(state.copyWith(
        mnemonic: _solanaService.generateMnemonic(),
        status: MnemonicGeneratedStatus(),
      ));

      state.mnemonic?.log();
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Error when generate mnemonic"]),
      ));
    }
  }

  // Create wallet
  _onWalletCreated(OnWalletCreated event, emit) async {
    try {
      await _datasource
          .saveWallet(_userId!, wallet: WalletAccount(mnemonic: state.mnemonic))
          .then((_) {
        add(OnWalletGot());
      });
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Getting Balance error"]),
      ));
    }
  }

  // Deleta wallet
  _onWalletDeleted(OnWalletDeleted event, emit) async {
    await _datasource.deleteWallet(_userId!);

    emit(state.copyWith(status: WalletDeletedStatus()));
  }

  // Get Token balances
  _onTokenGot(OnTokenGot event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      final tokenBalances = await _solanaService.getAllTokenBalances(address!);

      emit(state.copyWith(
        status: AllTokenBalancesGotStatus(),
        tokenBalances: tokenBalances,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Getting Token balances error"]),
      ));
    }
  }

  // Get SOL Balance
  _onGetWalletBalance(OnWalletBalanceGot event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      double balance = state.tokenBalances
          .fold(0.0, (prev, el) => prev + el.balanceInCurrency);

      emit(state.copyWith(
        status: WalletBalancesGotStatus(),
        balance: balance,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: UncategorizedFailure(["Getting Balance error"]),
      ));
    }
  }

  // Get Transactions
  _onTransactionHistoryGot(OnTransactionHistoryGot event, emit) async {
    try {
      emit(state.copyWith(
        status: LoadingStatus(),
        error: null,
      ));

      final txn =
          await _solanaService.getTransactionHistory(address!, event.limit);

      emit(state.copyWith(
        status: txn.isEmpty ? EmptyStatus() : TransactionHistoryGotStatus(),
        transactions: txn,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error:
            WalletFailure(['Erreur lors de la récupération des transactions']),
      ));
    }
  }

  // Airdrop or transfer token
  _onTokenTransfered(OnTokenTransfered event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      await _solanaService
          .transferToken(
        senderPrivateKey:
            event.senderPrivateKey ?? dotenv.get(kSenderPrivateKey),
        recipientAddress: event.recipientAddress ?? address!,
        mintAddress: event.tokenAddress ?? dotenv.get(kTokenMint),
        amount: event.amount,
        memo: event.memo,
      )
          .then((signature) {
        signature.log();

        _prefs.prefs.setBool(kWalletAidroped, true);

        emit(state.copyWith(status: TokenTransferedStatus()));
      });
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: WalletFailure(['Envoi de token impossible']),
      ));
    }
  }

  // Create ata
  _onATACreated(OnATACreated event, emit) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      error: null,
    ));

    try {
      await _solanaService
          .createAssociatedTokenAccount(
        senderPrivateKey: dotenv.get(kSenderPrivateKey),
        recipientAddress: address!,
        mintAdress: dotenv.get(kTokenMint),
      )
          .then(
        (_) {
          emit(state.copyWith(
            status: ATACreatedStatus(),
            error: null,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: ErrorStatus(),
        error: WalletFailure(['Une erreur est survenue']),
      ));
    }
  }

  _onSubscribeToWebsocket(OnSubscribeToWebsocket event, emit) {
    _solanaService.subscribeToWebsocket(address!);
  }

  @override
  void onEvent(WalletEvent event) {
    "[Wallet] $event".log();
    super.onEvent(event);
  }

  @override
  WalletState? fromJson(Map<String, dynamic> json) =>
      WalletState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(WalletState state) => state.toJson();
}
