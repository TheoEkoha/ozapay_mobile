import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/datasources/user_datasource.dart';
import 'package:ozapay/data/models/auth/user_model.dart';
import 'package:ozapay/data/params/auth/login/login_params.dart';
import 'package:ozapay/data/params/auth/refresh_token/refresh_token_params.dart';
import 'package:ozapay/data/params/auth/register/register_params.dart';
import 'package:ozapay/data/params/auth/security/update_password_params.dart';
import 'package:ozapay/data/services/http/http_client.dart';
import 'package:ozapay/data/services/prefs/prefs_service.dart';
import 'package:ozapay/domain/entities/auth/login_entity.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import 'package:ozapay/domain/repositories/auth_repository.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final HttpClient client;
  final PrefsService prefs;
  final UserDatasource datasource;

  AuthRepositoryImpl(this.client, this.prefs, this.datasource);

  @override
  Future<MultipleResult<Failure, LoginEntity>> login(String token) async {
    try {
      final result = await client.login({"token": token});

      _decodeAndSaveUser(result);

      return ResultSuccess(result);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return ResultError(const UnAuthorizedFailure(
          ["Email ou mot de passe invalide."],
        ));
      }
      if (e.response?.statusCode == HttpStatus.notFound) {
        return ResultError(const NotFoundFailure(
          ["Utilisateur non trouvé."],
        ));
      } else {
        final failure = Failure.fromRequest(e.response);
        return ResultError(failure);
      }
    }
  }

  @override
  Future<MultipleResult<Failure, int>> register(RegisterParams params) async {
    try {
      "[CREATE USER] input: ${params.toJson()}".log();

      final result = await client.register(params.toJson());
      final userId = result["id"];

      prefs.setUserId(userId);

      return ResultSuccess(userId);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return ResultError(const UnAuthorizedFailure(
          ["Email ou mot de passe invalide."],
        ));
      } else {
        final failure = Failure.fromRequest(e.response);
        return ResultError(failure);
      }
    }
  }

  @override
  Future<MultipleResult<Failure, UserEntity>> patchUser(
      int userId, RegisterParams params) async {
    try {
      "[PATCH USER] input: ${params.toJson()}".log();

      final res = await client.patchUser(userId, params.toJson());
      return ResultSuccess(UserModel.fromJson(res));
    } on DioException catch (e) {
      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    }
  }

  @override
  Future<MultipleResult<Failure, dynamic>> verifyCode(
      int userId, RegisterParams params) async {
    try {
      "[CODE] input: ${params.toJson()}".log();

      dynamic result;

      result = await client.verifyCode(userId, params.toJson());

      return ResultSuccess(result != null ? result['tempToken'] : unit);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.badRequest) {
        return ResultError(const BadRequestFailure(["Code non valide !"]));
      } else {
        final failure = Failure.fromRequest(e.response);
        return ResultError(failure);
      }
    }
  }

  @override
  Future<MultipleResult<Failure, dynamic>> resendCode(
      int userId, RegisterParams params) async {
    try {
      "[CODE] input: ${params.toJson()}".log();

      dynamic result;

      result = await client.resendCode(userId, params.toJson());

      "$result".log();

      if (result != null && result is Map && result.containsKey("tempToken")) {
        return ResultSuccess(result['tempToken']);
      } else {
        return ResultSuccess(unit);
      }
    } on DioException catch (e) {
      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    }
  }

  @override
  Future<MultipleResult<Failure, int>> verifyEmailAndPassword(
      LoginParams params) async {
    try {
      final result = await client.verifyEmailAndPassword(params.toJson());

      final userId = result["id"];

      prefs.setUserId(userId);
      return ResultSuccess(userId);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.notFound) {
        return ResultError(const NotFoundFailure(
          ["Utilisateur non trouvé."],
        ));
      }

      if (e.response?.statusCode == HttpStatus.badRequest) {
        return ResultError(const BadRequestFailure(
          ["Email ou mot de passe invalide."],
        ));
      }

      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return ResultError(const UnAuthorizedFailure(
          ["Votre mot de passe est expiré."],
        ));
      }

      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    }
  }

  @override
  Future<MultipleResult<Failure, int>> signinWithPhone(
      RegisterParams params) async {
    try {
      final result = await client.signinPhone(params.toJson());
      final userId = result["id"];

      prefs.setUserId(userId);
      return ResultSuccess(userId);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return ResultError(const UnAuthorizedFailure(
          ["Email ou mot de passe invalide."],
        ));
      }

      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    }
  }

  @override
  Future<MultipleResult<Failure, UserEntity>> getUserByEmail(
      String email) async {
    try {
      final res = await client.getUserByEmail(email);
      return ResultSuccess(UserModel.fromJson(res['hydra:member'][0]));
    } on DioException catch (e) {
      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    }
  }

  @override
  Future<MultipleResult<Failure, Unit>> updatePassword(
      UpdatePasswordParams params) async {
    try {
      await client.updateUserPassword(params.toJson());
      return ResultSuccess(Unit());
    } on DioException catch (e) {
      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    } on Exception catch (e) {
      return ResultError(UncategorizedFailure([e.toString()]));
    }
  }

  @override
  Future<MultipleResult<Failure, Unit>> refreshToken(
      RefreshTokenParams params) async {
    try {
      final result = await client.refreshToken(params.toJson());

      _decodeAndSaveUser(result);

      return ResultSuccess(unit);
    } on DioException catch (e) {
      final failure = Failure.fromRequest(e.response);
      return ResultError(failure);
    }
  }

  @override
  Future<bool> signOut() async {
    final futures = await Future.wait([
      prefs.removeAccessToken(),
      datasource.loggedOutUser(prefs.getUserId()!),
    ]);
    return futures.every((it) => it);
  }
@override
Future<bool> checkUserIsConnected() async {
  final userId = prefs.getUserId();
  print("User is connected dans home screen userId: $userId");

  if (userId == null) return false;
  
  final id = userId.toString();
  final response = await http.get(Uri.parse("https://backoffice.ozapay.me/api/users/profile/$id"));
  print("Response: ${response.body}");

  //final user = await datasource.findByUserId(userId);
  
  final user = response.body;

  // if (user != null && (user.isLogged ?? true)) {
  // if (user != null) {
  //   final result = await refreshToken(RefreshTokenParams(user.refreshToken!));
  //   print("User is connected dans home screen: Token refresh result: $result");

  //   // Vérification de l'erreur lors du rafraîchissement du token
  //   if (result.isError) {
  //     print("Token refresh failed, user not connected");
  //     return false;
  //   }
  // }

  // return user != null && (user.isLogged ?? true);
  return user != null;
}
  _decodeAndSaveUser(LoginEntity login) async {
    final decodedToken = JwtDecoder.decode(login.token);
    final userResult = await getUserByEmail(decodedToken['username']);

  if (userResult.getSuccess == null) {
    print("No user found for username and mail: ${decodedToken['username']}");
    return; // Quitte la fonction si aucun utilisateur n'est trouvé
  }

    await Future.wait([
      prefs.setAccessToken(login.token),
      prefs.setUserId(userResult.getSuccess!.id!),
      datasource.saveUser(
        userResult.getSuccess!.id!,
        refreshToken: login.refreshToken,
        user: userResult.getSuccess,
      )
    ], eagerError: true);
  }
}
