import 'dart:math';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/models/establishement.model.dart';
import 'package:hiatunisie/models/food.model.dart';
import 'package:hiatunisie/models/map_marker.dart';
import 'package:hiatunisie/models/user.model.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:hiatunisie/views/foodPreference/food_pref_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import '../services/establishement_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentViewModel extends ChangeNotifier {
  final EstablishmentService _service = EstablishmentService();
  List<Establishment> _establishments = [];
  List<Establishment> get establishments => _establishments;
  


  UserViewModel _userViewModel = UserViewModel();
   List<MapMarker> _markers = [];
  List<MapMarker> get markers => _markers;

  List<Establishment> recommendedEstablishments = [];
  bool isLoading = false;
  bool _isSorting = false;
    bool _isCalculating = false;
    // ignore: prefer_final_fields
   
  final FoodPreferenceProvider _foodPreferenceProvider;

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


  //pull down refresh function
  Future<void> refreshEstablishments() async {
    isLoading = true;
    notifyListeners();
    try {

      _establishments = await _service.fetchEstablishments();
      await _service.cacheData(_establishments);
      updateMarkers(_establishments) ; 
      updateRecommendedEstablishments();
      calculateAllDistances();
       await sortByDistance();
    } catch (e) {
      Debugger.red('Error fetching establishments: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
    
  }
 

  
  EstablishmentViewModel(this._userViewModel, this._foodPreferenceProvider) {
    _userViewModel.addListener(updateRecommendedEstablishments);
    _foodPreferenceProvider.addListener(updateRecommendedEstablishments);
    fetchEstablishments();
    sortByDistance() ; 
  }

  Future<void> fetchEstablishments() async {
    isLoading = true;
    notifyListeners();
    try {
      Debugger.yellow('Attempting to fetch cached establishments...');
      _establishments = (await _service.getCachedData());
     
      if (_establishments.isEmpty) {
        Debugger.red('No cached data establishments found, fetching from server...');
        _establishments = await _service.fetchEstablishments();
        await _service.cacheData(_establishments);
      } else {
        Debugger.green('Loaded establishments from cache.');
        isLoading = false;
        notifyListeners();
      }
     updateMarkers(_establishments) ; 

      // Filter establishments based on user preferences
      updateRecommendedEstablishments();

      calculateAllDistances();

    await sortByDistance();

    } catch (e) {
      Debugger.red('Error fetching establishments: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
   void listenToPreferences(FoodPreferenceProvider foodPreferenceProvider) {
    foodPreferenceProvider.addListener(() {
      updateRecommendedEstablishments();
    });
  }

  void updateRecommendedEstablishments()async {
    recommendedEstablishments = filterByPreferences(establishments, _userViewModel.foodPreference);

    notifyListeners();
  }


  List<Establishment> filterByPreferences(List<Establishment> establishments, List<String> preferences) {
  return establishments.where((establishment) {
    return establishment.preferences != null && establishment.preferences!.any((pref) => preferences.contains(pref));
  }).toList();
}


 
void updateMarkers(List<Establishment> establishments) {
  _markers = establishments.map((establishment) {
    return MapMarker(
      image: establishment.image,
      title: establishment.name,
      address: establishment.address,
      location: latLng.LatLng(
        establishment.latitude,  
        establishment.longitude,
      ),
      rating: establishment.averageRating,
    );
  }).toList();
  notifyListeners();
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
      User user = _userViewModel.userData!;
      double userLat = user.latitude.toDouble();
      double userLon = user.longitude.toDouble();

      _distances = _establishments.map((establishment) {
        return _calculateDistance(userLat, userLon, establishment.latitude, establishment.longitude);
      }).toList();
    } catch (e) {
      Debugger.red('Error calculating distances: $e');
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
  }


  Future<void> sortByDistance() async {
    if (_userViewModel.userData == null) {
      return;
    }

    _isSorting = true;
    notifyListeners();

    try {
      User user = _userViewModel.userData!;
      double userLat = user.latitude.toDouble();
      double userLon = user.longitude.toDouble();

      // Pair each establishment with its calculated distance
      List<MapEntry<Establishment, double>> entries = establishments.map((est) {
        double distance = _calculateDistance(
            userLat, userLon, est.latitude, est.longitude);
        return MapEntry(est, distance);
      }).toList();

      // Sort by distance
      entries.sort((a, b) => a.value.compareTo(b.value));

      // Update the list of establishments and distances in sorted order
      _establishments = entries.map((e) => e.key).toList();
      _distances = entries.map((e) => e.value).toList();

      notifyListeners();
    } catch (e) {
      Debugger.red('Error sorting by distance: $e');
    } finally {
      _isSorting = false;
      notifyListeners();
    }
  }




  void launchMaps(double? latitude, double? longitude) async {
    if (_userViewModel.userData == null) {
      return;
    }

    try {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=${_userViewModel.userData!.latitude.toDouble()},${_userViewModel.userData!.longitude.toDouble()}&destination=$latitude,$longitude');


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
}
