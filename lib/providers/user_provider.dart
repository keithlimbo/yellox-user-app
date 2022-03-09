import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/user_model.dart';
import '../services/shared_preference.dart';

class UserProvider with ChangeNotifier {
  UserData _user = new UserData();
  UserData _userFromCache = new UserData();
  UserPwd _userFromCacheDPwd = new UserPwd();

  UserData get getUser => _user;

  UserData get getUserFromCache => _userFromCache;

  UserPwd get getUserFromCacheDPwd => _userFromCacheDPwd;

  void setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  void setUserFromCache(UserData user) {
    _userFromCache = user;
    notifyListeners();
  }

  void setUserFromCacheDPwd(UserPwd userPwd) {
    _userFromCacheDPwd = userPwd;
    notifyListeners();
  }

   Future<UserData> getUserFromCacheD() async {
    var userFromCache;
    await UserPreferences().getUser().then((value) async {
      userFromCache = value;
    setUserFromCache(userFromCache);
    });
    return userFromCache;
  }

   Future<UserPwd> getUserPwd() async {
    var userFromCachePwd;
    await UserPreferences().getUserPwd().then((value) async {
      userFromCachePwd = value;
    setUserFromCacheDPwd(userFromCachePwd);
    });
    return userFromCachePwd;
  }
}
