import 'package:equatable/equatable.dart';

import 'package:ozapay/data/enums/enum.dart';

class UserEntity extends Equatable {
  final int? id;
  final List<String>? roles;
  final bool? conditionAccepted, marketingAccepted, hasWallet;

  final String? email,
      firstName,
      lastName,
      code,
      address,
      phone,
      status,
      city,
      postalCode,
      denomination,
      siret,
      type,
      country,
      pin;

  String get displayName => '${firstName ?? ''} ${lastName ?? ''}';

  AccountRoleEnum get accountRole => denomination == null || siret == null
      ? AccountRoleEnum.particular
      : AccountRoleEnum.professional;

  const UserEntity({
    this.email,
    this.firstName,
    this.lastName,
    this.code,
    this.address,
    this.phone,
    this.status,
    this.city,
    this.postalCode,
    this.denomination,
    this.siret,
    this.id,
    this.roles,
    this.conditionAccepted,
    this.marketingAccepted,
    this.type,
    this.country,
    this.hasWallet,
    this.pin,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        roles,
        firstName,
        lastName,
        code,
        conditionAccepted,
        marketingAccepted,
        address,
        phone,
        status,
        city,
        postalCode,
        type,
        country,
        hasWallet,
      ];

  UserEntity copyWith({
    int? id,
    List<String>? roles,
    bool? conditionAccepted,
    bool? marketingAccepted,
    bool? hasWallet,
    String? email,
    String? firstName,
    String? lastName,
    String? code,
    String? address,
    String? phone,
    String? status,
    String? city,
    String? postalCode,
    String? denomination,
    String? siret,
    String? type,
    String? country,
    String? pin,
  }) {
    return UserEntity(
      id: id ?? this.id,
      roles: roles ?? this.roles,
      conditionAccepted: conditionAccepted ?? this.conditionAccepted,
      marketingAccepted: marketingAccepted ?? this.marketingAccepted,
      hasWallet: hasWallet ?? this.hasWallet,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      code: code ?? this.code,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      denomination: denomination ?? this.denomination,
      siret: siret ?? this.siret,
      type: type ?? this.type,
      country: country ?? this.country,
      pin: pin ?? this.pin,
    );
  }
}
