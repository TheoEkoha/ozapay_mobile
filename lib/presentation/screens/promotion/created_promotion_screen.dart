import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';

class CreatedPromotionScreen extends StatelessWidget {
  const CreatedPromotionScreen({super.key});

  static const route = '/promotion/created';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      body: ListView(
        padding: EdgeInsets.all(kSpacing * 3).copyWith(top: kSpacing * 5),
        children: [
          Text(
            'Votre offre a bien été soumise à modération.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Image.asset('assets/images/time.png'),
          Text(
            'Suivez son évolution via l’Espace Promotionnel accessible depuis votre Menu Ozapay',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: kSpacing * 2),
          FilledButton(
            onPressed: () {
              context.pushReplacement('/promotion');
            },
            child: Text('Retour à l’Espace Promotionnel'),
          ),
          SizedBox(height: kSpacing * 2),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Retour à l’accueil de mon compte',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
