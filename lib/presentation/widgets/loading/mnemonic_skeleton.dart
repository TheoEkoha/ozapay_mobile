import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';
import 'package:shimmer/shimmer.dart';

class MnemonicSkeleton extends StatelessWidget {
  const MnemonicSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Wrap(
        children: List.generate(
          12,
          (index) => Container(
            padding: EdgeInsets.all(kSpacing),
            margin: EdgeInsets.all(kSpacing),
            width: kSpacing * 8,
            height: kSpacing * 4,
            decoration: BoxDecoration(
              color: shimmerBaseColor,
              borderRadius: BorderRadius.circular(
                kSpacing * 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
