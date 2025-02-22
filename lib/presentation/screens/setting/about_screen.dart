import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const route = '/setting/about';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      padding: EdgeInsets.all(kSpacing * 3),
      appBarTitle: 'Retour',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/golden_coin.png',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(height: kSpacing / 4),
                    Text(
                      LevelEnum.padawan.title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: kSpacing,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Divider(
              height: kSpacing * 6,
            ),
            Text(
              'À propos de Ozapay SAS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: kSpacing * 3),
            Text(
              'Ozapay est une entreprise de type holding immatriculée au registre des sociétés et ayant comme activité principale la gestion d’actifs et le développement de solutions financières.',
            ),
            SizedBox(height: kSpacing * 3),
            Text(
              'SIRET : 983 874 884 00015\nClef NIC : 00015\nDate de création : 24/01/2024\nRégulé EMI/PSAN via Linkcy SAS',
              textAlign: TextAlign.left,
            ),
            SizedBox(height: kSpacing * 4),
            Text(
              'INTRODUCTION',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: kSpacing * 3),
            Text(
              'Impulsé par l’ambition, la vision, le courage et la détermination de son Président-Fondateur Johan Decottignies, Ozapay a vue le jour en Janvier 2024 depuis la sublime capitale française, Paris. Notre vision ?',
            ),
            SizedBox(height: kSpacing * 3),
            Text(
              'Une plateforme de type “Super App” réunissant les besoins du quotidien et ayant comme principaux atouts de faciliter les paiements, les investissements, et le commerce de proximité à l’échelle mondiale !',
            ),
          ],
        ),
      ),
    );
  }
}
