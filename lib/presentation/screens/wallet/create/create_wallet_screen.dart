import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

import 'generate_mnemonic_screen.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({super.key});

  static const route = '/create-wallet';

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool formIsValidated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithRoundedCorner(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: kSpacing * 4),

            // Title
            Text(
              'Sauvegarde du Portefeuille',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: kSpacing),

            // Description
            Text(
              'À la prochaine étape, veuillez noter votre phrase secrète dans un endroit sécurisée et si possible cryptée...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SvgPicture.asset('assets/images/create_wallet.svg'),

            // Checks
            Text(
              'Je comprends que...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: kSpacing * 2),

            FormBuilder(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormFieldCustomCheckboxTile(
                    name: 'check_1',
                    label: Text(
                      'Si je perds ma phrase secrète, mes fonds seront perdus pour toujours.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  FormFieldCustomCheckboxTile(
                    name: 'check_2',
                    label: Text(
                      'Si je partage ma phrase secrète à un tiers, mes fonds peuvent être volés.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  FormFieldCustomCheckboxTile(
                    name: 'check_3',
                    label: Text(
                      'Le support Ozapay ne me demandera JAMAIS ma phrase secrète.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: kSpacing),
            FilledButton(
              onPressed: validate,
              child: Text('Continuer'),
            ),
          ],
        ),
      ),
    );
  }

  void validate() {
    if (formKey.currentState?.validate() ?? false) {
      context.read<WalletBloc>().add(OnMnemonicGenerated());
      context.push(GenerateMnemonicScreen.route);
    }
  }
}

class FormFieldCustomCheckboxTile extends FormBuilderFieldDecoration<bool> {
  FormFieldCustomCheckboxTile({
    super.key,
    required super.name,
    required Widget label,
  }) : super(
          validator: FormBuilderValidators.isTrue(),
          builder: (field) {
            return GestureDetector(
              onTap: () {
                field.didChange(!(field.value ?? false));
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kSpacing,
                  vertical: kSpacing * 1.75,
                ),
                margin:
                    EdgeInsets.fromLTRB(0, 0, kSpacing * 1.25, kSpacing * 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: field.hasError
                        ? Colors.red.withOpacity(0.06)
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius)
                      .copyWith(topRight: Radius.zero),
                  boxShadow: [
                    BoxShadow(
                      color: field.hasError
                          ? Colors.red.withOpacity(0.16)
                          : Colors.grey.withOpacity(0.16),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(5, 6),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xFFEEF1F4),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          if (field.value ?? false)
                            SvgPicture.asset('assets/icons/check.svg'),
                        ],
                      ),
                    ),
                    SizedBox(width: kSpacing),
                    Expanded(child: label)
                  ],
                ),
              ),
            );
          },
        );
}
