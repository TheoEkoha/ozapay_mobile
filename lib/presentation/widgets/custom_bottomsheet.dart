import 'package:flutter/material.dart';
import 'package:ozapay/theme.dart';

class CustomBottomsheet extends StatelessWidget {
  final Widget child;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomBottomsheet({
    super.key,
    required this.child,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Grabber(),
          Flexible(child: child),
        ],
      ),
    );
  }
}

class Grabber extends StatelessWidget {
  const Grabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.0, bottom: 6),
      width: 25.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: Color(0xFF040404),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
