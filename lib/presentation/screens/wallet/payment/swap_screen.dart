import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/theme.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  static final route = '/swap';

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = theme(context);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Container(
        padding: EdgeInsets.all(kSpacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kSpacing * 3),
            topRight: Radius.circular(kSpacing * 3),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Transform.rotate(
                    angle: -math.pi / 2,
                    child: Icon(OzapayIcons.caret_left),
                  ),
                ),
                Text(
                  "Convertir des cryptomonnaies",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: kSpacing * 2,
                  horizontal: kSpacing * 2,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(kSpacing * 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.16),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(5, 6),
                          )
                        ],
                      ),
                      child: Theme(
                        data: themeData.copyWith(
                          inputDecorationTheme:
                              themeData.inputDecorationTheme.copyWith(
                            contentPadding: EdgeInsets.all(kSpacing * 2),
                            border: InputBorder.none,
                            fillColor: Color(0xffF0F1F5),
                            hintStyle: themeData.textTheme.bodyLarge
                                ?.copyWith(color: Color(0xFF848688)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(kSpacing * 1.5),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "0",
                              ),
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: kSpacing),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                OzapayIcons.transfer,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: kSpacing),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "0",
                              ),
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: kSpacing * 4),
                    FilledButton(
                      onPressed: () {},
                      child: Text("Convertir"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
