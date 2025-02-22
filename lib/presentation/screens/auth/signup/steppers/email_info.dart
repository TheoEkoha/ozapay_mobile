import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';

class EmailInfo extends StatelessWidget {
  const EmailInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "fields.email",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: "email",
          decoration: InputDecoration(hintText: "fields.emailHint".tr()),
          keyboardType: TextInputType.emailAddress,
          enableSuggestions: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "errors.required".tr()),
            FormBuilderValidators.email(errorText: "errors.email".tr()),
          ]),
        ),
      ],
    );
  }
}
