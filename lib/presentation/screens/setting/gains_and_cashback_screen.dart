import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/domain/entities/sales_reward_entity.dart';
import 'package:ozapay/presentation/widgets/custom_card.dart';
import 'package:ozapay/presentation/widgets/drawer/reward_summary_widget.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';
import 'package:ozapay/theme.dart';

class GainsAndCashbackScreen extends StatelessWidget {
  const GainsAndCashbackScreen({super.key});

  static const route = '/gains-and-cashbak';

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpacing * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Gains et Cashback',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: kSpacing * 2),
             Text.rich(
              TextSpan(
                text: 'Bravo cher ',
                children: [
                  TextSpan(
                    text: 'Johan',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    children: [
                      TextSpan(
                        text: ', continuez comme ça !',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpacing * 2),
            CustomCard(
              color: yellowColor,
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kSpacing * 3),
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/card-bg-left.png",
                      height: 100,
                    ),
                    Positioned(
                      bottom: -8,
                      right: 0,
                      child: Image.asset(
                        "assets/images/card-bg-right.png",
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kSpacing * 2.5),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Gains EUROS'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kSpacing),
                              child: Text(
                                '515,15€',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontSize: 32),
                              ),
                            ),
                            const Text('depuis le début')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kSpacing * 2),
            Text(
              'Votre code Affilié',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: kSpacing * 2),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: yellowColor),
                    ),
                    child: Text(
                      'OZA-JOHANDECO-2314',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600, color: greyDarker),
                    ),
                  ),
                ),
                const SizedBox(
                  width: kSpacing,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(text: 'OZA-JOHANDECO-2314'),
                      );
                    },
                    style:
                        OutlinedButton.styleFrom(backgroundColor: yellowColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/copy.png',
                          width: kSpacing * 3,
                        ),
                        Text(
                          'Copier',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kSpacing * 2,
            ),
            Row(
              children: [
                IconButton.outlined(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Image.asset('assets/images/share.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                  child: IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    icon: Image.asset('assets/images/telegram.png'),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  icon: Image.asset('assets/images/facebook_rounded.png'),
                ),
              ],
            ),
            const SizedBox(
              height: kSpacing * 3,
            ),
            Text(
              'Ventes et récompenses récentes',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            ...List.generate(
              rewards.length,
              (index) => RewardSummaryWidget(
                reward: rewards[index],
                isLastItem: index == rewards.length - 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}

final rewards = [
  SalesRewardEntity(
    amount: 50.0,
    date: DateTime(2024, 11, 10),
    from: 'User123',
    type: RewardType.cashback,
  ),
  SalesRewardEntity(
    amount: 100.0,
    date: DateTime(2024, 11, 12),
    from: 'RetailPartnerA',
    type: RewardType.payment,
  ),
  SalesRewardEntity(
    amount: 25.0,
    date: DateTime(2024, 11, 14),
    from: 'User456',
    type: RewardType.cashback,
  ),
  SalesRewardEntity(
    amount: 75.0,
    date: DateTime(2024, 11, 15),
    from: 'AffiliatePartnerB',
    type: RewardType.payment,
  ),
];
