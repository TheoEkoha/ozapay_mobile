part of 'user_bloc.dart';

class UserState extends Equatable {
  final UserEntity? user;
  final BlocStatus status;
  final Failure? failure;

  const UserState({
    this.user,
    this.status = const IdleStatus(),
    this.failure,
  });

  UserState copyWith({
    UserEntity? user,
    BlocStatus? status,
    Failure? failure,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [user, status, failure];
}
