import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  static const route = '/setting/personal-info';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      appBarTitle: 'Retour',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacing * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        const CircleAvatar(radius: kSpacing * 3),
                        const SizedBox(width: kSpacing * 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Compte particulier",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: kSpacing * 2,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Offre ${OfferTypeEnum.liberty.title}  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Voir toutes les offres',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: kSpacing),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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
            const Divider(
              height: kSpacing * 6,
            ),
            Text(
              'Informations personnelles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: darkBlue,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: kSpacing * 3),
            const PersonalInfoForm()
          ],
        ),
      ),
    );
  }
}
