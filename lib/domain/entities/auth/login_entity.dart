import 'package:equatable/equatable.dart';

abstract class LoginEntity extends Equatable {
  final String token, refreshToken;

  const LoginEntity({
    required this.token,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [token, refreshToken];
}
