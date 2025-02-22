import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';

class ProfessionalInfo extends StatelessWidget {
  const ProfessionalInfo({super.key});

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
        Text("fields.corporateName", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'denomination',
          decoration: InputDecoration(
            hintText: "fields.corporateNameHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.siret", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'siret',
          decoration: InputDecoration(
            hintText: "fields.siretHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.manager", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'lastName',
          decoration: InputDecoration(
            hintText: "fields.managerHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.proFirstName", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'firstName',
          decoration: InputDecoration(
            hintText: "fields.proFirstNameHint".tr(),
          ),
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing * 2),
        Text("fields.domiciliation", style: textStyle).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderTextField(
          name: 'address',
          decoration: InputDecoration(
            hintText: "fields.domiciliationHint".tr(),
          ),
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          validator: FormBuilderValidators.required(),
        ),
      ],
    );
  }
}
