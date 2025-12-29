import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../utility/no_internet_screen.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onConnected;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.onConnected,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  bool _isInitialCheck = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      setState(() {
        _isConnected = !result.contains(ConnectivityResult.none);
        _isInitialCheck = false;
      });

      if (_isConnected && widget.onConnected != null) {
        widget.onConnected!();
      }
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isInitialCheck = false;
      });
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final wasConnected = _isConnected;
    setState(() {
      _isConnected = !result.contains(ConnectivityResult.none);
    });

    if (!wasConnected && _isConnected && widget.onConnected != null) {
      widget.onConnected!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialCheck) {
      return CircularProgressIndicator();
    }

    if (!_isConnected) {
      return NoInternetScreen();
    }

    return widget.child;
  }
}
