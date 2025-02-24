import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ozapay/core/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ozapay/core/constants.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/services/injection/injection_service.dart';
import 'package:ozapay/presentation/blocs/auth/auth_bloc.dart';
import 'package:ozapay/presentation/widgets/widget.dart';
import 'package:ozapay/data/params/params.dart';

class PhoneInfo extends StatefulWidget {
  final String? label;
  // final int? userId;
  final RegisterParams? params;

  const PhoneInfo({
    Key? key,
    this.label,
    // this.userId,
    this.params,
  }) : super(key: key);

  @override
  _PhoneInfoState createState() => _PhoneInfoState();
}

class _PhoneInfoState extends State<PhoneInfo> {
  bool _isResending = false;

Future<void> _resendCode() async {
  setState(() {
    _isResending = true;
  });

  // Assurez-vous que widget.params n'est pas nul
  if (widget.params == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Parameters are missing.")),
    );
    setState(() {
      _isResending = false;
    });
    return;
  }

  try {
    // Log des paramètres pour le débogage
    //"[CODE] input: ${widget.params?.toJson()}".log();
    //params.toJson()
    // if (widget?.userId != null && widget?.params != null) {
    //TODO ICI
    final userId =  getIt<AuthBloc>()?.userId;
    if (userId != null && widget?.params != null) {
      "[CODE] RESEND CONDE: ${widget.params?.toJson()}".log();

      final registerParams = {
        'for': 'SIGN_UP_VER',
        'type': 'SMS',
        'appSignature': '',
        'phone': '+33665723525'
      } as RegisterParams;

      final result = getIt<AuthBloc>()?.repository.resendCode(userId, registerParams);

    // Log du résultat pour le débogage
    "$result".log();

    // Vérifiez si le résultat est valide
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code resent successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Une erreur est survenue.")),
      );
    }
    }
    
  } on DioException catch (e) {
    // Gérer l'exception en utilisant Failure
    final failure = Failure.fromRequest(e.response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Une erreur est survenue.")),
    );
  } finally {
    setState(() {
      _isResending = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label ?? "fields.phone",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ).tr(),
        const SizedBox(height: kSpacing),
        FormBuilderPhone(
          name: "phone",
          decoration: InputDecoration(
            hintText: "fields.phoneHint".tr(),
          ),
          validator: FormBuilderValidators.required(),
        ),
        const SizedBox(height: kSpacing),
        ElevatedButton(
          onPressed: _isResending ? null : _resendCode,
          child: _isResending
              ? CircularProgressIndicator()
              : Text("Resend").tr(),
        ),
      ],
    );
  }
}

// led unimplemented OpenGL ES API
// I/flutter (14722): ⛔ /user/2394 -> Error: 500
// I/flutter (14722): ⛔ {@id: /api/errors/500, @type: hydra:Error, title: An error occurred, detail: Attempted to call an undefined method named "getRole" of class "App\Entity\User\Particular".
// I/flutter (14722): ⛔ Did you mean to call e.g. "getCode", "getRoles" or "setRoles"?, status: 500, type: /errors/500, trace: [{file: /var/www/prod/php82/ozapay/srcs/src/Controller/Api/User/EditController.php, line: 26, function: edit, class: App\Service\Api\User\UserService, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/http-kernel/HttpKernel.php, line: 183, function: __invoke, class: App\Controller\Api\User\EditController, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/http-kernel/HttpKernel.php, line: 76, function: handleRaw, class: Symfony\Component\HttpKernel\HttpKernel, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/http-kernel/Kernel.php, line: 182, function: handle, class: Symfony\Component\HttpKernel\HttpKernel, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/runtime/Runner/Symfony/HttpKernelRunner.php, line: 35, function: handle, class: Symfony\Component\HttpKernel\Kernel, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/autolo
// I/flutter (14722): ⛔ Did you mean to call e.g. "getCode", "getRoles" or "setRoles"?, hydra:description: Attempted to call an undefined method named "getRole" of class "App\Entity\User\Particular".
// I/flutter (14722): ⛔ Did you mean to call e.g. "getCode", "getRoles" or "setRoles"?, hydra:title: An error occurred}


// y.dev(15275): NativeAlloc concurrent mark compact GC freed 38MB AllocSpace bytes, 5(356KB) LOS objects, 49% free, 20MB/41MB, paused 2.699ms,1.076ms total 228.427ms
// I/flutter (15275): 💡 [CODE] updatePhone: {role: particular, code: opl, phone: +33665723525}
// D/AppSignatureHelper(15275): pkg: me.ozapay.dev -- hash: fb3S3d7/2T+
// I/flutter (15275): 💡 appSignature: fb3S3d7/2T+
// I/flutter (15275): 💡 [PATCH USER] input: {role: particular, appSignature: fb3S3d7/2T+, code: opl, phone: +33665723525, for: SIGN_UP_VER}
// E/libEGL  (15275): called unimplemented OpenGL ES API
// I/flutter (15275): 💡 --> Method: PATCH, url: https://backoffice.ozapay.me/api/user/2395
// I/me.ozapay.dev(15275): NativeAlloc concurrent mark compact GC freed 32MB AllocSpace bytes, 0(0B) LOS objects, 39% free, 36MB/60MB, paused 2.868ms,3.464ms total 451.645ms
// I/flutter (15275): ⛔ /user/2395 -> Error: 500
// I/flutter (15275): ⛔ {@id: /api/errors/500, @type: hydra:Error, title: An error occurred, detail: Attempted to call an undefined method named "getRole" of class "App\Entity\User\Particular".
// I/flutter (15275): ⛔ Did you mean to call e.g. "getCode", "getRoles" or "setRoles"?, status: 500, type: /errors/500, trace: [{file: /var/www/prod/php82/ozapay/srcs/src/Controller/Api/User/EditController.php, line: 26, function: edit, class: App\Service\Api\User\UserService, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/http-kernel/HttpKernel.php, line: 183, function: __invoke, class: App\Controller\Api\User\EditController, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/http-kernel/HttpKernel.php, line: 76, function: handleRaw, class: Symfony\Component\HttpKernel\HttpKernel, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/http-kernel/Kernel.php, line: 182, function: handle, class: Symfony\Component\HttpKernel\HttpKernel, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/symfony/runtime/Runner/Symfony/HttpKernelRunner.php, line: 35, function: handle, class: Symfony\Component\HttpKernel\Kernel, type: ->}, {file: /var/www/prod/php82/ozapay/srcs/vendor/autolo
// I/flutter (15275): ⛔ Did you mean to call e.g. "getCode", "getRoles" or "setRoles"?, hydra:description: Attempted to call an undefined method named "getRole" of class "App\Entity\User\Particular".
// I/flutter (15275): ⛔ Did you mean to call e.g. "getCode", "getRoles" or "setRoles"?, hydra:title: An error occurred}
// E/libEGL  (15275): called unimplemented OpenGL ES API
// I/me.ozapay.dev(15275): Background concurrent mark compact GC freed 63MB AllocSpace bytes, 20(1424KB) LOS objects, 31% free, 51MB/75MB, paused 4.104ms,6.602ms total 577.700ms