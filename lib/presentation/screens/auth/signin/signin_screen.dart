import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/signin_controller.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late SigninController controller;

  bool passwordExpired = false;

  @override
  void initState() {
    setState(() {
      controller = SigninController(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("signin.title").tr()),
      body: GestureDetector(
        onTap: controller.hideKeyboard,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(kSpacing * 2),
          children: [
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return CustomCard(
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthErrorState) {
                        if (state.failure is UnAuthorizedFailure) {
                          setState(() {
                            passwordExpired = true;
                          });
                        }

                        context.showSnackBar(
                          state.failure.message.join(", "),
                          error: true,
                        );
                      }
                      if (state is AuthCodeRequested) {
                        context.pushReplacement("/signin/verify-code", extra: {
                          "input": controller.formKey.currentState
                              ?.fields['email']?.value as String?,
                          "service": CodeServiceEnum.signInVer,
                          "type": CodeTypeEnum.mail,
                        });
                      }
                    },
                    builder: (context, state) {
                      return FormBuilder(
                        key: controller.formKey,
                        autovalidateMode: controller.autovalidateMode,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "fields.email",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ).tr(),
                            const SizedBox(height: kSpacing * 1.5),
                            FormBuilderTextField(
                              name: "email",
                              decoration: InputDecoration(
                                hintText: "fields.emailHint".tr(),
                              ),
                              enableSuggestions: true,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: FormBuilderValidators.compose(
                                [
                                  FormBuilderValidators.required(
                                      errorText: "errors.required".tr()),
                                  FormBuilderValidators.email(
                                      errorText: "errors.email".tr()),
                                ],
                              ),
                            ),
                            const SizedBox(height: kSpacing * 3),
                            const Text(
                              "fields.password",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ).tr(),
                            const SizedBox(height: kSpacing * 1.5),
                            FormBuilderTextField(
                              name: "password",
                              decoration: InputDecoration(
                                hintText: "fields.passwordHint".tr(),
                              ),
                              obscureText: !controller.showPassword,
                              obscuringCharacter: "*",
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              validator: FormBuilderValidators.required(
                                  errorText: "errors.required".tr()),
                            ),
                            const SizedBox(height: kSpacing * 3),
                            LoadingButton(
                              loading: state is AuthLoadingState,
                              onPressed: passwordExpired
                                  ? () async {
                                      await launchUrl((Uri.parse(
                                          "https://popupfr.ozapay.me/?reset=true")));
                                      setState(() {
                                        passwordExpired = false;
                                      });
                                    }
                                  : controller.validate,
                              child: passwordExpired
                                  ? Text("Réinitialiser mot de passe")
                                  : Text("buttons.continue").tr(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: kSpacing * 5),
            GestureDetector(
              onTap: () {
                context.push("/signin/with-phone");
              },
              child: Text(
                "signin.button",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Color(0xFFB0B0BC)),
                textAlign: TextAlign.center,
              ).tr(),
            ),
            const SizedBox(height: kSpacing * 2),
            Text.rich(
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(text: "signin.noAccount".tr()),
                  TextSpan(
                    text: "signin.signIn".tr(),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.replace("/signup");
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
