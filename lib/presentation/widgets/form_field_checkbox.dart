import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/constants.dart';

class FormBuilderCheckbox extends StatelessWidget {
  final String name;
  final String? Function(bool?)? validator;
  final Widget title;
  final bool? initialValue;
  final AutovalidateMode autovalidateMode;

  const FormBuilderCheckbox({
    super.key,
    required this.name,
    this.validator,
    required this.title,
    this.initialValue,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<bool>(
      name: name,
      validator: validator,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      builder: (field) {
        return InkWell(
          onTap: () {
            field.didChange(!(field.value ?? false));
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              errorText: field.errorText,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 30,
                  child: Checkbox(
                    value: field.value ?? false,
                    onChanged: field.didChange,
                  ),
                ),
                const SizedBox(width: kSpacing * 2),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(-8, 0),
                    child: title,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
