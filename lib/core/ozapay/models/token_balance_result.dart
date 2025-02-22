import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_balance_result.g.dart';

@JsonSerializable()
class TokenBalanceResult extends Equatable {
  final List<TokenBalanceInfoModel> result;

  const TokenBalanceResult({
    required this.result,
  });

  @override
  List<Object> get props => [result];

  factory TokenBalanceResult.fromJson(Map<String, dynamic> json) =>
      _$TokenBalanceResultFromJson(json);

  Map<String, dynamic> toJson() => _$TokenBalanceResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TokenBalanceInfoModel extends Equatable {
  final String address, associatedAccount;
  final double balance, balanceInCurrency;
  final TokenInfo info;

  const TokenBalanceInfoModel({
    required this.address,
    required this.associatedAccount,
    required this.balance,
    required this.balanceInCurrency,
    required this.info,
  });

  @override
  List<Object> get props =>
      [associatedAccount, balance, balanceInCurrency, info];

  factory TokenBalanceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TokenBalanceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenBalanceInfoModelToJson(this);

  TokenBalanceInfoModel copyWith({
    String? address,
    String? associatedAccount,
    double? balance,
    double? balanceInCurrency,
    TokenInfo? info,
  }) {
    return TokenBalanceInfoModel(
      address: address ?? this.address,
      associatedAccount: associatedAccount ?? this.associatedAccount,
      balance: balance ?? this.balance,
      balanceInCurrency: balanceInCurrency ?? this.balanceInCurrency,
      info: info ?? this.info,
    );
  }
}

@JsonSerializable()
class TokenInfo extends Equatable {
  final String name, symbol, image;

  const TokenInfo({
    required this.name,
    required this.symbol,
    required this.image,
  });

  @override
  List<Object> get props => [name, symbol, image];

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);
}
