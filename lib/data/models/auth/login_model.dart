import 'package:ozapay/domain/entities/auth/login_entity.dart';

import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginModel extends LoginEntity {
  const LoginModel({
    required super.token,
    required super.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
