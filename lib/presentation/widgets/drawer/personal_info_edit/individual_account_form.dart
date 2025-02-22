import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/screens/setting/personal_info/personal_info_controller.dart';

import '../../loading_button.dart';

class IndividualAccountForm extends StatelessWidget {
  const IndividualAccountForm({
    super.key,
    required this.controller,
    required this.user,
  });

  final PersonalInfoController controller;
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Prénom",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'firstName',
            initialValue: user.firstName,
            decoration: InputDecoration(
              hintText: user.firstName ?? "Votre prénom",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.conditional(
              (v) => v?.isNotEmpty ?? false,
              FormBuilderValidators.firstName(),
            ),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Nom",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'lastName',
            initialValue: user.lastName,
            decoration: InputDecoration(
              hintText: user.lastName ?? "Nom de l'utilisateur",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.conditional(
              (v) => v?.isNotEmpty ?? false,
              FormBuilderValidators.lastName(),
            ),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Adresse",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'address',
            initialValue: user.address,
            decoration: const InputDecoration(
              hintText: "Adresse (rue...)",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.conditional(
              (v) => v?.isNotEmpty ?? false,
              FormBuilderValidators.street(),
            ),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Ville",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'city',
            initialValue: user.city,
            decoration: const InputDecoration(
              hintText: "Ville",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.conditional(
              (v) => v?.isNotEmpty ?? false,
              FormBuilderValidators.city(),
            ),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Pays",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'country',
            initialValue: user.country,
            decoration: const InputDecoration(
              hintText: "Pays",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.conditional(
              (v) => v?.isNotEmpty ?? false,
              FormBuilderValidators.country(),
            ),
          ),
          const SizedBox(height: kSpacing * 3),
          LoadingButton(
            loading: context.watch<UserBloc>().state.status is LoadingStatus,
            onPressed: () {
              controller.validate(user.id!);
            },
            child: const Text("Sauvegarder"),
          ),
        ],
      ),
    );
  }
}
