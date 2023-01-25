part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends Equatable {}

class LoadUserNameEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserNameEvent extends UserEvent {
  final String userName;

  UpdateUserNameEvent(this.userName);
  @override
  List<Object?> get props => [userName];
}
