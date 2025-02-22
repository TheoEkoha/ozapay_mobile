import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';

class MultimediaPromotion extends StatelessWidget {
  const MultimediaPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Galerie multimédias",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          'Choisissez 4 photos et une vidéo pertinante',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w400),
        ),
        SizedBox(height: kSpacing * 2),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                4,
                (index) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(right: kSpacing * 2),
                    decoration: BoxDecoration(
                      color: disabledColor,
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topRight: Radius.zero),
                    ),
                    child: UnconstrainedBox(
                      child: Image.asset(
                        'assets/images/placeholder.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: disabledColor,
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topRight: Radius.zero),
                ),
                child: UnconstrainedBox(
                  child: Image.asset(
                    'assets/images/video_placeholder.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
