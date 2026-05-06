import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/platform_utils.dart';

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
        _connectivityController?.add(_isConnected(result));
      },
    );

    _checkInitialConnectivity();
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _checkInitialConnectivity() async {
    final connected = await checkConnectivity();
    _connectivityController?.add(connected);
  }

  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }

  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (_isConnected(result)) return true;

      if (PlatformUtils.isDesktopOrWeb) {
        return true;
      }
      return false;
    } catch (_) {
      return PlatformUtils.isDesktopOrWeb;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController?.close();
  }
}
