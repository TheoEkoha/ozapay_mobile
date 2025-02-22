import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

enum SignupStepperEnum {
  choice("signup.steps.choice"),
  info("signup.steps.info"),
  phone("signup.steps.phone"),
  smsCode("signup.steps.smsCode"),
  email("signup.steps.email"),
  emailCode("signup.steps.emailCode"),
  pin("signup.steps.pin"),
  validatePin("signup.steps.validatePin");

  final String title;

  const SignupStepperEnum(this.title);
}

extension SignupStepperEnumExt on SignupStepperEnum {
  SignupStepperEnum next() {
    const values = SignupStepperEnum.values;
    final index = values.indexOf(this);
    return values[index + 1];
  }

  SignupStepperEnum prev() {
    const values = SignupStepperEnum.values;
    final index = values.indexOf(this);
    return values[index - 1];
  }

  bool get canNext {
    final index = SignupStepperEnum.values.indexOf(this);
    if (index == SignupStepperEnum.values.length - 1) return false;
    return true;
  }
}

enum AccountRoleEnum implements Equatable {
  professional("enum.accountRole.pro"),
  particular("enum.accountRole.user");

  final String title;

  const AccountRoleEnum(this.title);

  @override
  List<Object?> get props => [title];

  @override
  bool? get stringify => true;

  static AccountRoleEnum decoder(String input) {
    return {
      'particular': AccountRoleEnum.particular,
      'professional': AccountRoleEnum.professional,
    }[input]!;
  }
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CodeTypeEnum { sms, mail }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CodeServiceEnum { signUpVer, signInVer }

enum OfferTypeEnum {
  liberty('Liberty'),
  essential('Essentiel'),
  premium('Premium'),
  business('Business');

  final String title;

  const OfferTypeEnum(this.title);

  Color get color {
    switch (title) {
      case 'Liberty':
        return primaryColor;
      case 'Essentiel':
        return redColor;
      case 'Premium':
        return yellowColor;
      case 'Business':
        return businessOfferColor;
      default:
        return primaryColor;
    }
  }
}

enum LevelEnum {
  padawan('Padawan');

  final String title;

  const LevelEnum(this.title);
}

enum RewardType {
  cashback('Cashback'),
  payment('Paiement');

  final String title;
  const RewardType(this.title);

  String get iconName => title == 'Cashback' ? 'cash' : 'received_payement';

  Color get color => title == 'Cashback' ? primaryColor : redColor;
}

enum Status { init, loading, loaded, error }
