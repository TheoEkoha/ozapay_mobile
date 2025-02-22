import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:ozapay/core/ozapay/solana_wallet_provider.dart';
import 'package:ozapay/data/services/prefs/prefs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/dabatase_service.dart';
import '../interceptors/token_interceptor.dart';

@module
abstract class InjectionModule {
  @Named('apiBaseUrl')
  String get apiBaseUrl => "https://backoffice.ozapay.me/api";

  @Named('jupiterApiUrl')
  String get jupApiUrl => dotenv.get('JUP_API_URL');

  @preResolve
  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  Dio dio(PrefsService prefs) {
    final baseDio = Dio(BaseOptions(
      contentType: "application/json",
      connectTimeout: const Duration(seconds: 120),
    ));
    baseDio.interceptors.add(TokenInterceptor(prefs));

    return baseDio;
  }

  @preResolve
  Future<Isar> get isar => DatabaseService().isar;

  SolanaWalletProvider get solanaService => SolanaWalletProvider();
}
