import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/blocs/bloc_status.dart';
import 'package:ozapay/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

import 'import_wallet_controller.dart';

class SecretOrAddressTabBarView extends StatefulWidget {
  final ImportWalletController controller;
  final ImportTypeEnum type;

  const SecretOrAddressTabBarView({
    super.key,
    required this.type,
    required this.controller,
  });

  @override
  State<SecretOrAddressTabBarView> createState() =>
      _SecretOrAddressTabBarViewState();
}

class _SecretOrAddressTabBarViewState extends State<SecretOrAddressTabBarView> {
  bool isDirty = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormBuilderTextField(
          name: widget.type.name,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kSpacing * 2),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kSpacing * 2),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kSpacing * 2),
              borderSide: BorderSide.none,
            ),
            suffixIconConstraints: BoxConstraints(
              maxWidth: 100,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                final field = widget
                    .controller.formKey.currentState?.fields[widget.type.name];
                if (field?.value == null || field!.value.isEmpty) {
                  if (field?.didChange != null) {
                    widget.controller.updateField(field!.didChange);
                  }

                  isDirty = true;
                } else {
                  field.reset();
                  isDirty = false;
                }

                setState(() {});
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: kSpacing * 2),
                  child: Text(
                    isDirty ? 'Supprimer' : 'Coller',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          enableSuggestions: true,
          enableInteractiveSelection: false,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.none,
        ),
        SizedBox(height: kSpacing * 2),
        Text(
          widget.type.message,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: kSpacing * 3),
        LoadingButton(
          enabled: isDirty,
          loading: context.watch<WalletBloc>().state.status is LoadingStatus,
          onPressed: () {
            if (widget.type == ImportTypeEnum.secretKey) {
              widget.controller.importFromSecretKey();
            } else {
              widget.controller.importFromAddress();
            }
          },
          child: Text('Importer'),
        ),
      ],
    );
  }
}
