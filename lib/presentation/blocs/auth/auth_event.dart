part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

final class OnEmailAndPasswordVerified extends AuthEvent {
  final LoginParams params;

  const OnEmailAndPasswordVerified(this.params);

  @override
  List<Object?> get props => [params];
}

final class OnUserSignedIn extends AuthEvent {
  final String token;

  const OnUserSignedIn(this.token);

  @override
  List<Object> get props => [token];
}

final class OnCheckUserIsConnected extends AuthEvent {
  const OnCheckUserIsConnected();

  @override
  List<Object> get props => [];
}

final class OnRegister extends AuthEvent {
  final RegisterParams params;

  const OnRegister(this.params);

  @override
  List<Object> get props => [params];
}

final class OnPatch extends AuthEvent {
  final RegisterParams params;

  const OnPatch(this.params);

  @override
  List<Object> get props => [params];
}

final class OnVerifyCode extends AuthEvent {
  final RegisterParams params;

  const OnVerifyCode(this.params);

  @override
  List<Object> get props => [params];
}

final class OnResendCode extends AuthEvent {
  final RegisterParams params;

  const OnResendCode(this.params);

  @override
  List<Object> get props => [params];
}

final class OnSignedWithPhone extends AuthEvent {
  final RegisterParams params;

  const OnSignedWithPhone(this.params);

  @override
  List<Object?> get props => [params];
}

final class OnUserSignedOut extends AuthEvent {
  const OnUserSignedOut();

  @override
  List<Object?> get props => [];
}

final class OnTokenRefreshed extends AuthEvent {
  final RefreshTokenParams params;
  const OnTokenRefreshed(this.params);

  @override
  List<Object> get props => [params];
}
