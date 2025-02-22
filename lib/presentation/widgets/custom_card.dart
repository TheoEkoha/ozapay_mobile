import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BoxBorder? border;

  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.border,
    this.padding = const EdgeInsets.all(kSpacing * 2.5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(kSpacing * 3),
        border: border
      ),
      padding: padding,
      child: child,
    );
  }
}
