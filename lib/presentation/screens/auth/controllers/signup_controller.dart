import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class SignupProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  SignupStepperEnum currentStep = SignupStepperEnum.choice;
  Map<String, dynamic> previousValue = {};
  AccountRoleEnum? role;

  void prev() {
    currentStep = currentStep.prev();
    notifyListeners();
  }

  void next() {
    currentStep = currentStep.next();
    notifyListeners();
  }

  void resetStep() {
    currentStep = SignupStepperEnum.choice;
    notifyListeners();
  }

  void resetParams() {
    formKey.currentState?.reset();
  }

  void clearValue() {
    formKey.currentState?.reset();
  }

  void validateFields(ValueChanged<RegisterParams>? action) {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      if (currentStep == SignupStepperEnum.choice) {
        role = AccountRoleEnum.decoder(formKey.currentState?.value['role']);
      }
      if (currentStep == SignupStepperEnum.choice) {
        role = AccountRoleEnum.decoder(formKey.currentState?.value['role']);
      }

      if (action != null) {
        Map<String, dynamic> value = Map.from(formKey.currentState!.value);

        if (value['phone'] != null && value['phone'] is PhoneNumber) {
          value['phone'] = null;
        }

        final params = RegisterParams.fromJson(value);
        action(params);
      }
    }

    notifyListeners();
  }
}
