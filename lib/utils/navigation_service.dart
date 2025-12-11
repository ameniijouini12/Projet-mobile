import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateToOnBoardScreen() async {
    await navigatorKey.currentState?.pushReplacementNamed('/onboard');
  }

  Future<void> navigateToHomeScreen() async {
    await navigatorKey.currentState?.pushReplacementNamed('/home');
  }

  
}
