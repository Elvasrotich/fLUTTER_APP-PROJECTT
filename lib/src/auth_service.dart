import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _userKey = 'username';

  static Future<void> signUp(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, username);
  }

  static Future<void> signIn(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_userKey);
    if (stored != username) {
      await prefs.setString(_userKey, username);
    }
  }

  static Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
