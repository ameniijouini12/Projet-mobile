// lib/viewmodels/food_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/services/food_service.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';

class FoodViewModel extends ChangeNotifier {
  final FoodService _service = FoodService();
  final List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  List<String> _selectedFilters = [];
  List<String> get selectedFilters => _selectedFilters;

  bool isLoading = false;
  UserViewModel userViewModel;

  final int _batchSize = 10;
  int _currentPage = 1;
  bool hasMoreData = true;
  bool _firstPageFetched = false;

  List<Food> get foods {
    if (_selectedFilters.isNotEmpty) {
      return _filteredFoods;
    }
    return _foods;
  }

  FoodViewModel(this.userViewModel) {
    fetchFoods();
  }

  Future<void> refreshFoods() async {
    fetchFoods(isRefresh: true);

  }

  Future<void> fetchFoods({bool isRefresh = false}) async {
    if (isLoading || !hasMoreData) return;

    if (isRefresh) {
      _foods.clear();
      _filteredFoods.clear();
      _selectedFilters.clear();
      _currentPage = 1;
      hasMoreData = true;
    }

    isLoading = true;
    notifyListeners();

    try {



      if (_foods.isEmpty || isRefresh) {
        Debugger.red('No food cached data found, fetching from server...');
      } else {
        Debugger.green('Loaded foods from cache.');
      }

  

       final newFoods = await _service.fetchFoods(page: _currentPage, batch: _batchSize);
      if (newFoods.length < _batchSize) {
        hasMoreData = false;
      }
      _foods.addAll(newFoods);
      await _service.cacheData(_foods);  // Cache the fetched data
      _currentPage++;
      _firstPageFetched = true; // Set the flag after fetching the first page
    } catch (e) {
      Debugger.yellow('Attempting to fetch cached foods...');
      _foods.addAll(await _service.getCachedData());
      Debugger.red('Error fetching foods: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void applyFilters(List<String> filters) {
    _selectedFilters = filters;
    _filteredFoods = _foods.where((food) {
      return filters.any((filter) => food.category.contains(filter));
    }).toList();

    if (_filteredFoods.isEmpty) {
      _filteredFoods = [];
    }
    notifyListeners();
  }

  void removeFilter(String filter) {
    _selectedFilters.remove(filter);
    applyFilters(_selectedFilters);
  }

  List<Food> mergeFoods(List<Food> cached, List<Food> fetched) {
    final Map<String, Food> foodMap = {for (var e in cached) e.name: e};
    for (var food in fetched) {
      foodMap[food.name] = food;
    }
    return foodMap.values.toList();
  }
}