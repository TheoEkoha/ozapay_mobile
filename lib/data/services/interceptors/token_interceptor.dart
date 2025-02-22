import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:ozapay/core/extension.dart';

import '../prefs/prefs_service.dart';

class TokenInterceptor extends Interceptor {
  final PrefsService prefs;

  const TokenInterceptor(this.prefs);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    "--> Method: ${options.method}, url: ${options.uri}".log();

    Map<String, String> headers = {};

    final path = options.path;
    final method = options.method;

    final Map<String, List<String>> excludePaths = const {
      '/login_check': ['POST'],
      '/user/': ['POST', 'PATCH'],
      '/token/refresh': ['POST'],
      '/users': ['POST', 'PATCH', 'GET'],
    };

    if (method == 'PATCH') {
      headers.addAll({'Content-Type': 'application/merge-patch+json'});
      options.headers.addAll(headers);
    }

    if (excludePaths.entries.any((it) =>
        it.value.contains(method) &&
        path.contains(it.key) &&
        path != '/user/new/pass')) {
      super.onRequest(options, handler);
      return;
    }

    final token = prefs.getAccessToken();

    if (token != null && token.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer $token'});
      options.headers.addAll(headers);
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    "${err.requestOptions.path} -> Error: ${err.response?.statusCode}\n"
            "${err.response?.data}"
        .log(Level.error);

    super.onError(err, handler);
  }
}
