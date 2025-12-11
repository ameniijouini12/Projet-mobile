import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../app/style/app_constants.dart';

class EstablishmentService {
  final String baseUrl = AppConstants.baseUrl;
  static const String cacheKey = 'establishmentCache';

  Future<List<Establishment>> fetchEstablishments() async {
    final response = await http.get(Uri.parse('$baseUrl/establishement/getAll')).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException('Connection timeout. Please try again later.');
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Establishment> establishments = data.map((e) {
        return Establishment.fromJson(e as Map<String, dynamic>);
      }).toList();
     
      await cacheData(establishments);
      Debugger.green('Establishments fetched successfully');
      return establishments;
    } else {
      throw Exception('Failed to load establishments');
    }
  }

  Future<void> cacheData(List<Establishment> data) async {
    var box = Hive.box<Establishment>('establishmentsBox');
     await box.clear();
     await box.addAll(data);
    Debugger.green('Establishments cached successfully');

  }
  Future<List<Establishment>> getCachedData() async {
    var box = Hive.box<Establishment>('establishmentsBox');
    List<Establishment> cachedData = box.values.toList();
    Debugger.green('Retrieved cached establishments data');
    return  cachedData;
   
  }


//hasInternetConnection() method
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }


Future <List<Establishment>> getAllEstablishments() async {
    final url = Uri.parse('$baseUrl/establishement/getAll');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Establishment> establishments = body
            .map((dynamic item) => Establishment.fromJson(item))
            .toList();
             print("//////////////////////////////// ESTABLISHMENTS//////////////////////") ; 
      print(establishments) ; 
        return establishments;
      } else {
        throw Exception('Failed to load establishments');
      }
    } catch (e) {
      Debugger.red('Error fetching establishments: $e');
      throw Exception('Failed to load establishments');
    }
  }
    Future<List<Food>> getProductsByEstablishmentID(String id) async {
    final url = Uri.parse('$baseUrl/establishement/getProductsByEstablishmentID');

    // Create the request body
    final Map<String, String> body = {
      'id': id,
    };

    // Debug prints
    Debugger.red('Sending request to $url with body: $body');

    // Make the POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    // Check the response status and parse the JSON
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      Debugger.red('Response JSON: $responseJson');

      List<Food> foods = responseJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Food.fromJson(json);
        } else {
          throw Exception('Unexpected JSON format');
        }
      }).toList();
      return foods;
        } else {
      Debugger.red('Failed response: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

 
}
