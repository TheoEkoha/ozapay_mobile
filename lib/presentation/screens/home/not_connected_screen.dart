import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import '../auth/controllers/signup_controller.dart';

class NotConnectedScreen extends StatelessWidget {
  const NotConnectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state) {
          case AuthLoadingState _:
            return Center(child: CircularProgressIndicator());

          default:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(kSpacing * 2.5),
                  ),
                  margin: const EdgeInsets.all(defaultPadding)
                      .copyWith(top: kSpacing),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/card-bg-left.png",
                        height: 130,
                      ),
                      Positioned(
                        bottom: -8,
                        right: 0,
                        child: Image.asset(
                          "assets/images/card-bg-right.png",
                          height: 130,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kSpacing * 2.5,
                          vertical: defaultPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "dashboard.notConnected.welcome",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ).tr(),
                            const SizedBox(height: kSpacing * 2),
                            Text.rich(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "signin.title".tr(),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.push('/signin'),
                                  ),
                                  const TextSpan(text: " / "),
                                  TextSpan(
                                    text: "signup.title".tr(),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context
                                            .read<SignupProvider>()
                                            .resetStep();
                                        context.push('/signup');
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: kSpacing * 2),
                            Text(
                              "dashboard.notConnected.description",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ).tr(),
                            const SizedBox(height: kSpacing * 3),
                            GestureDetector(
                              onTap: () => {
                                context.push("/forgot-password")
                              }, child:
                            // Bouton "Mot de passe oublié" avec soulignement espacé
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.all(kSpacing),
                                child: Stack(
                                  children: [
                                    // Soulignement blanc, espacé de 2px sous le texte
                                    Positioned(
                                      bottom: -1,
                                      left: 0,
                                      child: Container(
                                        width: 140, // Ajuste la largeur en fonction du texte
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Texte
                                    Text(
                                      "signin.forgotPassword",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ),
                        )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kSpacing * 4),
                        topRight: Radius.circular(kSpacing * 4),
                      ),
                    ),
                    padding: const EdgeInsets.all(kSpacing * 3),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "dashboard.notConnected.why",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ).tr(),
                          const SizedBox(height: kSpacing * 3),
                          textRow(
                            Image.asset(
                              "assets/images/dashboard/credit-card.png",
                              width: kSpacing * 2,
                            ),
                            "dashboard.notConnected.1".tr(),
                          ),
                          const SizedBox(height: kSpacing * 3),
                          textRow(
                            Image.asset(
                              "assets/images/dashboard/transaction.png",
                              width: kSpacing * 2,
                            ),
                            "dashboard.notConnected.2".tr(),
                          ),
                          const SizedBox(height: kSpacing * 3),
                          textRow(
                            Image.asset(
                              "assets/images/dashboard/nfc.png",
                              width: kSpacing * 2,
                            ),
                            "dashboard.notConnected.3".tr(),
                          ),
                          const SizedBox(height: kSpacing * 3),
                          textRow(
                            Image.asset(
                              "assets/images/dashboard/digital-marketing.png",
                              width: kSpacing * 2,
                            ),
                            "dashboard.notConnected.4".tr(),
                          ),
                          const SizedBox(height: kSpacing * 3),
                          textRow(
                            Image.asset(
                              "assets/images/dashboard/solana.png",
                              width: kSpacing * 2,
                            ),
                            "dashboard.notConnected.5".tr(),
                          ),
                          const SizedBox(height: kSpacing * 3),
                          textRow(
                            Image.asset(
                              "assets/images/dashboard/win.png",
                              width: kSpacing * 2,
                            ),
                            "dashboard.notConnected.6".tr(),
                          ),
                          const SizedBox(height: kSpacing * .5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  Widget textRow(Widget icon, String title) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 27,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                offset: const Offset(0, 7),
                blurRadius: 14,
              )
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: icon,
        ),
        const SizedBox(width: kSpacing * 2),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Color(0xFF797979)),
          ),
        ),
      ],
    );
  }
}