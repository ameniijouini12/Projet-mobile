// lib/viewmodels/food_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/product.model.dart';
import 'package:hiatunisie/services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  List<Product> get products => _products;

  



  bool isLoading = false;
  

  bool hasMoreData = true;



 
 /* Future<void> refreshProducts() async {
    isLoading = true;
    notifyListeners();
    _currentPage = 1;
    hasMoreData = true;
    _products.clear();
    _firstPageFetched = false;
    try {
      final newFoods = await _service.fetchProducts(page: _currentPage, batch: _batchSize);
      _products.addAll(newFoods);
      await _service.cacheData(_products);  // Cache the fetched data
      _firstPageFetched = true; // Set the flag after fetching the first page
      if (newFoods.length < _batchSize) {
        hasMoreData = false; // No more data to fetch
      }
      _currentPage++;
    } catch (e) {
      Debugger.red('Error fetching products: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }*/

  Future<void> fetchProducts( String? marketId) async {

   


    isLoading = true;
    notifyListeners();

    try {
      Debugger.yellow('Attempting to fetch cached products...');

     /* if (_products.isEmpty || isRefresh) {
        Debugger.red('No food cached data found, fetching from server...');
      } else {
        Debugger.green('Loaded products from cache.');
      }*/

  

  _products = await _service.fetchMarketsProducts(marketId!);
        notifyListeners();
        print('is products are Loaded products $_products') ; 
      /*if (newFoods.length < _batchSize) {
        hasMoreData = false;
      }
      _products.addAll(newFoods);*/
      await _service.cacheData(_products);  // Cache the fetched data
     // _currentPage++;
     //_firstPageFetched = true;
      print('Loaded products $_products') ; 
       // Set the flag after fetching the first page
    } catch (e) {
      Debugger.red('Error fetching products: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  

 

  /*List<Product> mergeFoods(List<Product> cached, List<Product> fetched) {
    final Map<String, Product> foodMap = {for (var e in cached) e.name: e};
    for (var food in fetched) {
      foodMap[food.name] = food;
    }
    return foodMap.values.toList();
  }*/
}     