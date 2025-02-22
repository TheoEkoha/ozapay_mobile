import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/theme.dart';

class FormBuilderPhone extends StatelessWidget {
  final String name;
  final PhoneNumber? initialValue;
  final AutovalidateMode autovalidateMode;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final ValueChanged<PhoneNumber>? onChanged;

  const FormBuilderPhone({
    super.key,
    required this.name,
    this.initialValue,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.decoration,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final searchBoxDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: secondaryColor),
      ),
      prefixIcon: const Icon(
        Icons.search,
        size: kSpacing * 3,
        color: Color(0xFFBDBDBD),
      ),
      hintText: "Rechercher...",
      filled: true,
      fillColor: Colors.white,
    );

    return FormBuilderField<PhoneNumber>(
      name: name,
      autovalidateMode: autovalidateMode,
      valueTransformer: (value) => value?.phoneNumber,
      builder: (field) {
        return ValueListenableBuilder<_FormBuilderPhoneValue>(
          valueListenable: _FormBuilderPhoneState(
              field.value?.isoCode ?? initialValue?.isoCode),
          builder: (context, controller, __) {
            return InternationalPhoneNumberInput(
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                trailingSpace: false,
                setSelectorButtonAsPrefixIcon: true,
                useBottomSheetSafeArea: false,
                leadingPadding: kSpacing * 2,
                title: Text(
                  "Pays de résidence",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
                showDialCode: false,
                showFlags: true,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              keyboardAction: TextInputAction.next,
              keyboardType: const TextInputType.numberWithOptions(),
              selectorTextStyle: const TextStyle(
                color: Color(0xFFE35883),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              inputDecoration:
                  decoration?.copyWith(hintText: controller.phoneMask) ??
                      InputDecoration(hintText: controller.phoneMask),
              searchBoxDecoration: searchBoxDecoration,
              scrollPadding: const EdgeInsets.all(kSpacing * 2),
              autoValidateMode: autovalidateMode,
              errorMessage: "",
              ignoreBlank: true,
              initialValue:
                  field.value ?? initialValue ?? PhoneNumber(isoCode: 'FR'),
              validator: validator,
              onInputValidated: (value) {
                controller.inputIsValid = value;
              },
              onInputChanged: (value) {
                if (value.isoCode != controller.currentIsoCode ||
                    controller.currentIsoCode == null) {
                  controller.updatePhoneMask(value.isoCode);
                }
                if (controller.phoneNumber != value.phoneNumber) {
                  field.didChange(value);
                  if (onChanged != null) onChanged!(value);
                  controller.phoneNumber = value.phoneNumber;
                }
              },
              bottomSheetBackgroundColor:
                  Theme.of(context).scaffoldBackgroundColor,
              bottomSheetInitialSize: 1.0,
            );
          },
        );
      },
    );
  }
}

class _FormBuilderPhoneState extends ValueNotifier<_FormBuilderPhoneValue> {
  _FormBuilderPhoneState(String? countryCode)
      : super(_FormBuilderPhoneValue()) {
    init();
  }
}

class _FormBuilderPhoneValue {
  String? phoneMask;
  String? currentIsoCode;
  bool inputIsValid = false;
  String? phoneNumber;

  Future<void> updatePhoneMask(String? input) async {
    if (CountryManager().countries.isEmpty) {
      await init();
    }
    final country = CountryManager().countries.firstWhere(
      (country) {
        return country.countryCode == (input ?? "FR");
      },
    );

    phoneMask = country.exampleNumberMobileInternational.removePhoneIsoCode();
    currentIsoCode = country.countryCode;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FormBuilderPhoneValue &&
          runtimeType == other.runtimeType &&
          phoneMask == other.phoneMask &&
          currentIsoCode == other.currentIsoCode &&
          inputIsValid == other.inputIsValid &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode =>
      phoneMask.hashCode ^
      currentIsoCode.hashCode ^
      inputIsValid.hashCode ^
      phoneNumber.hashCode;
}

extension _RemoveIsoCode on String {
  removePhoneIsoCode() {
    return replaceAll(RegExp(r'^(\+\d+\s)?'), '');
  }
}
