import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class UnverifiedAccountScreen extends StatelessWidget {
  const UnverifiedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomsheet(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kSpacing * 3)
            .copyWith(bottom: kSpacing * 3),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "Transactions",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Voir plus +',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/account_activation.png'),
                Container(
                  padding: EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kSpacing * 3),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  child: Text(
                    'Vérifier mon compte et\ndéverrouiller toutes les\nfonctionnalités',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
