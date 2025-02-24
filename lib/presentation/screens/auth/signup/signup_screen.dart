import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';

import '../controllers/signup_controller.dart';
import 'steppers/code_info.dart';
import 'steppers/email_info.dart';
import 'steppers/pin_info.dart';
import 'steppers/signup_choice.dart';
import 'steppers/signup_stepper.dart';
import 'steppers/user_info.dart';
import 'steppers/phone_info.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.select((SignupProvider provider) => provider);
    final currentStep =
        context.select((SignupProvider provider) => provider.currentStep);

    final role = context.select((SignupProvider provider) => provider.role);

    final enableCustomTitle = [
      SignupStepperEnum.pin,
      SignupStepperEnum.validatePin,
    ].any((e) => e == currentStep);

    final enableCustomBorder = [
      SignupStepperEnum.choice,
      SignupStepperEnum.smsCode,
      SignupStepperEnum.emailCode,
      SignupStepperEnum.pin,
      SignupStepperEnum.validatePin,
    ].any((e) => e == currentStep);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (currentStep == SignupStepperEnum.validatePin &&
            state is AuthUserUpdatedState) {
          context.pushReplacement("/");
          return;
        }

        if (state is AuthUserCreatedState ||
            state is AuthUserUpdatedState ||
            state is AuthCodeVerifiedState) {
          context.read<SignupProvider>().resetParams();
          context.read<SignupProvider>().next();
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: FormBuilder(
          key: provider.formKey,
          child: SignupStepper(
            currentStep: currentStep,
            customTitle: enableCustomTitle,
            customBuilder: enableCustomBorder,
            steps: [
              Step(
                title: Text(SignupStepperEnum.choice.title).tr(),
                content: const SignupChoice(),
              ),
              Step(
                title: Text(role == AccountRoleEnum.particular
                        ? "signup.steps.info"
                        : "signup.steps.proInfo")
                    .tr(),
                content: const UserInfo(),
              ),
              Step(
                title: Text(SignupStepperEnum.phone.title).tr(),
                content: PhoneInfo(params: provider.getRegisterParams()),
              ),
              Step(
                title: Text(SignupStepperEnum.smsCode.title).tr(),
                content: const CodeInfo(
                  service: CodeServiceEnum.signUpVer,
                  type: CodeTypeEnum.sms,
                ),
              ),
              Step(
                title: Text(SignupStepperEnum.email.title).tr(),
                content: const EmailInfo(),
              ),
              Step(
                title: Text(SignupStepperEnum.emailCode.title).tr(),
                content: const CodeInfo(
                  service: CodeServiceEnum.signUpVer,
                  type: CodeTypeEnum.mail,
                ),
              ),
              Step(
                title: Text(SignupStepperEnum.pin.title).tr(),
                content: const PinInfo(
                  step: SignupStepperEnum.pin,
                  fieldName: "pin",
                ),
              ),
              Step(
                title: Text(SignupStepperEnum.pin.title).tr(),
                content: const PinInfo(
                  step: SignupStepperEnum.validatePin,
                  fieldName: "confirmPin",
                ),
              ),
            ],
            onPop: () {
              if (currentStep.index != 0) {
                context.read<SignupProvider>().prev();
              } else {
                context.pop();
              }
            },
            onStepChanged: (params, step) async {
              switch (step) {
                /// if step is not inside it
                /// it has his proper controller
                case SignupStepperEnum.info:
                  onCreateUser(params.copyWith(code: ""));
                  break;
                case SignupStepperEnum.phone:
                  await updatePhone(params);
                  break;
                case SignupStepperEnum.email:
                  onPatchUser(
                    params.copyWith(forService: CodeServiceEnum.signUpVer),
                  );
                default:
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  void onCreateUser(RegisterParams params) {
    context.read<AuthBloc>().add(OnRegister(params));
  }

  void onPatchUser(RegisterParams params) {
    context.read<AuthBloc>().add(OnPatch(params));
  }

  Future<void> updatePhone(RegisterParams params) async {
    final appSignature = await SmsAutoFill().getAppSignature;

    "appSignature: $appSignature".log();

    onPatchUser(params.copyWith(
      appSignature: appSignature,
      forService: CodeServiceEnum.signUpVer,
    ));
  }
}
