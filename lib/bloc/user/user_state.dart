part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {}

class UserInitialState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadingState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadedState extends UserState {
  final String userName;

  UserLoadedState(this.userName);
  @override
  List<Object?> get props => [userName];
}

class UserErrorState extends UserState {
  final String error;

  UserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
