import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/custom_card.dart';
import 'package:ozapay/theme.dart';
import 'package:shimmer/shimmer.dart';

class DrawerSkeleton extends StatelessWidget {
  const DrawerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView(
        padding: const EdgeInsets.all(kSpacing * 3),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: kSpacing * 3,
                backgroundColor: shimmerBaseColor,
              ),
              const SizedBox(width: kSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    color: shimmerBaseColor,
                    width: 250,
                    margin: const EdgeInsets.only(bottom: 8, top: kSpacing),
                  ),
                  Container(
                    height: 5,
                    color: shimmerBaseColor,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: kSpacing * 3),
          CustomCard(
            color: shimmerBaseColor,
            child: SizedBox(
              height: 150,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: kSpacing * 4),
          ...List.generate(
            6,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: kSpacing * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: kSpacing * 5,
                          width: kSpacing * 5,
                          padding: const EdgeInsets.all(kSpacing),
                          margin: const EdgeInsets.only(right: kSpacing * 1.5),
                          decoration: BoxDecoration(
                            color: shimmerBaseColor,
                            borderRadius: const BorderRadius.all(
                                    Radius.circular(kSpacing))
                                .copyWith(topRight: const Radius.circular(0)),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10,
                              color: shimmerBaseColor,
                              width: 250,
                              margin: const EdgeInsets.only(
                                  bottom: 8, top: kSpacing),
                            ),
                            Container(
                              height: 5,
                              color: shimmerBaseColor,
                              width: 150,
                              margin: const EdgeInsets.only(bottom: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
