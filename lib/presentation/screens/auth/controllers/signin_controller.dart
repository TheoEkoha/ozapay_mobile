import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';

class SigninController extends ChangeNotifier {
  final BuildContext context;

  SigninController(this.context);

  final formKey = GlobalKey<FormBuilderState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool showPassword = false;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void validate() {
    hideKeyboard();
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final value = formKey.currentState!.value;
      final params = LoginParams.fromJson(value);
      context.read<AuthBloc>().add(OnEmailAndPasswordVerified(params));
    } else {
      autovalidateMode = AutovalidateMode.onUserInteraction;
      notifyListeners();
    }
  }
}
