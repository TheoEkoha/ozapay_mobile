import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_params.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshTokenParams extends Equatable {
  final String refreshToken;
  const RefreshTokenParams(this.refreshToken);

  factory RefreshTokenParams.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenParamsFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenParamsToJson(this);

  @override
  List<Object> get props => [refreshToken];
}
