part of 'network_bloc.dart';

@immutable
abstract class NetworkState extends Equatable {}

class NetworkInitialState extends NetworkState {
  @override
  List<Object?> get props => [];
}

class NetworkSuccessState extends NetworkState {
  @override
  List<Object?> get props => [];
}

class NetworkFailureState extends NetworkState {
  @override
  List<Object?> get props => [];
}
