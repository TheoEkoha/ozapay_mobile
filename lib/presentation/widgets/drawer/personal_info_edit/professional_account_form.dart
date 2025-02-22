import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/screens/setting/personal_info/personal_info_controller.dart';
import 'package:ozapay/presentation/widgets/loading_button.dart';

class ProfessionalAccountForm extends StatelessWidget {
  const ProfessionalAccountForm(
      {super.key, required this.controller, required this.user});

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
            decoration: const InputDecoration(
              hintText: "Prénom de l'utilisateur",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.firstName(),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Nom du responsable",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'lastName',
            initialValue: user.lastName,
            decoration: const InputDecoration(
              hintText: "Nom du responsable",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.lastName(),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Dénomination",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'denomination',
            // initialValue: user.,
            decoration: const InputDecoration(
              hintText: "Ozalentour SAS",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.street(),
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "Domiciliation",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'domiciliation',
            initialValue: user.address,
            decoration: const InputDecoration(
              hintText: "Domiciliation",
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: kSpacing * 2),
          Text(
            "SIRET",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: kSpacing),
          FormBuilderTextField(
            name: 'siret',
            decoration: const InputDecoration(
              hintText: "879 402 238",
            ),
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.country(),
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
