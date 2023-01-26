part of 'network_bloc.dart';

@immutable
abstract class NetworkEvent extends Equatable {}

class NetworkObserveEvent extends NetworkEvent {
  @override
  List<Object?> get props => [];
}

class NetworkNotifyEvent extends NetworkEvent {
  final bool isConnected;

  NetworkNotifyEvent({this.isConnected = false});

  @override
  List<Object?> get props => [isConnected];
}
