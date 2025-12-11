import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:http/http.dart' as http;

class ConnectivityManager extends ChangeNotifier {
  final _connectivity = Connectivity();
  bool _isConnected = false;
  bool _hasInternetConnection = false;
  bool _hasServerConnection = true;
  bool _isCheckingConnection = false;
  final String _serverUrl = AppConstants.baseUrl; // Your server URL

  bool get hasInternetConnection => _hasInternetConnection;
  bool get hasServerConnection => _hasServerConnection;
  bool get isConnected => _isConnected;
  bool get isCheckingConnection => _isCheckingConnection;

  ConnectivityManager() {
    startMonitoring();
    checkInitialConnectivity();
    
  }

  void startMonitoring() async{
    final initialConnectivityResult = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      bool wasConnected = _isConnected;
      _isConnected = results.contains(ConnectivityResult.none) ? false : true;

      // Notify only if the connectivity status differs from the previous status
      if (wasConnected != _isConnected) {
        Debugger.red("Connectivity Result: $results");
        Debugger.green("Is Connected: $_isConnected");
        await checkConnectivity();
        notifyListeners();

      }
    });


  }

  Future<void> checkInitialConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    ConnectivityResult result = connectivityResult.first;
    bool wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;



    // Notify only if the initial connectivity status differs from the current status
    if (wasConnected != _isConnected) {
      Debugger.red("Initial Connectivity Result: $result");
      Debugger.green("Initial Is Connected: $_isConnected");

      notifyListeners();

    }

    await checkConnectivity();


  }

  Future<bool> checkServerConnection() async {
    _isCheckingConnection = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_serverUrl)).timeout(
        const Duration(seconds: 5),
      );
      _hasServerConnection = response.statusCode == 200;
    } catch (e) {
      _hasServerConnection = false;

    }finally{
      _isCheckingConnection = false;
      notifyListeners();
    }
    return _hasServerConnection;
  }

  Future<void> checkConnectivity() async {
    _isCheckingConnection = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_serverUrl) ).timeout(
        const Duration(seconds: 5),
      );
      _hasInternetConnection = response.statusCode == 200;
    } catch (e) {
      _hasInternetConnection = false;
    } finally {
      _isCheckingConnection = false;
      notifyListeners();
    }
  }
}
