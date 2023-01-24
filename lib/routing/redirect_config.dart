import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';

enum RedirectPage { login, home}

Future<RedirectPage> checkSession() async {
  UserPref userPref = UserPref();

  Account? acc = await userPref.getAccount();

  if(acc != null){
    return RedirectPage.home;
  }
  return RedirectPage.login;
}
