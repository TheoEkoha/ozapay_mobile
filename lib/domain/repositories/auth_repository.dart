import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import '../entities/auth/login_entity.dart';

abstract class AuthRepository {
  /// Vérifie les informations d'identification de l'utilisateur avec un e-mail et un mot de passe.
  Future<MultipleResult<Failure, int>> verifyEmailAndPassword(LoginParams params);

  /// Authentifie l'utilisateur avec son numéro de téléphone.
  Future<MultipleResult<Failure, int>> signinWithPhone(RegisterParams params);

  /// Connecte l'utilisateur avec un token temporaire.
  Future<MultipleResult<Failure, LoginEntity>> login(String token);

  /// Crée un nouvel utilisateur.
  Future<MultipleResult<Failure, int>> register(RegisterParams params);

  /// Met à jour les informations d'un utilisateur existant.
  Future<MultipleResult<Failure, UserEntity>> patchUser(int userId, RegisterParams params);

  /// Récuperer les informations d'un utilisateur existant.
  Future<MultipleResult<Failure, UserEntity>> getUserProfile(int userId);


  /// Vérifie le code de vérification envoyé à l'utilisateur.
  Future<MultipleResult<Failure, dynamic>> verifyCode(int userId, RegisterParams params);

  /// Renvoie un nouveau code de vérification à l'utilisateur.
  Future<MultipleResult<Failure, dynamic>> resendCode(int userId, RegisterParams params);

  /// Récupère les informations de l'utilisateur par e-mail.
  Future<MultipleResult<Failure, UserEntity>> getUserByEmail(String email);

  /// Met à jour le mot de passe de l'utilisateur.
  Future<MultipleResult<Failure, Unit>> updatePassword(UpdatePasswordParams params);

  /// Rafraîchit le token d'authentification.
  Future<MultipleResult<Failure, Unit>> refreshToken(RefreshTokenParams params);

  /// Déconnecte l'utilisateur.
  Future<bool> signOut();

  /// Vérifie si l'utilisateur est connecté.
  Future<bool> checkUserIsConnected();
  
}