import 'package:flutter/material.dart';
import 'package:hiatunisie/helpers/debugging_printer.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';

class FoodPreferenceProvider with ChangeNotifier {
   UserViewModel _userViewModel;

  FoodPreferenceProvider(this._userViewModel);

  final Map<String, bool> _selectedPreferences = {
    "Fast Food": false,
    "Vegan": false,
    "Sugar": false,
    "Nut-Free": false,
  };

  Map<String, bool> get selectedPreferences => _selectedPreferences;

  bool _isLoading = false;
   
  bool get isLoading => _isLoading;

  void togglePreference(String preference) {
    _selectedPreferences[preference] = !_selectedPreferences[preference]!;
    notifyListeners();
  }

  void updateUserViewModel(UserViewModel userViewModel) {
    _userViewModel = userViewModel;
  }

  //fetch last pref
  void fetchLastPref() {
    final userViewModel = _userViewModel;
    if (userViewModel.userData != null) {
      final userPrefs = userViewModel.userData!.foodPreference;
      for (var pref in userPrefs) {
        if (_selectedPreferences.containsKey(pref)) {
          _selectedPreferences[pref] = true;
        }
      }
        }
    notifyListeners();
  }

  Future<void> savePreferences() async{
    _isLoading = true;
    notifyListeners();
    // Save preferences to the server
    final userId = _userViewModel.userId;
    final selectedPrefs = _selectedPreferences.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();


    if (userId != null) {
      final success = await _userViewModel.userService.saveUserPreferences(userId, selectedPrefs);

      if (success) {
        Debugger.green('Preferences saved successfully');
        await _userViewModel.fetchUpdatedUserData();
      } else {
        Debugger.red('Failed to save preferences');
      }
    } else {
      Debugger.red('User not authenticated');
    }
    _isLoading = false;
    notifyListeners();

  }

  void updatePreferences() async{ 
   _isLoading = true;
    // Update preferences in the server
    final userId = _userViewModel.userId;
    final selectedPrefs = _selectedPreferences.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (userId != null) {
      final success = await _userViewModel.userService.saveUserPreferences(userId, selectedPrefs);

      if ( success) {
        Debugger.green('Preferences updated successfully');
      } else {
        Debugger.red('Failed to update preferences');
      }
    } else {
      Debugger.red('User not authenticated');
    }

    _isLoading = false;
    notifyListeners();

  }

  void initializePreferences(List<String> preferences) {
    for (var preference in preferences) {
      if (_selectedPreferences.containsKey(preference)) {
        _selectedPreferences[preference] = true;
      }
    }
    notifyListeners();
  }
}
