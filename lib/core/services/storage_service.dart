import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _lastEmailKey = 'last_email';
  static const String _lastPasswordKey = 'last_password';

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_hasSeenOnboardingKey, value);
  }

  bool hasSeenOnboarding() {
    return _prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> saveLoginCredentials(String email, String password) async {
    await _prefs.setString(_lastEmailKey, email);
    await _prefs.setString(_lastPasswordKey, password);
  }

  String? getLastEmail() {
    return _prefs.getString(_lastEmailKey);
  }

  String? getLastPassword() {
    return _prefs.getString(_lastPasswordKey);
  }
} 