import 'package:flutter/material.dart';

class WalletCurrencyChange extends StatelessWidget {
  final double percentage;
  const WalletCurrencyChange({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    bool isNegative = percentage.isNegative;
    final value = percentage.abs().toStringAsFixed(2);

    return Text.rich(
      TextSpan(
        text: isNegative ? "-" : "+",
        style: TextStyle(color: isNegative ? Colors.red : Color(0xFF00780E)),
        children: [
          TextSpan(
            text: "$value%",
            style: TextStyle(color: Colors.black, fontSize: 15),
          )
        ],
      ),
      style: TextStyle(fontWeight: FontWeight.w700),
    );
  }
}
