import 'package:isar/isar.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/services/encryption.dart';
import 'package:solana/solana.dart';

part 'local_user.g.dart';

@Collection(accessor: 'users')
class LocalUser {
  Id? id;
  int? userId;

  String? firstName, lastName, email, phone, refreshToken;

  UserWalletAccount? userWalletAccount;

  bool? isLogged;
}

@embedded
class UserWalletAccount {
  String? mnemonic, address;
  List<int>? secretKey;

  @ignore
  Future<Ed25519HDKeyPair?> get keypair async {
    try {
      if (mnemonic != null) {
        return await Ed25519HDKeyPair.fromMnemonic(
          Encryption.decryptMnemonic(mnemonic!),
          account: 0,
          change: 0,
        );
      }
      if (secretKey != null) {
        return await Ed25519HDKeyPair.fromPrivateKeyBytes(
            privateKey: Encryption.decryptSecretKey(secretKey!.sublist(0, 32)));
      }
    } catch (e) {
      "Get [Keypair] $e".log();
      throw Exception("Invalid mnemonic or secret key: $e");
    }

    return null;
  }
}
