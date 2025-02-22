import 'package:flutter/material.dart';
import 'package:ozapay/core/constants.dart';

class LoadingButton extends StatelessWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const LoadingButton({
    super.key,
    required this.loading,
    this.enabled = true,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: kSpacing * 2);

    return FilledButton(
      onPressed: (loading || !enabled) ? null : onPressed,
      style: style?.copyWith(padding: const WidgetStatePropertyAll(padding)) ??
          FilledButton.styleFrom(padding: padding),
      child: loading
          ? const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2,
              ),
            )
          : child,
    );
  }
}
