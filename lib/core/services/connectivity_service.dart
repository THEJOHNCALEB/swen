import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  StreamController<bool>? _connectivityController;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _connectivityController!.stream;
  }

  StreamSubscription<ConnectivityResult>? _subscription;

  void _startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        final isConnected = result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet;
        _connectivityController?.add(isConnected);
      },
    );

    _checkInitialConnectivity();
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final isConnected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
    _connectivityController?.add(isConnected);
  }

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController?.close();
  }
}
