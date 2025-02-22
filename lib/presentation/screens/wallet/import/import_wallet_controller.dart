import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:solana/solana.dart';

enum ImportTypeEnum {
  mnemonic(
    "Généralement 12 mots (parfois 18 voir 24 mots)  séparés par des espaces simples",
  ),
  secretKey(
    "Entrez ici votre clé privée SOLANA. Celle-ci est stockée et cryptée directement dans votre smartphone !",
  ),
  address(
    "Entrez votre adresse publique SOLANA et lisez votre solde en toute sécurité.",
  );

  final String message;

  const ImportTypeEnum(this.message);
}

class ImportWalletController extends ChangeNotifier {
  ImportWalletController(this.context);

  final BuildContext context;
  final formKey = GlobalKey<FormBuilderState>();
  String? importedMnemonicPhrase;

  String? mnemonic;
  String? secretKey;
  String? address;

  Future<String?> copyPaste() async {
    final clipboard = await Clipboard.getData("text/plain");
    return clipboard?.text;
  }

  void updateField(ValueChanged<String?> didChange) {
    copyPaste().then(didChange).then(
      (_) {
        formKey.currentState?.save();
        final values = formKey.currentState?.value;
        values?.log();

        mnemonic = values?['mnemonic']?.trim();
        secretKey = values?['secretKey']?.trim();
        address = values?['address']?.trim();

        notifyListeners();
      },
    );
  }

  void importFromMnemonic() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final mnemonic =
          formKey.currentState!.value[ImportTypeEnum.mnemonic.name];

      bool isValid = bip39.validateMnemonic(mnemonic.trim());

      if (isValid) {
        context
            .read<WalletBloc>()
            .add(OnWalletImportedFromMnemonic(mnemonic: mnemonic));
      } else {
        formKey.currentState!.fields[ImportTypeEnum.mnemonic.name]
            ?.invalidate("Mnemonic invalide !");
      }
    }
  }

  void importFromSecretKey() {
    formKey.currentState?.save();
    final String secretKey =
        formKey.currentState!.value[ImportTypeEnum.secretKey.name];

    context
        .read<WalletBloc>()
        .add(OnWalletImportedFromPrivateKey(privateKey: secretKey.trim()));
  }

  void importFromAddress() {
    formKey.currentState?.save();
    final String address =
        formKey.currentState!.value[ImportTypeEnum.address.name];

    try {
      Ed25519HDPublicKey.fromBase58(address.trim());
      context
          .read<WalletBloc>()
          .add(OnWalletImportedFromAddress(address: address));
    } catch (_) {
      formKey.currentState!.fields[ImportTypeEnum.address.name]
          ?.invalidate("Adresse invalide !");
    }
  }
}
