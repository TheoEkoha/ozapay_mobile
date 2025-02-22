import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/screens/wallet/create/create_wallet_screen.dart';

import '../import/import_wallet_screen.dart';

class ActivateWalletBottomSheet extends StatelessWidget {
  const ActivateWalletBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kSpacing * 2),
          Text(
            'Activation du Portefeuille',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: kSpacing * 2),
          Image.asset('assets/images/wallet.png', height: 187),
          SizedBox(height: kSpacing * 2),
          buildTile(
            context: context,
            icon: Icon(Icons.add),
            title: 'Je n’ai pas de portefeuille',
            subtitle: 'Créer un Portefeuille Crypto (Solana)',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              context.replace(CreateWalletScreen.route);
            },
          ),
          SizedBox(height: kSpacing * 2),
          buildTile(
            context: context,
            icon: Icon(Icons.arrow_downward),
            title: 'J’ai déjà un portefeuille',
            subtitle: 'Importer mon Portefeuille Crypto (Solana)',
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              context.replace(ImportWalletScreen.route);
            },
          ),
          SizedBox(height: kSpacing),
        ],
      ),
    );
  }

  Widget buildTile(
      {required BuildContext context,
      required Widget icon,
      required String title,
      required String subtitle,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kSpacing,
          vertical: kSpacing * 1.75,
        ),
        margin: EdgeInsets.fromLTRB(kSpacing, kSpacing, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20).copyWith(topRight: Radius.zero),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.16),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(5, 6),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(.1),
              child: icon,
            ),
            SizedBox(width: kSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
