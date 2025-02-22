import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import '../wallet_screen.dart';

class VerifyMnemonicScreen extends StatelessWidget {
  const VerifyMnemonicScreen({super.key});

  static const route = '/mnemonic-verification';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        switch (state.status) {
          case WalletGotStatus _:
            context.showSnackBar(
              "Vérification du portefeuille en cours...",
              persistent: true,
            );
            //context.read<WalletBloc>().add(OnSubscribeToWebsocket());
            context.read<WalletBloc>().add(OnATACreated());
            break;

          case ATACreatedStatus _:
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            context.showSnackBar("Portefeuille importé avec succès.");
            context.popUntil('/');
            context.push(WalletScreen.route);

            break;

          case ErrorStatus _:
            context.showSnackBar(state.error!.message.join("\n"), error: true);

          default:
            break;
        }
      },
      builder: (context, state) {
        void createWallet() {
          context.read<WalletBloc>().add(OnWalletCreated());
        }

        String mnemonic = state.mnemonic!;
        List<String> shuffledMnemonic = mnemonic.splitBySpace
          ..shuffle(Random.secure());

        return ScaffoldWithRoundedCorner(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: kSpacing * 4),

              // Title
              Text(
                'Vérifiez votre phrase secrète',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: kSpacing),

              //Description
              Text(
                'Cliquez sur les mots pour les replacer dans le bon ordre.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: kSpacing * 3),

              // Mnemonics
              FormBuilderField<List<String>>(
                name: 'mnemonic',
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 12) {
                    return "Phrase secrète invalide";
                  }
                  return null;
                },
                builder: (field) {
                  List<String> value = field.value ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: 180),
                        padding: EdgeInsets.all(kSpacing * 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F1F5),
                          borderRadius: BorderRadius.circular(kSpacing * 2),
                        ),
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: kSpacing * 1.5,
                              runSpacing: kSpacing * 2,
                              children: [
                                for (var word in value)
                                  InkWell(
                                    onTap: () {
                                      field.didChange([...value..remove(word)]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            kSpacing * 1.25),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: kSpacing * 1.5,
                                      ),
                                      child: Text(
                                        word,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (value.join(" ") == mnemonic) ...[
                              SizedBox(height: kSpacing * 2),
                              Text(
                                'Bravo, redirection vers votre portefeuille...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ]
                          ],
                        ),
                      ),
                      SizedBox(height: kSpacing * 2),

                      /// Shufffled mnemonic
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: kSpacing * 1.5,
                        runSpacing: kSpacing,
                        children: [
                          for (final String word in shuffledMnemonic)
                            FilterChip(
                              showCheckmark: false,
                              selected: value.contains(word),
                              onSelected: (selected) {
                                if (selected) {
                                  field.didChange([...value, word]);
                                }
                              },
                              selectedColor: Color(0xFFC8C8D3),
                              backgroundColor: Color(0xFFF0F1F5),
                              label: Text(word, style: TextStyle(fontSize: 12)),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kSpacing * 1.5),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: kSpacing * 3),
                      LoadingButton(
                        loading: state.status is LoadingStatus,
                        onPressed: value.join(" ") == state.mnemonic
                            ? createWallet
                            : null,
                        child:
                            Text(value.length == 12 ? 'Terminer' : 'Continuer'),
                      ),
                    ],
                  );
                },
                onChanged: (value) {
                  if (value?.join(" ") == mnemonic) {
                    createWallet();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on String? {
  List<String> get splitBySpace =>
      (this?.isNotEmpty ?? false) ? this!.split(' ') : [];
}
