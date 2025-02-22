import 'package:flutter/material.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/presentation/widgets/drawer/promotion/operation_days.dart';

class CreatePromotionController extends ChangeNotifier {
  double discount = 10;

  List<OperationDay> operationDays = [];

  void addOrRemoveDay(bool value, OperationDay day) {
    if (value) {
      operationDays.add(day);
    } else {
      operationDays.remove(day);
    }
    notifyListeners();
  }

  bool checkDay(OperationDay day) {
    return operationDays.contains(day);
  }

  void discountChanged(double value) {
    discount = value;
    notifyListeners();
  }

  void publish() {
    operationDays.log();
  }
}
