import 'package:flutter/material.dart';
import 'package:hiatunisie/utils/navigation_service.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';

class SplashViewModel extends ChangeNotifier {
  final UserViewModel _userViewModel; // Declare UserViewModel variable
  final NavigationService _navigationService =
      NavigationService(); // Initialize navigation service

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SplashViewModel(this._userViewModel) {
    initialize();
  }
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    // ✅ Ensure session is initialized before navigation
    _isLoading = false;
    notifyListeners();

    // Example: navigate to '/home' or '/onboard' based on some condition
    if (_userViewModel.isAuthenticated()) {
      await _navigationService.navigateToHomeScreen();
    } else {
      await _navigationService.navigateToOnBoardScreen();
    }
  }
}
