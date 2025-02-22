import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_password_params.g.dart';

@JsonSerializable()
class UpdatePasswordParams extends Equatable {
  final String oldPassword, newPassword;
  const UpdatePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  factory UpdatePasswordParams.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordParamsFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordParamsToJson(this);

  @override
  List<Object> get props => [oldPassword, newPassword];
}
