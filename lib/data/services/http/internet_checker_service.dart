import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';

class InternetCheckerService {
  final InternetConnectionChecker _connectionChecker = InternetConnectionChecker.createInstance();
  StreamSubscription? _streamSubscription;

  Future<bool> isConnected() => _connectionChecker.hasConnection;

  Future<void> checkIsConnected() async {
    if (!(await isConnected())) {
      throw const InternetConnectionFailure(
          ["Vous n'êtes pas connecté à internet."]);
    }
  }

  void monitor(ValueChanged<InternetConnectionStatus> onMonitor) {
    dispose();

    _streamSubscription = _connectionChecker.onStatusChange.listen((value) {
      onMonitor(value);
    });
  }

  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}