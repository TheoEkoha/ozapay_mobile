import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/screens/auth/signup/steppers/phone_info.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/signin_with_phone_controller.dart';

class SigninWithPhone extends StatefulWidget {
  const SigninWithPhone({super.key});

  @override
  State<SigninWithPhone> createState() => _SigninWithPhoneState();
}

class _SigninWithPhoneState extends State<SigninWithPhone> {
  late SigninWithPhoneController controller;

  bool passwordExpired = false;

  @override
  void initState() {
    setState(() {
      controller = SigninWithPhoneController(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("signin.title").tr(),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(kSpacing * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocListener<AuthBloc, AuthState>(
                  listenWhen: (previous, current) => previous != current,
                  listener: (context, state) {
                    if (state is AuthErrorState) {
                      if (state.failure is UnAuthorizedFailure) {
                        setState(() {
                          passwordExpired = true;
                        });
                      }
                    }

                    if (state is AuthPhonenumberRequested) {
                      context.pushReplacement("/signin/verify-code", extra: {
                        "input": controller.formKey.currentState?.value['phone']
                            as String?,
                        "service": CodeServiceEnum.signInVer,
                        "type": CodeTypeEnum.sms,
                      });
                    }
                  },
                  child: CustomCard(
                    child: FormBuilder(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PhoneInfo(
                            label: "signin.signinWithPhone",
                          ),
                          const SizedBox(height: kSpacing * 4),
                          LoadingButton(
                            loading: context.watch<AuthBloc>().state
                                is AuthLoadingState,
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
                    ),
                  ),
                ),
                const SizedBox(height: kSpacing * 4),
                GestureDetector(
                  onTap: () {
                    context.replace("/signin");
                  },
                  child: Text(
                    "signin.button2",
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
          );
        },
      ),
    );
  }
}
