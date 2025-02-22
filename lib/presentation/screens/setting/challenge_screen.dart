import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/widgets/custom_card.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';
import 'package:ozapay/theme.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  static const route = '/setting/challenge';

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  void didChangeDependencies() {
    precacheImage(
      const AssetImage('assets/images/rewarded_people.png'),
      context,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacing * 3),
        child: Column(
          children: [
            Image.asset('assets/images/rewarded_people.png'),
            const SizedBox(height: kSpacing * 2),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Participez à notre 1er challenge et gagnez ',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                children: const [
                  TextSpan(
                    text: '50 OZC',
                    style: TextStyle(color: yellowColor),
                  ),
                  TextSpan(text: ' pour toute affiliation finalisée!'),
                ],
              ),
            ),
            const SizedBox(height: kSpacing * 2),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Partagez votre lien Affilié à vos amis et recevez ',
                style: Theme.of(context).textTheme.bodyMedium,
                children: const [
                  TextSpan(
                      text: '50 OZA',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        ' de bonus sur chaque personne invitée allant jusqu’au bout de la procédure !',
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpacing * 2),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: state.user?.code ?? ''),
                    );
                  },
                  child: const Text('Copier mon lien Affilié'),
                );
              },
            ),
            const SizedBox(height: kSpacing * 3),
            CustomCard(
              border: Border.all(color: disabledColor),
              child: Column(
                children: [
                  Text(
                    'Vous avez actuellement un total de ',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: kSpacing),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '5 Relations ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: redColor, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'affiliées via votre COMPTE',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpacing),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '250 OZC ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: yellowColor, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'déposé sur vos placements',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpacing * 3),
            Text(
              '*offre valable et réévaluable selon les stocks disponibles',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
