import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozapay/core/constants.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kSpacing * 3).copyWith(top: kSpacing * 2),
      height:
          MediaQuery.of(context).size.height - kToolbarHeight - (kSpacing * 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: kSpacing * 3,
              height: kSpacing / 2,
              margin: EdgeInsets.only(bottom: kSpacing * 2),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 26, 26, 35),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nouvelle notification',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SvgPicture.asset('assets/images/notification_bell.svg'),
              ],
            ),
            SizedBox(height: kSpacing * 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bienvenue chez Ozapay !',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '// Votre compte est actif et sécurisé',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SizedBox(height: kSpacing * 3),
            Text.rich(
              TextSpan(
                text: 'Merci pour votre ouverture de compte !',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  TextSpan(
                    text:
                        ' Vous faites parmi maintenant des premiers possésseurs de notre ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: 'super app de paiement. ',
                  )
                ],
              ),
            ),
            SizedBox(height: kSpacing * 3),
            Text.rich(
              TextSpan(
                text: 'Merci pour votre ouverture de compte !',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  TextSpan(
                    text:
                        ' Vous faites parmi maintenant des premiers possésseurs de notre ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: 'super app de paiement.',
                  )
                ],
              ),
            ),
            SizedBox(height: kSpacing * 3),
            Text.rich(
              TextSpan(
                text: 'INFO : ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary),
                children: [
                  TextSpan(
                    text:
                        ' C’est la dernière étape, activez votre portefeuille CRYPTO, ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text:
                        'gagnez 50 OZC et essayez notre version de démonstration !. ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )
                ],
              ),
            ),
            Divider(
              indent: kSpacing * 3,
              endIndent: kSpacing * 3,
              height: kSpacing * 6,
            ),
            FilledButton(
              onPressed: () {},
              child: Text('Activer mon Portefeuille'),
            ),
            // BlocBuilder<WalletBloc, WalletState>(
            //   builder: (context, state) {
            //     if (state is NoWalletAssociated) {
            //       return FilledButton(
            //         onPressed: () {
            //           context.pop();
            //           context.showBottomSheet(
            //             isScrollControlled: true,
            //             margin: EdgeInsets.zero,
            //             height: MediaQuery.sizeOf(context).height / 1.6,
            //             // padding: EdgeInsets.symmetric(horizontal: kSpacing),
            //             child: WalletActivationBottomSheet(),
            //           );
            //         },
            //         child: Text('Activer mon Portefeuille'),
            //       );
            //     }
            //     return SizedBox.shrink();
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
