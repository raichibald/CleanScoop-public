import 'package:clean_scoop/key_value_storage/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesKeyValueStorage(this._sharedPreferences) {
    _tryClearStorageData();
  }

  static const _kFirstTimeLaunch = 'key.first_time_launch';

  @override
  Future<bool?> getBool(String key) async {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _sharedPreferences.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }

  @override
  Future<void> setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }

  @override
  Future<void> clearAll() => _sharedPreferences.clear();

  void _tryClearStorageData() async {
    final isFirstLaunch = _sharedPreferences.getBool(_kFirstTimeLaunch) ?? true;
    if (isFirstLaunch) {
      await clearAll();
      await _sharedPreferences.setBool(_kFirstTimeLaunch, false);
    }
  }
}
