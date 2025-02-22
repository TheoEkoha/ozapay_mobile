part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class OnUserInfoFetched extends UserEvent {}

class OnUserInfoUpdated extends UserEvent {
  const OnUserInfoUpdated(this.id, this.params);
  final int id;
  final RegisterParams params;

  @override
  List<Object?> get props => [id, params];
}

class OnPasswordUpdated extends UserEvent {
  final UpdatePasswordParams params;
  const OnPasswordUpdated({
    required this.params,
  });

  @override
  List<Object?> get props => [params];
}
