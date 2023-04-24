import 'dart:convert';

import 'package:ehealth/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const String _account = "account";

  Future<SharedPreferences> getPreference() {
    return _prefs;
  }

  Future<void> setAccount(Account account) async {
    String json = jsonEncode(account.toJson());
    _prefs.then((SharedPreferences prefs) {
      (prefs.setString(_account, json));
    });
  }

  Future<Account?> getAccount() async {
    return _prefs.then((SharedPreferences prefs) {
      String? account = prefs.getString(_account);
      if (account == null || account.isEmpty) {
        return null;
      }
      Map<String, dynamic> acc = jsonDecode(account);
      print("account info is - ${acc.toString()}");
      return Account.fromJson(acc);
    });
  }

  Future<void> removeSession() async {
    _prefs.then((SharedPreferences prefs) {
      prefs.remove(_account);
    });
  }
}
