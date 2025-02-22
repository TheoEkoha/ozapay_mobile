import 'package:equatable/equatable.dart';
import 'package:ozapay/data/enums/enum.dart';

class SalesRewardEntity extends Equatable {
  const SalesRewardEntity({this.amount, this.date, this.from, this.type});
  final double? amount;
  final DateTime? date;
  final String? from;
  final RewardType? type;

  @override
  List<Object?> get props => [amount, date, from, type];
}