import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const _tokenKey = 'auth_token';
  static const _expiryKey = 'auth_expiry';

  static Future<void> storeToken(String token, DateTime expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expiryKey, expiryDate.toIso8601String());
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
  }

  static Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString(_expiryKey);
    if (expiryString != null) {
      final expiryDate = DateTime.parse(expiryString);
      return expiryDate.isAfter(DateTime.now());
    }
    return false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
