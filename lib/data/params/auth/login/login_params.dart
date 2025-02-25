import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_params.g.dart';

@JsonSerializable()
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  factory LoginParams.fromJson(Map<String, dynamic> json) => LoginParams(
        email: json['email'] as String? ?? '', // Gestion des valeurs nulles
        password: json['password'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => _$LoginParamsToJson(this);

  @override
  List<Object?> get props => [email, password];
}