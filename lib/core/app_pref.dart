import 'package:shared_preferences/shared_preferences.dart';

class AppPerf {

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<SharedPreferences> getPreference() {
    return _prefs;
  }
}