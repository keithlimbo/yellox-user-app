import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../models/user_model.dart';
import '../models/user_model_admin.dart';

class UserPreferences {
  Future<bool> saveUser(UserData user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.uid!);
    prefs.setString("name", user.name!);
    // prefs.setBool("isSystem", user.isSystem!);
    // prefs.setBool("isAdmin", user.isAdmin!);
    prefs.setString("db", user.db!);
    prefs.setString("username", user.username!);
    prefs.setString("partnerDisplayName", user.partnerDisplayName!);
    prefs.setInt("companyId", user.companyId!);
    prefs.setInt("partnerId", user.partnerId!);

    return prefs.commit(); // To remove
  }

  Future<bool> savePwd(UserPwd userPwd) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("password", userPwd.password!);

    return prefs.commit(); // To remove
  }

  Future<bool> saveSession(UserSession userSession) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("sessionID", userSession.sessionID!);

    return prefs.commit(); // To remove
  }

  Future<bool> saveUserAdmin(UserAdmin userAdmin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userIdAd", userAdmin.uid!);
    prefs.setString("nameAd", userAdmin.name!);
    prefs.setString("usernameAd", userAdmin.username!);
    prefs.setString("partnerDisplayNameAd", userAdmin.partnerDisplayName!);
    prefs.setInt("companyIdAd", userAdmin.companyId!);
    prefs.setInt("partnerIdAd", userAdmin.partnerId!);

    return prefs.commit(); // To remove
  }

  Future<bool> savePwdAd(UserPwdAdmin userPwdAdmin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("passwordAd", userPwdAdmin.passwordAd!);

    return prefs.commit(); // To remove
  }

  Future<UserData> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("userId");
    String? name = prefs.getString("name");
    // bool? isSystem = prefs.getBool("isSystem");
    // bool? isAdmin = prefs.getBool("isAdmin");
    String? db = prefs.getString("db");
    String? username = prefs.getString("username");
    String? partnerDisplayName = prefs.getString("partnerDisplayName");
    int? companyId = prefs.getInt("companyId");
    int? partnerId = prefs.getInt("partnerId");

    return UserData(
        uid: userId,
        name: name,
        // isSystem: isSystem,
        // isAdmin: isAdmin,
        db: db,
        username: username,
        partnerDisplayName: partnerDisplayName,
        companyId: companyId,
        partnerId: partnerId);
  }

  Future<UserPwd> getUserPwd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? password = prefs.getString("password");

    return UserPwd(password: password);
  }

  Future<UserSession> getUserSessionID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sessionID = prefs.getString("sessionID");

    return UserSession(sessionID: sessionID);
  }

  Future<UserAdmin> getUserAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("userIdAd");
    String? name = prefs.getString("nameAd");
    String? username = prefs.getString("usernameAd");
    String? partnerDisplayName = prefs.getString("partnerDisplayNameAd");
    int? companyId = prefs.getInt("companyIdAd");
    int? partnerId = prefs.getInt("partnerIdAd");

    return UserAdmin(
        uid: userId,
        name: name,
        username: username,
        partnerDisplayName: partnerDisplayName,
        companyId: companyId,
        partnerId: partnerId);
  }

  Future<UserPwdAdmin> getUserPwdAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? passwordAd = prefs.getString("passwordAd");

    return UserPwdAdmin(passwordAd: passwordAd);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userId");
    prefs.remove("name");
    prefs.remove("isSystem");
    prefs.remove("isAdmin");
    prefs.remove("db");
    prefs.remove("username");
    prefs.remove("partnerDisplayName");
    prefs.remove("companyId");
    prefs.remove("partnerId");
    prefs.remove("password");

    prefs.remove("sessionID");

    prefs.remove("userIdAd");
    prefs.remove("nameAd");
    prefs.remove("usernameAd");
    prefs.remove("partnerDisplayNameAd");
    prefs.remove("companyIdAd");
    prefs.remove("partnerIdAd");
    prefs.remove("passwordAd");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    return token;
  }
}
