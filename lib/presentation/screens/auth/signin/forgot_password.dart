import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controllers/signin_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late SigninController controller;
  bool passwordExpired = false;
  String? message;

  @override
  void initState() {
    controller = SigninController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("signin.forgotPassword").tr()),
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
                        setState(() {
                          message = "Une erreur est survenue, merci de réessayer plus tard.";
                        });
                      }
                      if (state is AuthCodeRequested) {
                        setState(() {
                          message = "Un mail de réinitialisation a été envoyé.";
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
                            if (message != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: kSpacing),
                                child: Text(
                                  message!,
                                  style: TextStyle(
                                    color: message!.contains("erreur")
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            LoadingButton(
                              loading: state is AuthLoadingState,
                              onPressed: () async {
                                if (controller.formKey.currentState?.saveAndValidate() ?? false) {
                                  final String email = controller.formKey.currentState!.fields['email']!.value;

                                  final Map<String, dynamic> requestData = {
                                    'email': email, // Utiliser l'email du formulaire
                                    'url': "https://popupfr.ozapay.me/resetPassword",
                                  };

                                  try {
                                    final response = await http.post(
                                      Uri.parse('https://backoffice.ozapay.me/api/user/forgot'),
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                      body: json.encode(requestData),
                                    );

                                    if (response.statusCode == 200) {
                                      // Requête réussie
                                      setState(() {
                                        message = "Un mail de réinitialisation a été envoyé.";
                                      });
                                    } else if (response.statusCode == 500) {
                                      // Erreur 500
                                      setState(() {
                                        message = "Une erreur est survenue, merci de réessayer.";
                                      });
                                    } else {
                                      // Autres erreurs
                                      setState(() {
                                        message = "Une erreur est survenue, merci de réessayer plus tard.";
                                      });
                                    }
                                  } catch (e) {
                                    // Gérer les exceptions
                                    print('Exception : $e');
                                    setState(() {
                                      message = "Une erreur est survenue, merci de réessayer plus tard.";
                                    });
                                  }
                                }
                              },
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