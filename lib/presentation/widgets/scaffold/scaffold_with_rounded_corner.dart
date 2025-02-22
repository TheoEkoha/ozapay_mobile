import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';

import '../ozapay_icons.dart';

class ScaffoldWithRoundedCorner extends StatelessWidget {
  const ScaffoldWithRoundedCorner({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: kSpacing,
      ),
      body: Container(
        padding: EdgeInsets.all(kSpacing * 3),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kSpacing * 3),
            topRight: Radius.circular(kSpacing * 3),
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Row(
                children: [
                  Icon(OzapayIcons.caret_left, size: kSpacing * 2.5),
                  SizedBox(width: kSpacing * 0.5),
                  Text(
                    'Retour',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: kSpacing),
            Expanded(child: body)
          ],
        ),
      ),
    );
  }
}
