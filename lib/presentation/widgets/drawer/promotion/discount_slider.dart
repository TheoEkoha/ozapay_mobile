import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/screens/promotion/create/create_promotion_controller.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/rectangle_slider_thumb_shape.dart';
import 'package:ozapay/theme.dart';

class DiscountSlider extends StatelessWidget {
  const DiscountSlider({super.key, required this.controller});

  final CreatePromotionController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: kSpacing),
            child: Text(
              'Remise',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: kSpacing),
                    child: Text(
                      '${controller.discount.toInt()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(width: kSpacing * 2),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: kSpacing,
                        thumbShape: RectangleSliderThumbShape(
                          enabledWidth: 10.0,
                          enabledHeight: 20.0,
                          borderRadius: 30,
                        ),
                        inactiveTrackColor: disabledColor,
                      ),
                      child: FormBuilderSlider(
                        name: 'discount',
                        min: 0,
                        max: 100,
                        displayValues: DisplayValues.none,
                        decoration: InputDecoration(
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        initialValue: controller.discount,
                        onChanged: (value) {
                          controller.discountChanged(value!);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
