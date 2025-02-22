
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';

class PricingDropdown extends StatelessWidget {
  const PricingDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tarifs',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: FormBuilderDropdown<double>(
            name: 'price',
            initialValue: 50.0,
            style: Theme.of(context).textTheme.bodyMedium,
            icon: Padding(
              padding: const EdgeInsets.only(bottom: kSpacing, right: kSpacing),
              child: RotatedBox(
                quarterTurns: -45,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: kSpacing * 2,
                ),
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Offre tarifaire dès 50€',
              filled: false,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: darkGrey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkGrey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkGrey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkGrey),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            items: [50.0, 100.0, 200.0]
                .map(
                  (price) => DropdownMenuItem(
                    alignment: AlignmentDirectional.center,
                    value: price,
                    child: Text('Offre tarifaire dès $price€'),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}