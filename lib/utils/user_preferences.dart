import 'package:shared_preferences/shared_preferences.dart';
import 'package:secret_vault/utils/crypto_utils.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _prefs {
    if (_preferences == null) {
      throw Exception('UserPreferences not initialized. Call init() first.');
    }
    return _preferences!;
  }



  static const String _keyDecimalPlaces = 'decimal_places';
  static const int _defaultDecimalPlaces = 2;

  static int get decimalPlaces {
    return _prefs.getInt(_keyDecimalPlaces) ?? _defaultDecimalPlaces;
  }

  static Future<bool> setDecimalPlaces(int places) {
    return _prefs.setInt(_keyDecimalPlaces, places);
  }



  static const String _keySoundType = 'sound_type';
  static const String _defaultSoundType = 'default';

  static String get soundType {
    return _prefs.getString(_keySoundType) ?? _defaultSoundType;
  }

  static Future<bool> setSoundType(String type) {
    return _prefs.setString(_keySoundType, type);
  }



  static const String _keyFirstTimePassword = 'first_time_password';

  static bool get isFirstTimePassword {
    return _prefs.getBool(_keyFirstTimePassword) ?? true;
  }

  static Future<bool> setFirstTimePassword(bool value) {
    return _prefs.setBool(_keyFirstTimePassword, value);
  }



  static const String _keyShowImportTips = 'show_import_tips';

  static bool get showImportTips {
    return _prefs.getBool(_keyShowImportTips) ?? true;
  }

  static Future<bool> setShowImportTips(bool value) {
    return _prefs.setBool(_keyShowImportTips, value);
  }



  static const String _keyPasswordAttempts = 'password_attempts';
  static const String _keyPasswordLockTime = 'password_lock_time';

  static int get passwordAttempts {
    return _prefs.getInt(_keyPasswordAttempts) ?? 0;
  }

  static Future<bool> setPasswordAttempts(int attempts) {
    return _prefs.setInt(_keyPasswordAttempts, attempts);
  }

  static Future<bool> incrementPasswordAttempts() async {
    int attempts = passwordAttempts;
    return setPasswordAttempts(attempts + 1);
  }

  static Future<bool> resetPasswordAttempts() {
    return setPasswordAttempts(0);
  }

  static String? get passwordLockTime {
    return _prefs.getString(_keyPasswordLockTime);
  }

  static Future<bool> setPasswordLockTime(String? time) {
    if (time == null) {
      return _prefs.remove(_keyPasswordLockTime);
    }
    return _prefs.setString(_keyPasswordLockTime, time);
  }



  static const String _keyEmergencyMode = 'emergency_mode_enabled';
  static const String _keyEmergencyPassword = 'emergency_password';

  static bool get emergencyModeEnabled {
    return _prefs.getBool(_keyEmergencyMode) ?? false;
  }

  static Future<bool> setEmergencyModeEnabled(bool value) {
    return _prefs.setBool(_keyEmergencyMode, value);
  }

  static String? get emergencyPassword {
    return _prefs.getString(_keyEmergencyPassword);
  }

  static Future<bool> setEmergencyPassword(String password) {

    final encrypted = CryptoUtils.hashPassword(password);
    return _prefs.setString(_keyEmergencyPassword, encrypted);
  }



  static Future<bool> clearAll() {
    return _prefs.clear();
  }
}
