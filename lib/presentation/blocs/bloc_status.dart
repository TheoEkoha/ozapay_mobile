sealed class BlocStatus {
  const BlocStatus();
}

final class IdleStatus extends BlocStatus {
  const IdleStatus();
}

final class ErrorStatus extends BlocStatus {
  const ErrorStatus();
}

final class LoadingStatus extends BlocStatus {
  const LoadingStatus();
}

final class LoadedStatus extends BlocStatus {
  const LoadedStatus();
}

final class EmptyStatus extends BlocStatus {
  const EmptyStatus();
}

final class CreatedStatus extends BlocStatus {
  const CreatedStatus();
}

final class UpdatedStatus extends BlocStatus {
  const UpdatedStatus();
}

final class DeletedStatus extends BlocStatus {
  const DeletedStatus();
}

final class WalletCreatedStatus extends BlocStatus {
  const WalletCreatedStatus();
}

final class WalletGotStatus extends BlocStatus {
  const WalletGotStatus();
}

final class NoWalletStatus extends BlocStatus {
  const NoWalletStatus();
}

final class WalletImportedStatus extends BlocStatus {
  const WalletImportedStatus();
}

final class MnemonicGeneratedStatus extends BlocStatus {
  const MnemonicGeneratedStatus();
}

final class TokenTransferedStatus extends BlocStatus {
  const TokenTransferedStatus();
}

final class AlreadyHaveGiftStatus extends BlocStatus {
  const AlreadyHaveGiftStatus();
}

final class WalletDeletedStatus extends BlocStatus {
  const WalletDeletedStatus();
}

final class AllTokenBalancesGotStatus extends BlocStatus {
  const AllTokenBalancesGotStatus();
}

final class WalletBalancesGotStatus extends BlocStatus {
  const WalletBalancesGotStatus();
}

final class TransactionHistoryGotStatus extends BlocStatus {
  const TransactionHistoryGotStatus();
}

final class ATACreatedStatus extends BlocStatus {
  const ATACreatedStatus();
}
