import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("fields.lastName", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'lastName',
          decoration: InputDecoration(
            hintText: "fields.lastNameHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.firstName", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'firstName',
          decoration: InputDecoration(
            hintText: "fields.firstNameHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.address", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'address',
          decoration: InputDecoration(
            hintText: "fields.addressHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.postalCode", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'postalCode',
          decoration: InputDecoration(
            hintText: "fields.postalCodeHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.city", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'city',
          decoration: InputDecoration(
            hintText: "fields.cityHint".tr(),
          ),
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          validator: FormBuilderValidators.required(),
        ),
      ],
    );
  }
}
