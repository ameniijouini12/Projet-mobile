import 'dart:convert';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/reservation.model.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  final String baseUrl =  AppConstants.baseUrl;

  Future<String> addReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservation/addReservation'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['reservation']['codeReservation'];
    } else {
      return "ERROR";
    }
  }

  
  Future<List<Reservation>> getReservationsByUserId(String userId) async {
   try {
    final response = await http.get(Uri.parse('$baseUrl/reservation/getReservationByUserID/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Reservation> reservations = [];
        for (var item in data) {
          reservations.add(Reservation.fromJson(item));
        }
        return reservations;
      } else {
        return [];
      }
    } catch (e) {
      Debugger.red('Error fetching reservations: $e');
      return [];
    }
  }




 
}
