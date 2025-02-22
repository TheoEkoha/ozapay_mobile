part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

final class OnWalletGot extends WalletEvent {
  const OnWalletGot();
}

final class OnWalletBalanceGot extends WalletEvent {
  final String? coin;

  const OnWalletBalanceGot({this.coin});
}

final class OnTokenGot extends WalletEvent {
  const OnTokenGot();
}

final class OnMnemonicGenerated extends WalletEvent {
  const OnMnemonicGenerated();
}

final class OnWalletCreated extends WalletEvent {
  const OnWalletCreated();
}

final class OnWalletImportedFromMnemonic extends WalletEvent {
  final String mnemonic;

  const OnWalletImportedFromMnemonic({
    required this.mnemonic,
  });
}

final class OnWalletImportedFromPrivateKey extends WalletEvent {
  final String privateKey;

  const OnWalletImportedFromPrivateKey({required this.privateKey});
}

final class OnWalletImportedFromAddress extends WalletEvent {
  final String address;

  const OnWalletImportedFromAddress({required this.address});
}

final class OnTransactionHistoryGot extends WalletEvent {
  final int? limit;

  const OnTransactionHistoryGot({this.limit});
}

final class OnTokenTransfered extends WalletEvent {
  final double amount;
  final String? memo, senderPrivateKey, recipientAddress, tokenAddress;

  const OnTokenTransfered({
    required this.amount,
    this.memo,
    this.senderPrivateKey,
    this.recipientAddress,
    this.tokenAddress,
  });
}

final class OnWalletDeleted extends WalletEvent {
  const OnWalletDeleted();
}

final class OnATACreated extends WalletEvent {
  final String? senderPrivateKey, recipientAddress, tokenAddress;

  const OnATACreated({
    this.senderPrivateKey,
    this.recipientAddress,
    this.tokenAddress,
  });
}

final class OnSubscribeToWebsocket extends WalletEvent {
  const OnSubscribeToWebsocket();
}
