import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../app/style/app_constants.dart';

class MarketService {
  final String baseUrl = AppConstants.baseUrl;
  static const String cacheKey = 'marketCache';

  Future<List<Market>> fetchMarkets() async {
    final response = await http.get(Uri.parse('$baseUrl/market/getAllMarkets')).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException('Connection timeout. Please try again later.');
      },
    );
   


    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);
      List<Market> markets = data.map((e) {
        return Market.fromJson(e as Map<String, dynamic>);
      }).toList();
print(markets) ; 
      await cacheData(markets);
      Debugger.green('markets fetched successfully');
      print('markets fetched successfully');
print('Fetch markets function response 2 : ${response.body}');

      return markets;
    } else {
        print('Failed to load markets');

      throw Exception('Failed to load markets');

    }
  }

  Future<List<Market>> fetchAllMarketsByName(String name) async {
    final url = Uri.parse('$baseUrl/market/fetchAllMarketsByName');

    // Create the request body
    final Map<String, String> body = {
      'name': name,
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

      List<Market> Markets = responseJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Market.fromJson(json);
        } else {
          throw Exception('Unexpected JSON format');
        }
      }).toList();
      return Markets;
        } else {
      Debugger.red('Failed response: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> cacheData(List<Market> data) async {
    var box = Hive.box<Market>('marketsBox');
     await box.clear();
     await box.addAll(data);
    Debugger.green('Markets cached successfully');
          print('markets fetched successfully cacheData ');

    

  }



  Future<List<Market>> getCachedData() async {
    var box = Hive.box<Market>('marketsBox');
    List<Market> cachedData = box.values.toList();
    Debugger.green('Retrieved cached markets data');
print('Fetch cachedData function : $cachedData');

    return  cachedData;
   
  }


//hasInternetConnection() method
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }


Future <List<Market>> getAllMarkets() async {
    final url = Uri.parse('$baseUrl/market/getAllMarkets');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Market> markets = body
            .map((dynamic item) => Market.fromJson(item))
            .toList();
        return markets;
      } else {
        throw Exception('Failed to load markets');
      }
    } catch (e) {
      Debugger.red('Error fetching markets: $e');
      throw Exception('Failed to load markets');
    }
  }
    Future<List<Product>> getProductsByEstablishmentID(String id) async {
    final url = Uri.parse('$baseUrl/market/getProductsByMarketID');

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

      List<Product> products= responseJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Product.fromJson(json);
        } else {
          throw Exception('Unexpected JSON format');
        }
      }).toList();
      return products;
        } else {
      Debugger.red('Failed response: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> getProductsByMarketIDAndCategory({ required String marketId,String? category,int page = 1,int batch = 5,}) async {
    final queryParameters = {'id': marketId,
      if (category != null) 'category': category,
      'page': page.toString(),
      'batch': batch.toString(),
    };

    final url = Uri.parse('$baseUrl/market/getProductsByMarketIDAndCategory').replace(queryParameters: queryParameters);

    try {
      Debugger.red('Sending request to $url');

      final response = await http.get(url,headers: {'Content-Type': 'application/json'},
      );

      Debugger.green('Response status code: ${response.statusCode}');
      Debugger.green('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseJson = json.decode(response.body);
        Debugger.green('Decoded JSON type: ${responseJson.runtimeType}');
        
        if (category == null) {
          // Handle case when no category is specified
          
          
          if (responseJson is Map) {
            Debugger.green('Response is a Map, parsing grouped products');
            Map<String, List<Product>> groupedProducts = {};
            
            try {
              responseJson.forEach((key, value) {
                if (value is List) {
                  Debugger.green('Parsing products for category: $key');
                  final products = value
                      .map((item) => Product.fromJson(item as Map<String, dynamic>))
                      .toList();
                  groupedProducts[key.toString()] = products;
                  Debugger.green('Added ${products.length} products for category $key');
                }
              });
              
              if (groupedProducts.isEmpty) {
                Debugger.red('No products found in any category');
                throw Exception('No products found');
              }

              
              return groupedProducts;
            } catch (e) {
              Debugger.red('Error parsing grouped products: $e');
              throw Exception('Error parsing products: $e');
            }
          }
          
          Debugger.red('Invalid response type: ${responseJson.runtimeType}');
          throw Exception('Invalid response format');
        } else {
          // Handle case when category is specified
         
          
          try {
            final products = responseJson
                .map((json) => Product.fromJson(json as Map<String, dynamic>))
                .toList();
                print("Successssssssssssssss $products") ; 
            
            Debugger.green('Successfully parsed ${products.length} products for category $category');
            return products;
          } catch (e) {
            Debugger.red('Error parsing products for category $category: $e');
            throw Exception('Error parsing products: $e');
          }
        }
      } else {
        Debugger.red('Failed response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      Debugger.red('Error in getProductsByMarketIDAndCategory: $e');
      Debugger.red('Stack trace: $stackTrace');
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<String>> getMarketCategories(String marketId) async {
    final url = Uri.parse('$baseUrl/market/getMarketCategories')
        .replace(queryParameters: {'marketId': marketId});

    try {
      Debugger.red('Sending request to $url');
      
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      Debugger.green('Response status code: ${response.statusCode}');
      Debugger.green('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        
        if (!responseJson.containsKey('categories')) {
          Debugger.red('Response does not contain categories key');
          throw Exception('Invalid response format');
        }

        final List<dynamic> categories = responseJson['categories'];
        Debugger.green('Categories response: $categories');
        
        final List<String> result = categories.map((category) {
          if (category is Map<String, dynamic>) {
            return category['name']?.toString() ?? '';
          }
          return category.toString();
        }).where((name) => name.isNotEmpty).toList();

        Debugger.green('Parsed categories: $result');
        return result;
      } else {
        Debugger.red('Failed to fetch market categories: ${response.body}');
        throw Exception('Failed to fetch market categories');
      }
    } catch (e, stackTrace) {
      Debugger.red('Error fetching market categories: $e');
      Debugger.red('Stack trace: $stackTrace');
      throw Exception('Failed to fetch market categories: $e');
    }
  }

}
