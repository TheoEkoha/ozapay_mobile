import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_history.g.dart';

@JsonSerializable()
class TransactionHistory extends Equatable {
  final String signature;
  final DateTime timestamp;
  final Map<String, dynamic>? token;
  final InstructionInfo instruction;

  const TransactionHistory({
    required this.signature,
    required this.timestamp,
    this.token,
    required this.instruction,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionHistoryToJson(this);

  @override
  List<Object?> get props => [
        signature,
        timestamp,
        token,
        instruction,
      ];
}

@JsonSerializable()
class InstructionInfo extends Equatable {
  final String? memo;
  final double amount;
  final String source, destination;

  const InstructionInfo({
    this.memo,
    required this.amount,
    required this.source,
    required this.destination,
  });

  factory InstructionInfo.fromJson(Map<String, dynamic> json) =>
      _$InstructionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionInfoToJson(this);

  InstructionInfo copyWith({
    String? memo,
    double? amount,
    String? source,
    String? destination,
  }) {
    return InstructionInfo(
      memo: memo ?? this.memo,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      destination: destination ?? this.destination,
    );
  }

  @override
  List<Object> get props => [amount, source, destination];
}
