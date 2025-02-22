part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class InitialAuthState extends AuthState {
  const InitialAuthState();

  @override
  List<Object> get props => [];
}

final class AuthLoadingState extends AuthState {
  const AuthLoadingState();

  @override
  List<Object> get props => [];
}

final class AuthUserConnectedState extends AuthState {
  const AuthUserConnectedState();

  @override
  List<Object> get props => [];
}

final class AuthUserDisconnectedState extends AuthState {
  const AuthUserDisconnectedState();

  @override
  List<Object> get props => [];
}

final class AuthErrorState extends AuthState {
  final Failure failure;

  const AuthErrorState(this.failure);

  @override
  List<Object> get props => [failure];
}

/// POST [/users]
final class AuthUserCreatedState extends AuthState {
  final int userId;

  const AuthUserCreatedState(this.userId);

  @override
  List<Object> get props => [userId];
}

/// PATCH [/users]
final class AuthUserUpdatedState extends AuthState {
  const AuthUserUpdatedState();

  @override
  List<Object> get props => [];
}

/// PATCH [/user/verify]
final class AuthCodeVerifiedState extends AuthState {
  final String? tempToken;
  const AuthCodeVerifiedState(this.tempToken);

  @override
  List<Object?> get props => [tempToken];
}

/// PATCH [/user/code/resend]
final class AuthCodeResentState extends AuthState {
  final String? tempToken;
  const AuthCodeResentState(this.tempToken);

  @override
  List<Object?> get props => [tempToken];
}

/// PATCH [/user/email_login/prepare]
final class AuthCodeRequested extends AuthState {
  const AuthCodeRequested();

  @override
  List<Object?> get props => [];
}

/// PATCH [/user/sms_login/prepare]
final class AuthPhonenumberRequested extends AuthState {
  const AuthPhonenumberRequested();

  @override
  List<Object?> get props => [];
}
