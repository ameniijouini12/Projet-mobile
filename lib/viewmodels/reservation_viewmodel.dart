import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/reservation.model.dart';
import 'package:hiatunisie/services/reservation_service.dart';

class ReservationViewModel extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _reservationCode;
  String? get reservationCode => _reservationCode;
  String? _error;
  String? get error => _error;

   List<Reservation> _reservations = [];

  List<Reservation> get myReservation => _reservations;

  bool _isLoadingScreenshot = false;
  bool get isLoadingScreenshot => _isLoadingScreenshot;


  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addReservation(Reservation reservation) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    try {
      _reservationCode = await _reservationService.addReservation(reservation);
      await Future.delayed(const Duration(seconds: 2));
      if (_reservationCode == "ERROR") {
        _reservationCode = null;
        _error = "An error occurred while adding the reservation";
      }
    } catch (e) {
      _reservationCode = null;
      _error = "An error occurred while adding the reservation";
    } finally {
      _isLoading = false;
      _error = null;
      notifyListeners();


    }

  }

  void setLoadingScreenshot(bool value) {
    _isLoadingScreenshot = value;
    notifyListeners();
  }

  Future<void> getMyReservations(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      Debugger.green("fetching reservations for user $userId");
      _reservations = await _reservationService.getReservationsByUserId(userId);
    } catch (e) {
      _reservations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
     
    }

  }

  void clearAll() {
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}