import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ozapay/core/http_request/multiple_result.dart';
import 'package:ozapay/data/params/params.dart';
import 'package:ozapay/data/services/prefs/prefs_service.dart';
import 'package:ozapay/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final PrefsService prefs;

  AuthBloc(this.repository, this.prefs) : super(const InitialAuthState()) {
    on<OnEmailAndPasswordVerified>(_onEmailAndPasswordVerified);
    on<OnSignedWithPhone>(_onSignedWithPhone);
    on<OnUserSignedIn>(_onUserSignedIn);
    on<OnCheckUserIsConnected>(_onCheckUserIsConnected);
    on<OnRegister>(_onCreateUser);
    on<OnPatch>(_onPatchUser);
    on<OnVerifyCode>(_onVerifyCode);
    on<OnResendCode>(_onResendCode);
    on<OnUserSignedOut>(_onUserSignedOut);
    on<OnTokenRefreshed>(_onTokenRefreshed);
  }

  int? get userId => prefs.getUserId();

  /// [Sign in] Step 1: Prepare email & password for login
  _onEmailAndPasswordVerified(OnEmailAndPasswordVerified event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.verifyEmailAndPassword(event.params);

      if (result.isSuccess) {
        emit(AuthCodeRequested());
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  ///[Sign in] Step 1: Prepare phone for login
  _onSignedWithPhone(OnSignedWithPhone event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.signinWithPhone(event.params);
      if (result.isSuccess) {
        emit(AuthPhonenumberRequested());
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  // [Sign in] Step 2: Log user with tmp token
  _onUserSignedIn(OnUserSignedIn event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.login(event.token);

      if (result.isSuccess) {
        emit(const AuthUserConnectedState());
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  _onCheckUserIsConnected(OnCheckUserIsConnected event, emit) async {
    emit(AuthLoadingState());

    if (await repository.checkUserIsConnected()) {
      emit(const AuthUserConnectedState());
    } else {
      emit(const AuthUserDisconnectedState());
    }
  }

  // [Sign up] Create new user
  _onCreateUser(OnRegister event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.register(event.params);

      if (result.isSuccess) {
        emit(AuthUserCreatedState(result.getSuccess!));
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  // [Sign up] Patch existing user
  _onPatchUser(OnPatch event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.patchUser(userId!, event.params);

      if (result.isSuccess) {
        emit(const AuthUserUpdatedState());
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  // Email & phone verification code
  _onVerifyCode(OnVerifyCode event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.verifyCode(userId!, event.params);

      if (result.isSuccess) {
        emit(AuthCodeVerifiedState(result.getSuccess));
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  // Email & phone resend new code
  _onResendCode(OnResendCode event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.resendCode(userId!, event.params);

      if (result.isSuccess) {
        emit(AuthCodeResentState(null));
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }

  // Sign out
  _onUserSignedOut(OnUserSignedOut event, emit) async {
    if (await repository.signOut()) {
      emit(const AuthUserDisconnectedState());
    } else {
      emit(const AuthUserConnectedState());
    }
  }

  // Refresh token
  _onTokenRefreshed(OnTokenRefreshed event, emit) async {
    emit(const AuthLoadingState());

    try {
      final result = await repository.refreshToken(event.params);

      if (result.isSuccess) {
        emit(const AuthUserConnectedState());
      } else {
        emit(AuthErrorState(result.getError!));
      }
    } on Failure catch (e) {
      emit(AuthErrorState(e));
    }
  }
}
