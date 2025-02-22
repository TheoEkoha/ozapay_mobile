import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:ozapay/core/ozapay/models/wallet_account.dart';
import 'package:ozapay/data/services/database/models/local_user.dart';
import 'package:ozapay/data/services/encryption.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import 'package:solana/solana.dart';

@singleton
class UserDatasource {
  final Isar _isar;

  UserDatasource(Isar isar) : _isar = isar;

  Future<LocalUser?> findByUserId(int userId) {
    return _isar.users.filter().userIdEqualTo(userId).findFirst();
  }

  Future<void> saveUser(
    int userId, {
    String? refreshToken,
    UserEntity? user,
  }) async {
    final userExist = await findByUserId(userId);

    if (userExist != null) {
      await _isar.writeTxn(
        () => _isar.users.put(
          userExist
            ..refreshToken = refreshToken
            ..firstName = user?.firstName
            ..lastName = user?.lastName
            ..email = user?.email
            ..phone = user?.phone
            ..isLogged = true,
        ),
      );
    } else {
      final newUser = LocalUser()
        ..userId = userId
        ..refreshToken = refreshToken
        ..firstName = user?.firstName
        ..lastName = user?.lastName
        ..email = user?.email
        ..phone = user?.phone
        ..isLogged = true;

      await _isar.writeTxn(() => _isar.users.put(newUser));
    }
  }

  Future<void> saveWallet(int userId, {required WalletAccount wallet}) async {
    final userExist = await findByUserId(userId);
    String? encryptedMnemonic;
    List<int>? encryptedSecretKey;

    if (wallet.mnemonic != null) {
      encryptedMnemonic = Encryption.encryptMnemonic(wallet.mnemonic!);
    }

    if (wallet.secretKey != null) {
      encryptedSecretKey = Encryption.encryptSecretKey(wallet.secretKey!);
    }

    final userWallet = UserWalletAccount()
      ..mnemonic = encryptedMnemonic
      ..secretKey = encryptedSecretKey
      ..address = wallet.address;

    if (userExist != null) {
      userExist
        ..isLogged = true
        ..userWalletAccount = userWallet;

      await _isar.writeTxn(
        () => _isar.users.put(userExist),
      );
    } else {
      throw UnAuthorizedWalletOperation("UnAuthorized operation");
    }
  }

  Future<Ed25519HDKeyPair?> getWallet(int userId) async {
    final user = await findByUserId(userId);

    return user?.userWalletAccount?.keypair;
  }

  Future<Ed25519HDPublicKey?> getAddress(int userId) async {
    final user = await findByUserId(userId);
    final address = user?.userWalletAccount?.address;
    return address != null ? Ed25519HDPublicKey.fromBase58(address) : null;
  }

  Future deleteWallet(int userId) async {
    final user = await findByUserId(userId);
    if (user != null) {
      _isar.writeTxn(() => _isar.users.put(user..userWalletAccount = null));
    }
  }

  Future<bool> loggedOutUser(int userId) async {
    final user = await findByUserId(userId);

    if (user != null) {
      await _isar.writeTxn(() => _isar.users.put(user
        ..isLogged = false
        ..refreshToken = null));

      return true;
    }

    return false;
  }
}

class UnAuthorizedWalletOperation implements Exception {
  final String message;

  UnAuthorizedWalletOperation(this.message);
}
