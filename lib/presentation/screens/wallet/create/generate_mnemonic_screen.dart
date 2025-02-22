import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import 'verify_mnemonic_screen.dart';

class GenerateMnemonicScreen extends StatelessWidget {
  const GenerateMnemonicScreen({super.key});

  static const route = '/generate-mnemonic-phrase';

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithRoundedCorner(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: kSpacing * 4),
          // Title
          Text(
            'Votre phrase secrète',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: kSpacing),

          //Description
          Text(
            'Écrivez ou copiez ces mots dans le bon ordre et enregistrez-les dans un endroit sûr (ex : lastpass...)',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: kSpacing * 3),

          // Generated mnemonic
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              final List<String> mnemonics =
                  (state.mnemonic?.isNotEmpty ?? false)
                      ? state.mnemonic!.split(' ')
                      : [];

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: kSpacing * 1.5,
                children: [
                  for (final String word in mnemonics)
                    Chip(
                      backgroundColor: Color(0xFFF0F1F5),
                      label: Text(word, style: TextStyle(fontSize: 12)),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kSpacing * 2),
                      ),
                    ),
                ],
              );
            },
          ),

          Spacer(),
          Container(
            padding: EdgeInsets.all(kSpacing * 2),
            decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(borderRadius)
                    .copyWith(topRight: Radius.zero),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(5, 6),
                  ),
                ]),
            child: Text(
              'Ne donnez jamais votre phrase secrète, car elle donne un accès complet à votre portefeuille !\n\nLe support OZAPAY ne vous contactera JAMAIS pour vous la demander',
              style: TextStyle(
                color: redColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: kSpacing * 3),
          FilledButton(
            onPressed: () {
              final mnemonic = context.read<WalletBloc>().state.mnemonic;
              if (mnemonic != null) {
                context.push(VerifyMnemonicScreen.route);
              }
            },
            child: Text('Continuer'),
          ),
        ],
      ),
    );
  }
}
