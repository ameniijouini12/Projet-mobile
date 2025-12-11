import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hiatunisie/app/style/app_constants.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = AppConstants.baseUrl;
  static const String cacheKey = 'productCache';

 Future<List<Product>> fetchMarketsProducts(String marketID) async {
    print('Market ID: $marketID');

  final response = await http.get(Uri.parse('$baseUrl/market/getProductsByMarketID?id=$marketID'));
  print('Market ID: $marketID');


  
        

  if (response.statusCode == 200) {
    Debugger.green('Response body: ${response.body}');
            print('products productsproductsproductsproductsproductsproducts:${response.body}');

    try {
      List<dynamic> data = json.decode(response.body);
      List<Product> products = data.map((e) {
        return Product.fromJson(e as Map<String, dynamic>);
      }).toList();
      await cacheData(products);  
        print('products fetched pleqqqqqqqse: $products');

      return products;
    } catch (e) {
      Debugger.red('Error decoding JSON: $e');
      throw Exception('Failed to decode products');
    }
  } else {
    Debugger.red('Failed to load products, status code: ${response.statusCode}');
    throw Exception('Failed to load products');
  }
}





   



 
    Future<void> cacheData(List<Product> products) async {
    var box = Hive.box<Product>('productBox');
    await box.clear();  // Clear old cached data
    await box.addAll(products);
  }

   Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Product>> getCachedData() async {
    var box = Hive.box<Product>('productBox');
    List<Product> cachedData = box.values.toList();
    Debugger.green('Retrieved cached Product data');
    return cachedData;
  }
 

  



}
