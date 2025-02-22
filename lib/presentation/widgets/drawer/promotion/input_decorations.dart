import 'package:flutter/material.dart';
import 'package:ozapay/theme.dart';

class UnderlineInputDecoration extends InputDecoration {
  UnderlineInputDecoration({
    super.hintText,
    super.filled,
    super.contentPadding,
  }) : super(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red[700]!, width: 1.5),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red[700]!, width: 1.5),
          ),
        );
}

class OutlineInputDecoration extends InputDecoration {
  OutlineInputDecoration({
    super.hintText,
    super.filled,
    super.contentPadding,
  }) : super(
          hoverColor: primaryColor,
          labelStyle: TextStyle(color: primaryColor),
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
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red[700]!, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.red[700]!, width: 1.5),
          ),
        );
}
