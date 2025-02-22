import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/loading_button.dart';

import 'import_wallet_controller.dart';

class MnemonicTabBarView extends StatelessWidget {
  final ImportWalletController controller;

  const MnemonicTabBarView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormBuilderField<String?>(
          name: ImportTypeEnum.mnemonic.name,
          validator: (value) {
            return (value?.splitBySpace ?? []).length >= 12
                ? null
                : "Phare secrète non valide";
          },
          builder: (field) {
            final mnemonics = field.value?.splitBySpace ?? [];

            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              padding: EdgeInsets.all(kSpacing * 2),
              decoration: BoxDecoration(
                color: Color(0xFFF0F1F5),
                borderRadius: BorderRadius.circular(kSpacing * 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: field.value == null
                          ? () {
                              controller.updateField(field.didChange);
                            }
                          : controller.formKey.currentState?.reset,
                      child: Text(
                        field.value == null ? 'Coller' : 'Supprimer',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: kSpacing * 2),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: kSpacing * 1.5,
                    children: [
                      for (final String word in mnemonics)
                        Chip(
                          label: Text(word, style: TextStyle(fontSize: 12)),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kSpacing * 2),
                          ),
                        ),
                    ],
                  ),
                  if (field.errorText != null) ...[
                    SizedBox(height: kSpacing),
                    Text(
                      field.errorText!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    )
                  ]
                ],
              ),
            );
          },
        ),
        SizedBox(height: kSpacing * 3),
        Text(
          ImportTypeEnum.mnemonic.message,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: kSpacing * 4),
        ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return LoadingButton(
                enabled: controller.mnemonic != null ||
                    (controller.mnemonic?.isNotEmpty ?? false),
                loading:
                    context.watch<WalletBloc>().state.status is LoadingStatus,
                onPressed: controller.importFromMnemonic,
                child: Text("Importer"),
              );
            }),
      ],
    );
  }
}

extension on String? {
  List<String> get splitBySpace =>
      (this?.isNotEmpty ?? false) ? this!.split(' ') : [];
}
