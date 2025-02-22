import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'signup_controller.dart';

class CodeController extends ChangeNotifier
    with WidgetsBindingObserver, CodeAutoFill {
  final BuildContext context;
  final CodeServiceEnum service;
  final CodeTypeEnum type;

  final signInFormKey = GlobalKey<FormBuilderState>();

  CodeController(
    this.context, {
    required this.service,
    required this.type,
  }) {
    WidgetsBinding.instance.addObserver(this);
    startTimer();

    if (type == CodeTypeEnum.sms) {
      /// Listen for SMS incoming
      listenForCode();
      SmsAutoFill().getAppSignature.then((value) {
        appSignature = value;

        "[App Signature]: $appSignature".log();

        notifyListeners();
      });
    }
  }

  Timer? timer;
  Duration duration = Duration.zero;
  String appSignature = "";
  TextEditingController codeController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  /// Retrieve code from Clipboard
  Future<String?> copyPaste() async {
    final clipboard = await Clipboard.getData("text/plain");
    return clipboard?.text;
  }

  /// Timer for code
  startTimer() {
    duration = const Duration(minutes: 1);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        duration -= const Duration(seconds: 1);

        if (duration.isNegative) {
          duration = Duration.zero;
          timer.cancel();
        }

        notifyListeners();
      },
    );
  }

  /// Reset timer
  resetTimer() {
    duration = Duration.zero;
    notifyListeners();
  }

  /// Validate code
  void validateForm() {
    if (service == CodeServiceEnum.signUpVer) {
      context.read<SignupProvider>().validateFields(
        (params) {
          context.read<AuthBloc>().add(OnVerifyCode(params.copyWith(
                code: codeController.text,
                forService: service,
                type: type,
              )));
        },
      );
    } else {
      if (signInFormKey.currentState?.saveAndValidate() ?? false) {
        context.read<AuthBloc>().add(OnVerifyCode(RegisterParams(
              code: codeController.text,
              forService: service,
              type: type,
              appSignature: type == CodeTypeEnum.sms ? appSignature : null,
            )));
      }
    }
  }

  void requestNewCode() {
    context.read<AuthBloc>().add(OnResendCode(RegisterParams(
          appSignature: type == CodeTypeEnum.sms ? appSignature : null,
          forService: service,
          type: type,
        )));
  }

  @override
  void codeUpdated() {
    "[SMS Autofill] $code".log();
    codeController.text = code ?? '';

    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    state.name.log();

    switch (state) {
      case AppLifecycleState.resumed:
        copyPaste().then((value) {
          if (value != null &&
              value.length == 6 &&
              value.contains(RegExp(r'\d{6}'))) {
            codeController.text = value;

            notifyListeners();
          }
        });
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Clipboard.setData(const ClipboardData(text: ""));
    unregisterListener();
    cancel();
    timer?.cancel();
    super.dispose();
  }
}
