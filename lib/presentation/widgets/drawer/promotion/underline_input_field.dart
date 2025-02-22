import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/input_decorations.dart';


class UnderlineInputField extends StatelessWidget {
  const UnderlineInputField({
    super.key,
    required this.label,
    required this.fieldName,
    required this.hintText,
    this.textInputAction,
    this.keyboardType,
  });

  final String label;
  final String fieldName;
  final String hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: FormBuilderTextField(
            name: fieldName,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            onTapOutside: (point) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: UnderlineInputDecoration(
              hintText: hintText,
              filled: false,
              contentPadding: EdgeInsets.symmetric(horizontal: kSpacing),
            ),
            textInputAction: textInputAction ?? TextInputAction.next,
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }
}
