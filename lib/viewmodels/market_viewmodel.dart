import 'dart:async';
import 'dart:math';
import 'package:hiatunisie/models/market.model.dart';
import 'package:hiatunisie/models/user.model.dart';
import 'package:hiatunisie/services/market_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hiatunisie/models/product.model.dart';

class MarketViewModel extends ChangeNotifier {
  final MarketService _service = MarketService();
  List<Market> _markets = [];
  List<Market> get markets => _markets;

  List<Market> _marketsByName = [];
  List<Market> get marketsByName => _marketsByName;

  bool isLoading = false;
  bool isFiltering = false;
  bool _isSorting = false;
  bool _isCalculating = false;

  UserViewModel userViewModel = UserViewModel();
  Timer? timer;

  String? _address;
  String? get address => _address;

  int? _lengthEstablishments;
  int? get lengthEstablishments => _lengthEstablishments;

  final double _distance = 0.0;

  List<double> _distances = [];
  bool get isCalculating => _isCalculating;
  bool get isSorting => _isSorting;
  double get distance => _distance;
  List<double> get distances => _distances;

  List<Food>? _foodbyestablishment;
  List<Food>? get foodbyestablishment => _foodbyestablishment;

  final bool _isFetchingFoods = false;

  bool get isFetchingFoods => _isFetchingFoods;
  MarketViewModel(this.userViewModel) {
    fetchMarkets();
    sortByDistance();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      refreshMarkets();
    });
  }

  // Pull down refresh function
  Future<void> refreshMarkets() async {
    isLoading = true;
    notifyListeners(); // Notify that refresh is in progress

    try {
      _markets = await _service.fetchMarkets();
      await _service.cacheData(_markets);
      notifyListeners();
      await calculateAllDistances();
      await sortByDistance();
      print("////////////////////////////////////////////////////rfetched new list ${_markets.length}///////////////////////////////////////////////////");

      Debugger.green('Refreshing markets...');
    } catch (e) {
      Debugger.red('Error refreshing markets: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Only notify once at the end
    }
  }

  Future<void> fetchMarketsByName(String Name) async {
    isFiltering = true;
    notifyListeners();
    try {
      Debugger.yellow('Attempting to fetch marketsByName...');

      final marketsFiltered = await _service.fetchAllMarketsByName(Name);

      if (marketsFiltered.isEmpty) {
        Debugger.red('No markets cached data found, fetching from server...');
        print('No markets cached data found, fetching from server... ');
      } else {
        Debugger.green('Fetched markets By name found...');
        _marketsByName = marketsFiltered;
        notifyListeners();
      }
    } catch (e) {
      Debugger.red('Error fetching markets: $e');
    } finally {
      isFiltering = false;
      notifyListeners();
    }
  }

  Future<void> fetchMarkets() async {
    isLoading = true;
    notifyListeners();
    try {
      Debugger.yellow('Attempting to fetch cached markets...');

      _markets = await _service.fetchMarkets();
      final cachedMarkets = await _service.getCachedData();

      if (cachedMarkets.isEmpty) {
        Debugger.red('No markets cached data found, fetching from server...');
        print('No markets cached data found, fetching from server... ');

        await _service.cacheData(_markets);
      } else {
        Debugger.red('cached Markets found...');
        print('cached Markets found... ');
        _markets = cachedMarkets;
        notifyListeners();
        await _service.cacheData(_markets);
      }

      if (_markets.isNotEmpty) {
        await calculateAllDistances();
        await sortByDistance();
        print('Fetch markets function response: $_markets');
      }
    } catch (e) {
      Debugger.red('Error fetching markets: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double _calculateDistance(double? lat1, double? lon1, double? lat2, double? lon2) {
    const R = 6371.0; // Radius of the earth in km

    final lat1Rad = lat1! * pi / 180;
    final lon1Rad = lon1! * pi / 180;
    final lat2Rad = lat2! * pi / 180;
    final lon2Rad = lon2! * pi / 180;

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    return R * c; // Distance in km
  }

  Future<void> calculateAllDistances() async {
    _isCalculating = true;
    notifyListeners();

    try {
      User user = userViewModel.userData!;
      double? userLat = user.latitude?.toDouble();
      double? userLon = user.longitude?.toDouble();

      if (userLat == null || userLon == null) {
        Debugger.red('User coordinates are null. Cannot calculate distances.');
        return;
      }

      // Simulate a delay for distance calculation
      _distances = _markets.map((market) {
        return _calculateDistance(userLat, userLon, market.latitude, market.langitude);
      }).toList();
    } catch (e) {
      Debugger.red('Error calculating distances: $e');
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
  }

  Future<void> sortByDistance() async {
    if (userViewModel.userData == null) {
      Debugger.red('User data is null. Cannot sort by distance.');
      return;
    }

    _isSorting = true;
    notifyListeners();

    try {
      User user = userViewModel.userData!;
      double? userLat = user.latitude?.toDouble();
      double? userLon = user.longitude?.toDouble();

      if (userLat == null || userLon == null) {
        Debugger.red('User coordinates are null. Cannot sort by distance.');
        return;
      }

      // Filter markets with invalid coordinates
      _markets = _markets.where((market) {
        return market.latitude != null && market.langitude != null;
      }).toList();

      // Sort the markets by distance
      _markets.sort((a, b) {
        double distanceA = _calculateDistance(userLat, userLon, a.latitude, a.langitude);
        double distanceB = _calculateDistance(userLat, userLon, b.latitude, b.langitude);
        return distanceA.compareTo(distanceB);
      });

      Debugger.green('Markets sorted by distance successfully.');
      notifyListeners();
    } catch (e) {
      Debugger.red('Error sorting markets by distance: $e');
    } finally {
      _isSorting = false;
      notifyListeners();
    }
  }

  void launchMaps(double? latitude, double? longitude) async {
    if (userViewModel.userData == null) {
      return;
    }

    try {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=${userViewModel.userData!.latitude.toDouble()},${userViewModel.userData!.longitude.toDouble()}&destination=$latitude,$longitude');

      final canLaunch = await canLaunchUrl(url);

      if (canLaunch) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Debugger.red('Error launching maps: $e');
    }
  }

  String? _error;
  List<String> _categories = [];
  Map<String, List<Product>> _categoryProducts = {};
  Market? _selectedMarket;

  String? get error => _error;
  List<String> get categories => _categories;
  Map<String, List<Product>> get categoryProducts => _categoryProducts;
  Market? get selectedMarket => _selectedMarket;

  Future<bool> prepareMarketData(Market market) async {
    _selectedMarket = market;
    _error = null;
    notifyListeners();

    try {
      // 1) Fetch categories from the backend
      Debugger.green('Fetching categories for market: ${market.id}');
      _categories = await _service.getMarketCategories(market.id); 
      
      // 2) Fetch grouped products
      Debugger.green('Fetching products for market: ${market.id}');
      final groupedProducts = await _service.getProductsByMarketIDAndCategory(
        marketId: market.id,
        page: 1,
        batch: 5,
      );

      if (groupedProducts is Map<String, List<Product>>) {
        // Store them
        _categoryProducts = groupedProducts;
      }

      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      Debugger.red('Error preparing market data: $e');
      Debugger.red('Stack trace: $stackTrace');
      _error = 'Error loading market data: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadMoreProductsForCategory(String category, {int page = 1}) async {
    try {
      final products = await _service.getProductsByMarketIDAndCategory(
        marketId: _selectedMarket!.id,
        category: category,
        page: page,
        batch: 10,
      );

      if (products is List<Product>) {
        if (_categoryProducts[category] == null) {
          _categoryProducts[category] = [];
        }
        _categoryProducts[category]!.addAll(products);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearMarketData() {
    _selectedMarket = null;
    _categories = [];
    _categoryProducts = {};
    _error = null;
    _selectedProducts.clear();
    notifyListeners();
  }

  Set<Product> _selectedProducts = {};
  Set<Product> get selectedProducts => _selectedProducts;

  void toggleProductSelection(Product product) {
    if (_selectedProducts.contains(product)) {
      _selectedProducts.remove(product);
    } else {
      _selectedProducts.add(product);
    }
    notifyListeners();
  }

  bool isProductSelected(Product product) {
    return _selectedProducts.contains(product);
  }
}
