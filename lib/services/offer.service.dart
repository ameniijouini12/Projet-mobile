import 'dart:async';
import 'dart:convert';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/offer.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class OfferService {
  final String baseUrl = AppConstants.baseUrl;
  static const String cacheKey = 'offerCache';
  late Box<Offer> _box;

  OfferService() {
    _initBox();
  }

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen('offerBox')) {
      _box = await Hive.openBox<Offer>('offerBox');
    } else {
      _box = Hive.box<Offer>('offerBox');
    }
  }

  Future<List<Offer>> fetchOffers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/offer/getAll')).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timeout. Please try again later.');
        },
      );
      
      if (response.statusCode == 200) {
        Debugger.green('Raw response: ${response.body}');
        
        final dynamic decodedResponse = json.decode(response.body);
        
        final List<dynamic> data = decodedResponse is Map ? 
            (decodedResponse['data'] ?? []) : 
            (decodedResponse as List);
        
        if (data.isEmpty) {
          Debugger.yellow('No offers found in the response');
          return [];
        }

        final offers = data.map((json) {
          try {
            return Offer.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            Debugger.red('Error parsing offer: $e');
            Debugger.red('Problematic JSON: $json');
            return null;
          }
        }).whereType<Offer>().toList();

        if (offers.isNotEmpty) {
          await cacheData(offers);
          Debugger.green('Offers fetched successfully: ${offers.length} offers');
        }
        
        return offers;
      } else {
        Debugger.red('Failed to load offers. Status code: ${response.statusCode}');
        throw Exception('Failed to load offers');
      }
    } catch (e) {
      Debugger.red('Error in fetchOffers: $e');
      rethrow;
    }
  }

  Future<void> deleteOfferById(String offerId) async {
    try {
      final url = Uri.parse('$baseUrl/offer/deleteOfferById/$offerId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Offer not found (status code 404).');
      } else {
        throw Exception(
          'Failed to delete offer. '
          'Status code: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print("Error in deleteOfferById: $e");
      rethrow;
    }
  }

  Future<void> cacheData(List<Offer> offers) async {
    try {
      await _box.clear();  // Clear old cached data
      await _box.addAll(offers);
    } catch (e) {
      Debugger.red('Error caching data: $e');
    }
  }

  Future<List<Offer>> getCachedData() async {
    try {
      List<Offer> cachedData = _box.values.toList();
      Debugger.green('Retrieved cached data ');
      return cachedData;
    } catch (e) {
      Debugger.red('Error getting cached data: $e');
      return [];
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('http://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Offer>> getOffersByEstablishment(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/offer/getByEstablishment/$id'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Offer> offers = data.map((e) {
        return Offer.fromJson(e as Map<String, dynamic>);
      }).toList();
      return offers;
    } else {
      throw Exception('Failed to load offers');
    }
  }

  Future<void> decrementOfferQuantity(String offerId) async {
    try {
      final url = Uri.parse('$baseUrl/offer/decrementQuantityOfferById/$offerId');
      final response = await http.put(url);

      if (response.statusCode == 404) {
        throw Exception('Offer not found');
      }

      if (response.statusCode == 400) {
        throw Exception('Quantity is already at zero');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to update offer quantity: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      Debugger.green('Offer quantity decremented successfully: ${responseData['message']}');
      
    } catch (e) {
      Debugger.red('Error decrementing offer quantity: $e');
      rethrow;
    }
  }

  Future<void> decrementOfferQuantityBy(String offerId, int amount) async {
    try {
      final url = Uri.parse('$baseUrl/offer/decrementQuantityOfferById/$offerId/$amount');
      final response = await http.put(url);

      if (response.statusCode == 404) {
        throw Exception('Offer not found');
      }

      if (response.statusCode == 400) {
        throw Exception('Invalid quantity or offer already at zero');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to update offer quantity: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      Debugger.green('Offer quantity decremented by $amount successfully: ${responseData['message']}');
      
    } catch (e) {
      Debugger.red('Error decrementing offer quantity by $amount: $e');
      rethrow;
    }
  }
}