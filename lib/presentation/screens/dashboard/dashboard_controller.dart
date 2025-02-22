import 'package:flutter/material.dart';
import 'package:ozapay/core/enums.dart';

class DashboardController extends ChangeNotifier {
  MenuEnum currentMenu = MenuEnum.home;

  void changeIndex(MenuEnum menu) {
    currentMenu = menu;
    notifyListeners();
  }
}
