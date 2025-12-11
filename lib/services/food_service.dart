import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../app/style/app_constants.dart';

class FoodService {
  final String baseUrl = AppConstants.baseUrl;
  static const String cacheKey = 'foodCache';

  Future<List<Food>> fetchFoods({int page = 1, int batch = 10}) async {
    final response = await http.get(Uri.parse('$baseUrl/food/getAllFoods?page=$page&batch=$batch')).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException('Connection timeout. Please try again later.');
      },
    );
    if (response.statusCode == 200) {
      Debugger.green('Response body: ${response.body}');
      try {
        List<dynamic> data = json.decode(response.body);
        List<Food> foods = data.map((e) {
          return Food.fromJson(e as Map<String, dynamic>);
        }).toList();
        await cacheData(foods);
        return foods;
      } catch (e) {
        Debugger.red('Error decoding JSON: $e');
        throw Exception('Failed to decode foods');
      }
    } else {
      throw Exception('Failed to load foods');
    }
  }

  Future<List<Review>> fetchReviews(String foodId) async {
    final response = await http.get(Uri.parse('$baseUrl/food/getReviewByFoodID/$foodId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Review> reviews = data.map((e) {
        return Review.fromJson(e as Map<String, dynamic>);
      }).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

   Future<void> addReview(String foodId, Map<String , dynamic> review) async {
    final url = Uri.parse('$baseUrl/food/addReview/$foodId');
    final response = await http.post(url, body: json.encode(review), headers: {
      'Content-Type': 'application/json',
    });

     if (response.statusCode == 200) {
      // Handle successful response
      return jsonDecode(response.body);
    } else {
      // Handle error response
      throw Exception('Failed to add review');
    }
  }



 
    Future<void> cacheData(List<Food> foods) async {
    var box = Hive.box<Food>('foodBox');
    await box.clear();  // Clear old cached data
    await box.addAll(foods);
  }

   Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Food>> getCachedData() async {
    var box = Hive.box<Food>('foodBox');
    List<Food> cachedData = box.values.toList();
    Debugger.green('Retrieved cached food data');
    return cachedData;
  }
 

  



}
