import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:ozapay/data/enums/enum.dart';
import 'package:ozapay/presentation/widgets/widget.dart';

part 'register_params.g.dart';

@JsonSerializable(includeIfNull: false)
class RegisterParams extends Equatable {
  final int? id;

  final String? firstName,
      lastName,
      address,
      postalCode,
      city,
      siret,
      denomination,
      role,
      email,
      pin,
      confirmPin,
      appSignature,
      code,
      phone,
      country;

  final List<String>? roles;

  @JsonKey(name: "_step")
  final String? step;

  final bool? hasWallet;

  @JsonKey(name: 'for')
  final CodeServiceEnum? forService;

  final CodeTypeEnum? type;

  const RegisterParams({
    this.id,
    this.firstName,
    this.lastName,
    this.address,
    this.postalCode,
    this.city,
    this.siret,
    this.denomination,
    this.role,
    this.roles,
    this.forService,
    this.phone,
    this.email,
    this.pin,
    this.confirmPin,
    this.appSignature,
    this.code,
    this.type,
    this.country,
    this.hasWallet,
    this.step,
  });

  factory RegisterParams.fromJson(Map<String, dynamic> json) =>
      _$RegisterParamsFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterParamsToJson(this);

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        address,
        postalCode,
        city,
        siret,
        denomination,
        role,
        roles,
        id,
        forService,
        phone,
        email,
        pin,
        appSignature,
        code,
        type,
        country,
        hasWallet,
      ];

  RegisterParams copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? address,
    String? postalCode,
    String? city,
    String? siret,
    String? denomination,
    String? role,
    List<String>? roles,
    CodeServiceEnum? forService,
    CodeTypeEnum? type,
    dynamic phone,
    String? email,
    String? pin,
    String? confirmPin,
    String? appSignature,
    String? code,
    String? country,
    bool? hasWallet,
    String? step,
  }) {
    return RegisterParams(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      siret: siret ?? this.siret,
      denomination: denomination ?? this.denomination,
      role: role ?? this.role,
      roles: roles ?? this.roles,
      forService: forService ?? this.forService,
      type: type ?? this.type,
      phone: phone is PhoneNumber ? phone.phoneNumber : phone as String?, // ✅ Conversion correcte
      email: email ?? this.email,
      pin: pin ?? this.pin,
      confirmPin: confirmPin,
      appSignature: appSignature,
      code: code ?? this.code,
      country: country ?? this.country,
      hasWallet: hasWallet ?? this.hasWallet,
      step: step ?? this.step,
    );
  }
}
