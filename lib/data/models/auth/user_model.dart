import 'package:json_annotation/json_annotation.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.email,
    super.roles,
    super.firstName,
    super.lastName,
    super.code,
    super.conditionAccepted,
    super.marketingAccepted,
    super.address,
    super.phone,
    super.status,
    super.city,
    super.postalCode,
    super.denomination,
    super.siret,
    super.type,
    super.country,
    super.hasWallet,
    super.pin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
