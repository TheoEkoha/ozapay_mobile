import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ozapay/core/extension.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/params/auth/register/register_params.dart';
import 'package:ozapay/data/params/auth/security/update_password_params.dart';
import 'package:ozapay/data/services/prefs/prefs_service.dart';
import 'package:ozapay/domain/entities/auth/user_entity.dart';
import 'package:ozapay/domain/repositories/auth_repository.dart';

import '../bloc_status.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository repository;
  final PrefsService prefs;

  UserBloc(this.repository, this.prefs) : super(UserState()) {
    on<OnUserInfoFetched>(_onUserInfoFetched, transformer: droppable());
    on<OnUserInfoUpdated>(_onUserInfoUpdated, transformer: droppable());
    on<OnPasswordUpdated>(_onPasswordUpdated, transformer: droppable());
  }

  FutureOr<void> _onUserInfoFetched(
    OnUserInfoFetched event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      failure: null,
    ));
    final token = prefs.getAccessToken();

    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);

      try {
        final res = await repository.getUserByEmail(decodedToken['username']);
        "haswallet: ${res.getSuccess?.hasWallet}".log();

        emit(
          state.copyWith(
            user: res.getSuccess,
            failure: res.getError,
            status: res.getError != null ? ErrorStatus() : LoadedStatus(),
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ErrorStatus(),
            failure: e as Failure,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: ErrorStatus(),
          failure: UnAuthorizedFailure([]),
        ),
      );
    }
  }

  FutureOr<void> _onUserInfoUpdated(
    OnUserInfoUpdated event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      failure: null,
    ));
    final res = await repository.patchUser(event.id, event.params);
    emit(
      state.copyWith(
        failure: res.getError,
        user: res.getSuccess,
        status: res.getError != null ? ErrorStatus() : LoadedStatus(),
      ),
    );
  }

  FutureOr<void> _onPasswordUpdated(
    OnPasswordUpdated event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(
      status: LoadingStatus(),
      failure: null,
    ));

    final res = await repository.updatePassword(event.params);
    emit(
      state.copyWith(
        failure: res.getError,
        status: res.getError != null ? ErrorStatus() : LoadedStatus(),
      ),
    );
  }
}
