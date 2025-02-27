import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;

  const Item({
    super.key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: leadingPadding),
        _Flag(
          country: country,
          showFlag: showFlag,
          useEmoji: useEmoji,
        ),
        const SizedBox(width: 12.0),
        Text(
          dialCode,
          textDirection: TextDirection.ltr,
          style: textStyle,
        ),
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  const _Flag({this.country, this.showFlag, this.useEmoji});

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Image.asset(
            country!.flagUri,
            width: 24.0,
            package: 'intl_phone_number_input',
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          )
        : const SizedBox.shrink();
  }
}
