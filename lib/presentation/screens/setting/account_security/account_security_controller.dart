import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/data/params/auth/security/update_password_params.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:provider/provider.dart';

class AccountSecurityController {
  final formKey = GlobalKey<FormBuilderState>();
  final BuildContext context;
  AccountSecurityController(
    this.context,
  );

  void validate() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      context.read<UserBloc>().add(
            OnPasswordUpdated(
              params:
                  UpdatePasswordParams.fromJson(formKey.currentState!.value),
            ),
          );
    }
  }

  String? get passConf {
    formKey.currentState?.save();
    return formKey.currentState?.value['newPassword'];
  }
}
