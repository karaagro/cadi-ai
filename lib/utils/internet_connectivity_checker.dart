import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
final Connectivity _connectivity = Connectivity();
bool _isConnected = false;

void listenToConnectivityChanges(void Function(bool) onConnectivityChanged) {
  _connectivitySubscription = _connectivity.onConnectivityChanged
      .listen(_handleConnectivityChange(onConnectivityChanged));
}

void stopListeningToConnectivityChanges() {
  _connectivitySubscription.cancel();
}

void Function(List<ConnectivityResult>) _handleConnectivityChange(
    void Function(bool) onConnectivityChanged) {
  return (List<ConnectivityResult> connectivityResults) {
    bool isConnected = connectivityResults.any((result) => result != ConnectivityResult.none);
    
    if (_isConnected == isConnected) {
      return;
    }

    _isConnected = isConnected;
    onConnectivityChanged(_isConnected);
  };
}

Future<bool> checkConnectivity() async {
  final List<ConnectivityResult> connectivityResults =
      await Connectivity().checkConnectivity();

  return connectivityResults.any((result) => result != ConnectivityResult.none);
}
