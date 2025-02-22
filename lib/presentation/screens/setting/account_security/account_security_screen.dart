import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/user/user_bloc.dart';
import 'package:ozapay/presentation/screens/setting/account_security/account_security_controller.dart';
import 'package:ozapay/presentation/widgets/drawer/setting_screen_scaffold.dart';
import 'package:ozapay/presentation/widgets/loading_button.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  static const route = '/setting/account-security';

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  late final AccountSecurityController controller;

  @override
  void initState() {
    controller = AccountSecurityController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingScreenScaffold(
      padding: const EdgeInsets.all(kSpacing * 3),
      appBarTitle: 'Retour',
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.status is LoadedStatus) {
              context.showSnackBar(
                'Votre mot de passe a été mis à jour avec succès !',
              );
              return;
            }
            if (state.status is ErrorStatus) {
              context.showSnackBar(
                state.failure?.message.first ??
                    'Une erreur s\'est produite ! Veuillez réessayer !',
                error: true,
              );
            }
          },
          builder: (context, state) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: kSpacing * 3),
                      SizedBox(width: kSpacing * 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user?.displayName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: kSpacing * 2,
                            ),
                          ),
                          Text(
                            'Compte vérifié',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(height: kSpacing * 6),
                  Text(
                    'Sécurités du compte',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: kSpacing * 3),
                  Text(
                    "Mot de passe",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: kSpacing),
                  FormBuilderTextField(
                    name: 'oldPassword',
                    decoration: const InputDecoration(
                      hintText: "Mot de passe actuel",
                    ),
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    validator: FormBuilderValidators.required(
                        errorText: "errors.required".tr()),
                  ),
                  SizedBox(height: kSpacing * 2),
                  FormBuilderTextField(
                    name: 'newPassword',
                    decoration: InputDecoration(
                      hintText: "Nouveau mot de passe",
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.required(
                        errorText: "errors.required".tr()),
                  ),
                  SizedBox(height: kSpacing * 2),
                  FormBuilderTextField(
                    name: 'passwordConfirm',
                    decoration: InputDecoration(
                      hintText: "Confirmer le mot de passe",
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.required(
                        errorText: "errors.required".tr()),
                  ),
                  SizedBox(height: kSpacing * 3),
                  LoadingButton(
                    loading: state.status is LoadingStatus,
                    onPressed: () {
                      controller.validate();
                    },
                    child: Text("Sauvegarder"),
                  ),
                  SizedBox(height: kSpacing * 4),
                  Text(
                    'Sécurités du compte',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: kSpacing * 2),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Text(
                      'Modifier',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: kSpacing * 2,
                      ),
                    ),
                  ),
                  SizedBox(height: kSpacing * 4),
                  Text(
                    'Historique de l’appareil',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: kSpacing * 4),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/computer.svg'),
                      SizedBox(width: kSpacing),
                      Text('Le 27 Août 2024 à 15h depuis iPhone 15'),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
