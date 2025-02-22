import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import 'underline_input_field.dart';

class PromotionInfoForm extends StatelessWidget {
  const PromotionInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UnderlineInputField(
          label: 'Nom',
          fieldName: 'name',
          hintText: 'Établissement',
        ),
        SizedBox(
          height: kSpacing * 2,
        ),
        UnderlineInputField(
          label: 'Adresse',
          fieldName: 'address',
          hintText: 'Adresse complète',
        ),
        SizedBox(
          height: kSpacing * 2,
        ),
        UnderlineInputField(
          label: 'Validité',
          fieldName: 'validity',
          hintText: 'Jusqu’à désactivation manuelle',
          keyboardType: TextInputType.datetime,
        ),
      ],
    );
  }
}
