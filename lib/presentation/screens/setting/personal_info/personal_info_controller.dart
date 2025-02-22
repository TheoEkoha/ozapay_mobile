import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/params/auth/register/register_params.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';

class PersonalInfoController {
  final formKey = GlobalKey<FormBuilderState>();

  final BuildContext context;
  PersonalInfoController(
    this.context,
  );

  void validate(int userId) {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      '${formKey.currentState?.value}'.log();
      final params = RegisterParams.fromJson(formKey.currentState!.value);
      context.read<UserBloc>().add(OnUserInfoUpdated(userId, params));
    }
  }
}
