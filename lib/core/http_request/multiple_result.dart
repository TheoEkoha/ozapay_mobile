import 'dart:io';

import 'package:dio/dio.dart';

part 'failure.dart';

sealed class MultipleResult<E, S> {
  const MultipleResult();

  bool get isSuccess;

  bool get isError;

  S? get getSuccess;

  E? get getError;
}

class ResultSuccess<E extends Failure, S> extends MultipleResult<E, S> {
  final S _success;

  const ResultSuccess(this._success);

  @override
  bool get isError => false;

  @override
  bool get isSuccess => true;

  @override
  E? get getError => null;

  @override
  S? get getSuccess => _success;
}

class ResultError<E extends Failure, S> extends MultipleResult<E, S> {
  final E _error;

  ResultError(this._error);

  @override
  bool get isError => true;

  @override
  bool get isSuccess => false;

  @override
  E? get getError => _error;

  @override
  S? get getSuccess => null;
}

class Unit {}

final unit = Unit();
