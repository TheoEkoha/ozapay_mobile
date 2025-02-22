import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ozapay/theme.dart';

import 'constants.dart';

extension LogExt on Object {
  void log([Level? level, Object? error, StackTrace? stackTrace]) {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        noBoxingByDefault: true,
      ),
    );

    if (level == Level.error) {
      logger.e(
        toString(),
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      logger.i(
        toString(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

extension BuildContextExt on BuildContext {
  Future<T?> showBottomSheet<T>({
    required Widget child,
    dynamic title,
    bool showDragHandle = true,
    double? height,
    bool enableDrag = true,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool useRootNavigator = false,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return showModalBottomSheet(
      context: this,
      showDragHandle: showDragHandle,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) {
        return Container(
          padding:
              padding ?? const EdgeInsets.all(kSpacing * 3).copyWith(top: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              title != null
                  ? title is! Widget
                      ? Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : title
                  : const SizedBox.shrink(),
              if (title != null) const SizedBox(height: kSpacing * 2),
              Flexible(child: child),
            ],
          ),
        );
      },
    );
  }

  Future<void> showSnackBar(
    String title, {
    bool error = false,
    bool persistent = false,
    bool fromTop = false,
    Widget? icon,
  }) async {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: error
            ? Colors.red
            : persistent
                ? Colors.black
                : Colors.black87,
        shape: persistent
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kSpacing),
              ),
        duration:
            persistent ? const Duration(hours: 1) : const Duration(seconds: 3),
        padding: EdgeInsets.symmetric(
            horizontal: kSpacing * 2, vertical: kSpacing * 1.5),
        behavior:
            persistent ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
        dismissDirection: persistent
            ? DismissDirection.none
            : fromTop
                ? DismissDirection.up
                : DismissDirection.down,
        content: Row(
          children: [
            error
                ? const Icon(Icons.warning_sharp, color: Colors.white)
                : icon ?? const SizedBox.shrink(),
            SizedBox(width: error ? kSpacing / 2 : 0),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: persistent ? TextAlign.center : TextAlign.start,
              ),
            ),
          ],
        ),
        margin: persistent
            ? null
            : fromTop
                ? const EdgeInsets.all(kSpacing)
                : null,
      ),
    );
  }

  popUntil(String page) {
    final router = GoRouter.of(this);
    final GoRouterDelegate delegate = router.routerDelegate;
    final routes = delegate.currentConfiguration.routes;
    for (var i = routes.length - 1; i >= 0; i--) {
      final route = routes[i] as GoRoute;
      if (route.path == page) break;

      if (canPop()) {
        GoRouter.of(this).pop();
      }
    }
  }
}

extension BalanceParsing on num {
  String get balance => NumberFormat("#,##0.00", "fr-FR").format(this);

  String get balanceCurrency => NumberFormat.currency(
          locale: "fr", symbol: "EUR", customPattern: "#,##0.00 ¤")
      .format(this);
}

extension StringExt on String {
  get truncatedAddress =>
      isEmpty ? "" : "${substring(0, 4)}...${substring(length - 4)}";
}

extension GoRouterEx on GoRouter {
  String get currentPath => routeInformationProvider.value.uri.path;
}
