import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/widgets/custom_card.dart';

class CardBalance extends StatelessWidget {
  const CardBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 2.5,
      child: CustomCard(
        color: Theme.of(context).colorScheme.primary,
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
                padding: EdgeInsets.symmetric(
                        vertical: kSpacing * 1.25, horizontal: kSpacing * 2.5)
                    .copyWith(bottom: kSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'drawer.main.balanceInAccount',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ).tr(),
                        SvgPicture.asset('assets/icons/eye_filled.svg'),
                      ],
                    ),
                    SizedBox(height: kSpacing),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          BalanceParsing(0).balance,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'EUR',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: kSpacing),
                    Text(
                      'drawer.main.showTransactions',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ).tr(),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
