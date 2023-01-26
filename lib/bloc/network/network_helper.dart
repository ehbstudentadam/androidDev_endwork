import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_bloc.dart';

class NetworkHelper {
  static void observeNetwork() {
    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            NetworkBloc().add(NetworkNotifyEvent(isConnected: true));
            break;
          case InternetConnectionStatus.disconnected:
            NetworkBloc().add(NetworkNotifyEvent());
            break;
        }
      },
    );
  }
}
