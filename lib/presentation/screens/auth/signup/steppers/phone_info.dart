import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class PhoneInfo extends StatelessWidget {
  final String? label;
  const PhoneInfo({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label != null ? label! : "fields.phone",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderPhone(
          name: "phone",
          decoration: InputDecoration(
            hintText: "fields.phoneHint".tr(),
          ),
          validator: FormBuilderValidators.required(),
        ),
      ],
    );
  }
}
