import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

late StreamSubscription<ConnectivityResult> _connectivitySubscription;
final Connectivity _connectivity = Connectivity();
bool _isConnected = false;

void listenToConnectivityChanges(void Function(bool) onConnectivityChanged) {
  _connectivitySubscription = _connectivity.onConnectivityChanged
      .listen(_handleConnectivityChange(onConnectivityChanged));
}

void stopListeningToConnectivityChanges() {
  _connectivitySubscription.cancel();
}

void Function(ConnectivityResult) _handleConnectivityChange(
    void Function(bool) onConnectivityChanged) {
  return (ConnectivityResult connectivityResult) {
    if (_isConnected == (connectivityResult != ConnectivityResult.none)) {
      return;
    }

    _isConnected = (connectivityResult != ConnectivityResult.none);
    onConnectivityChanged(_isConnected);
  };
}

Future<bool> checkConnectivity() async {
  final ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  return (connectivityResult != ConnectivityResult.none);
}
