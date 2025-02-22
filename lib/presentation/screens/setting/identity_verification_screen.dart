import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  static const route = '/setting/identity-verification';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      padding: const EdgeInsets.all(kSpacing * 3),
      appBarTitle: 'Retour',
      body: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: kSpacing * 3),
              SizedBox(width: kSpacing * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Johan Decottignies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: kSpacing * 2,
                    ),
                  ),
                  Text(
                    'Compte vérifié',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Divider(
            height: kSpacing * 6,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Vérification d\'identité',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          // Center(child: Text('Waiting for LINKCY Back Office'))
        ],
      ),
    );
  }
}
