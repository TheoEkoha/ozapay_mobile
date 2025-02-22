import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'
    hide FormBuilderCheckbox;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/screens/auth/controllers/signup_controller.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';
import 'package:provider/provider.dart';

class SignupChoice extends StatefulWidget {
  const SignupChoice({super.key});

  @override
  State<SignupChoice> createState() => _SignupChoiceState();
}

class _SignupChoiceState extends State<SignupChoice> {
  final validator = FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: "errors.required".tr()),
    FormBuilderValidators.equal(
      true,
      errorText: "errors.required".tr(),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "signup.choice.accountType",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ).tr(),
                const SizedBox(height: defaultPadding),
                FormBuilderField<String>(
                  name: 'role',
                  validator: FormBuilderValidators.required(),
                  initialValue: AccountRoleEnum.particular.name,
                  builder: (field) {
                    return InkWell(
                      splashColor: const Color(0xFFF0F1F5),
                      onTap: () {
                        final role =
                            AccountRoleEnum.particular.name == field.value
                                ? AccountRoleEnum.professional
                                : AccountRoleEnum.particular;

                        field.didChange(role.name);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(kSpacing * 1.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kSpacing * 2),
                          border: Border.all(
                            color: const Color(0xFF8B8B8B),
                            width: 1.25,
                          ),
                          color: const Color(0xFFF0F1F5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AccountRoleEnum.decoder(field.value ??
                                        AccountRoleEnum.particular.name)
                                    .title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ).tr(),
                            ),
                            const Icon(
                              OzapayIcons.caret_right,
                              size: kSpacing * 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpacing * 3),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "signup.choice.code",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ).tr(),
                const SizedBox(height: kSpacing * 1.5),
                FormBuilderTextField(
                  name: "code",
                  decoration: const InputDecoration(hintText: "Code Affilié"),
                ),
                const SizedBox(height: kSpacing * 2),
                const Text(
                  "signup.choice.contract",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ).tr(),
                const SizedBox(height: kSpacing * 1.5),
                FormBuilderCheckbox(
                  name: 'privacy',
                  validator: validator,
                  title: Text.rich(
                    style: Theme.of(context).textTheme.labelSmall,
                    TextSpan(
                      children: [
                        TextSpan(text: "signup.choice.privacy.1".tr()),
                        TextSpan(
                          text: "signup.choice.privacy.2".tr(),
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(text: "signup.choice.privacy.3".tr()),
                        TextSpan(
                          text: "signup.choice.privacy.4".tr(),
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(text: "signup.choice.privacy.5".tr()),
                        const TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kSpacing),
                FormBuilderCheckbox(
                  name: 'newsletter',
                  validator: validator,
                  title: Text.rich(
                    style: Theme.of(context).textTheme.labelSmall,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "signup.choice.newsletter".tr(),
                        ),
                        const TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kSpacing * 3),
                FilledButton(
                  onPressed: () {
                    context.read<SignupProvider>().validateFields(
                      (_) {
                        context.read<SignupProvider>().next();
                      },
                    );
                  },
                  child: const Text("buttons.continue").tr(),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpacing * 3),
          Text.rich(
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(text: "signup.choice.haveAccount".tr()),
                TextSpan(
                  text: "signin.title".tr(),
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.replace("/signin");
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
