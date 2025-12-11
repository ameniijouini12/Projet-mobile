import 'package:hiatunisie/services/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

import '../app/style/app_constants.dart';

class WebSocketService {
  IO.Socket? socket;
  final String marketId = '66f1cfbf43d0b72bb5359970';
  bool _isConnected = false; // Track connection status
  Timer? _timeoutTimer; // Timer for connection timeout

  void connect() {
    socket = IO.io(AppConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Prevent auto connection
    });

    // Start connection timeout timer
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (!_isConnected) {
        print('⏳ Connection timeout! Disconnecting WebSocket...');
        disconnect();
      }
    });

    socket?.connect(); // Manually connect

    socket?.on('connect', (_) {
      _isConnected = true; // Mark as connected
      _timeoutTimer?.cancel(); // Cancel timeout if connected
      print('✅ Connected to WebSocket server');
      socket?.emit('joinMarketChannel', marketId);
    });

    socket?.on('newReservation', (reservation) async {
      print('📩 New reservation received: $reservation');

      final Map<String, dynamic> reservationData = Map<String, dynamic>.from(reservation);
      final String codeReservation = reservationData['codeReservation'];

      await NotificationService().checkPermissions();
      await NotificationService().initNotification();
      await NotificationService().showNotification(
        1,  // Notification ID
        'New Reservation: $codeReservation',
        'Confirm reservation received',
      );
    });

    socket?.on('disconnect', (_) {
      _isConnected = false; // Update status
      print('❌ Disconnected from WebSocket server');
    });

    socket?.on('connect_error', (error) {
      print('⚠ Connection Error: $error');
    });
  }

  // Disconnect the socket connection
  void disconnect() {
    socket?.disconnect();
    _isConnected = false;
    _timeoutTimer?.cancel(); // Cancel any ongoing timeout
  }
}

