import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/code_controller.dart';
import '../../controllers/signup_controller.dart';

class CodeInfo extends StatefulWidget {
  final String? input;
  final CodeTypeEnum type;
  final CodeServiceEnum service;

  const CodeInfo({
    super.key,
    this.input,
    required this.type,
    required this.service,
  });

  @override
  State<CodeInfo> createState() => _CodeInfoState();
}

class _CodeInfoState extends State<CodeInfo> {
  late CodeController controller;

  @override
  void initState() {
    setState(() {
      controller = CodeController(
        context,
        service: widget.service,
        type: widget.type,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final validator = FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: "errors.required".tr()),
      FormBuilderValidators.equalLength(6),
    ]);

    final loading = context.watch<AuthBloc>().state is AuthLoadingState;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        /// Request new code
        if (state is AuthCodeResentState) {
          controller.startTimer();
        }

        /// From signup
        if (state is AuthUserUpdatedState) {
          context.read<SignupProvider>().resetParams();
          context.read<SignupProvider>().next();
        }

        /// From signin
        if (state is AuthCodeVerifiedState) {
          if (state.tempToken != null) {
            context.read<AuthBloc>().add(OnUserSignedIn(state.tempToken!));
          }
        }

        /// User connect from signin
        if (state is AuthUserConnectedState) {
          context.read<UserBloc>().add(OnUserInfoFetched());
          context.pushReplacement("/");
        }

        if (state is AuthErrorState) {
          context.showSnackBar(
            state.failure.message.join(", "),
            error: true,
          );
          controller.errorController.add(ErrorAnimationType.shake);
          controller.codeController.clear();
          FormBuilder.of(context)
              ?.fields["code"]
              ?.invalidate("errors.code".tr());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCard(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "signup.smsCode.code",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ).tr(args: ["6"]),
                      const SizedBox(height: kSpacing * .5),
                      if (widget.input != null)
                        Text(
                          widget.input!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary),
                        ),
                      const SizedBox(height: kSpacing * 3),
                      FormBuilder(
                        key: widget.service == CodeServiceEnum.signInVer
                            ? controller.signInFormKey
                            : null,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: theme.inputDecorationTheme
                                .copyWith(filled: false),
                          ),
                          child: FormBuilderField<String>(
                            name: "code",
                            validator: validator,
                            builder: (field) {
                              return PinCodeTextField(
                                appContext: context,
                                length: 6,
                                keyboardType: TextInputType.number,
                                textStyle: theme.textTheme.bodyLarge,
                                enableActiveFill: true,
                                enablePinAutofill: true,
                                obscureText: true,
                                obscuringCharacter: '*',
                                showCursor: false,
                                useHapticFeedback: true,
                                pinTheme: PinTheme(
                                  activeColor: theme.colorScheme.secondary,
                                  activeFillColor: theme.colorScheme.secondary,
                                  selectedFillColor:
                                      theme.colorScheme.secondary,
                                  inactiveFillColor:
                                      theme.colorScheme.secondary,
                                  inactiveColor: theme.colorScheme.secondary,
                                  borderWidth: 1,
                                  errorBorderColor: Colors.red[700],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(borderRadius),
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
                                  ),
                                  shape: PinCodeFieldShape.box,
                                ),
                                errorTextSpace: 30,
                                beforeTextPaste: (text) => true,
                                controller: controller.codeController,
                                validator: validator,
                                errorAnimationController:
                                    controller.errorController,
                                onChanged: field.didChange,
                                onCompleted: (value) {
                                  controller.validateForm();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: kSpacing * 3),
                      LoadingButton(
                        loading: loading,
                        enabled: controller.codeController.text.isNotEmpty ||
                            (controller.codeController.text.isNotEmpty &&
                                controller.duration == Duration.zero),
                        onPressed: controller.validateForm,
                        child: const Text("buttons.continue").tr(),
                      ),
                      const SizedBox(height: kSpacing * 2),
                      Text(
                        "signup.smsCode.timer",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: greyColor),
                        textAlign: TextAlign.center,
                      ).tr(args: [controller.duration.inSeconds.toString()]),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: kSpacing * 5),
            ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      disabledForegroundColor: const Color(0xFFB0B0BC),
                    ),
                    onPressed: controller.duration != Duration.zero
                        ? null
                        : controller.requestNewCode,
                    child: const Text("signup.smsCode.resend").tr(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
