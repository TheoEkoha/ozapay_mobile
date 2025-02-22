import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';

import '../ozapay_icons.dart';

class ScaffoldWithBackButton extends StatelessWidget {
  const ScaffoldWithBackButton({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            OzapayIcons.caret_left,
            size: kSpacing * 2.5,
          ),
        ),
        title: Text('Retour'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: kSpacing),
        padding: EdgeInsets.all(kSpacing * 3),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kSpacing * 3),
            topRight: Radius.circular(kSpacing * 3),
          ),
        ),
        child: body,
      ),
    );
  }
}
