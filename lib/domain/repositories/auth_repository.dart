import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';

import '../entities/auth/login_entity.dart';

abstract class AuthRepository {
  Future<MultipleResult<Failure, int>> verifyEmailAndPassword(
      LoginParams params);

  Future<MultipleResult<Failure, int>> signinWithPhone(RegisterParams params);

  Future<MultipleResult<Failure, LoginEntity>> login(String token);

  Future<MultipleResult<Failure, int>> register(RegisterParams params);

  Future<MultipleResult<Failure, UserEntity>> patchUser(
      int userId, RegisterParams params);

  Future<MultipleResult<Failure, dynamic>> verifyCode(
      int userId, RegisterParams params);

  Future<MultipleResult<Failure, dynamic>> resendCode(
      int userId, RegisterParams params);

  Future<MultipleResult<Failure, UserEntity>> getUserByEmail(String email);

  Future<MultipleResult<Failure, Unit>> updatePassword(
      UpdatePasswordParams params);

  Future<MultipleResult<Failure, Unit>> refreshToken(RefreshTokenParams params);

  Future<bool> signOut();

  Future<bool> checkUserIsConnected();
}
