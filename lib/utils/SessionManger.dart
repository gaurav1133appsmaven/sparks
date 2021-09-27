import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String userid = "user id";
  final String userEmail = "userEmail";

  String loginStatus = "loggedinStatus";

  Future<void> setUserid(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userid, userId);
  }

  Future<String> getUserid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString(this.userid) ?? null;
  }

  Future<void> setUserEmail(String userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userEmail, userEmail);
  }

  Future<String> getUserEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString(this.userEmail) ?? null;
  }

  Future<void> setUserLoginStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.loginStatus, status);
  }

  Future<bool> getUserLoginStatus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getBool(this.loginStatus) ?? null;
  }
}
