import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ozapay/data/enums/enum.dart';

import '../../core/constants.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key, required this.offer, this.iconColor});

  final OfferTypeEnum offer;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          offer.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: kSpacing,
          ),
        ),
        SvgPicture.asset(
          'assets/icons/semi_ellipse.svg',
          colorFilter: ColorFilter.mode(iconColor ?? offer.color, BlendMode.srcIn),
        ),
      ],
    );
  }
}
