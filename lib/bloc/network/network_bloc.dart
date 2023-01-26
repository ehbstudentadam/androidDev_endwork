import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_helper.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitialState()) {
    on<NetworkObserveEvent>(_observe);
    on<NetworkNotifyEvent>(_notifyStatus);
  }

  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  void _observe(event, emit) {
    NetworkHelper.observeNetwork();
  }

  void _notifyStatus(NetworkNotifyEvent event, emit) {
    event.isConnected ? emit(NetworkSuccessState()) : emit(NetworkFailureState());
  }
}
