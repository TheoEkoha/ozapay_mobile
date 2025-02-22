import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

class SettingScreenScaffold extends StatelessWidget {
  const SettingScreenScaffold({
    super.key,
    this.onBackButtonPressed,
    this.appBarTitle,
    this.padding,
    required this.body,
    this.appBarActions,
  });

  final void Function()? onBackButtonPressed;
  final String? appBarTitle;
  final Widget body;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? appBarActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: onBackButtonPressed ?? () => context.pop(),
          icon: Icon(OzapayIcons.caret_left),
        ),
        titleSpacing: 0,
        title: Text(
          appBarTitle ?? "Menu",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: appBarActions,
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        margin: EdgeInsets.only(top: kSpacing * 1.5),
        padding: padding,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
          ),
        ),
        child: body,
      ),
    );
  }
}
