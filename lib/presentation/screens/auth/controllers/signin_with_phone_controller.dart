import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SigninWithPhoneController extends ChangeNotifier {
  final BuildContext context;
  SigninWithPhoneController(this.context) {
    SmsAutoFill().getAppSignature.then((value) {
      appSignature = value;

      "[App Signature]: $appSignature".log();

      notifyListeners();
    });
  }

  final formKey = GlobalKey<FormBuilderState>();
  String? appSignature;

  void validate() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final values = formKey.currentState!.value;
      final params =
          RegisterParams.fromJson(values).copyWith(appSignature: appSignature);

      context.read<AuthBloc>().add(OnSignedWithPhone(params));
    }
  }
}
