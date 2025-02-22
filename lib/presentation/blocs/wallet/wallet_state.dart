part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final double balance, percentage;
  final List<TokenBalanceInfoModel> tokenBalances;
  final Ed25519HDKeyPair? keypair;
  final Ed25519HDPublicKey? address;
  final Ed25519HDPublicKey? associatedTokenAccount;
  final BlocStatus status;
  final Failure? error;
  final String? mnemonic;
  final List<TransactionHistory> transactions;

  const WalletState({
    this.balance = 0.0,
    this.percentage = 0.0,
    this.tokenBalances = const [],
    this.keypair,
    this.address,
    this.associatedTokenAccount,
    this.status = const IdleStatus(),
    this.error,
    this.mnemonic,
    this.transactions = const [],
  });

  WalletState copyWith({
    double? balance,
    double? percentage,
    List<TokenBalanceInfoModel>? tokenBalances,
    Ed25519HDKeyPair? keypair,
    Ed25519HDPublicKey? address,
    Ed25519HDPublicKey? associatedTokenAccount,
    BlocStatus? status,
    Failure? error,
    String? mnemonic,
    List<TransactionHistory>? transactions,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      percentage: percentage ?? this.percentage,
      tokenBalances: tokenBalances ?? this.tokenBalances,
      keypair: keypair ?? this.keypair,
      address: address ?? this.address,
      associatedTokenAccount:
          associatedTokenAccount ?? this.associatedTokenAccount,
      status: status ?? this.status,
      error: error,
      mnemonic: mnemonic ?? this.mnemonic,
      transactions: transactions ?? this.transactions,
    );
  }

  factory WalletState.fromJson(Map<String, dynamic> json) => WalletState(
        balance: json['balance'],
        percentage: json['percentage'],
        tokenBalances: List.of(json['tokenBalances'])
            .map((it) => TokenBalanceInfoModel.fromJson(it))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "percentage": percentage,
        "tokenBalances": tokenBalances.map((it) => it.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        balance,
        percentage,
        tokenBalances,
        keypair,
        address,
        associatedTokenAccount,
        status,
        error,
        mnemonic,
        transactions,
      ];
}
