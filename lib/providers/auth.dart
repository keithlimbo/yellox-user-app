import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
// import '../util/app_url.dart';
// import '../util/shared_preference.dart';
// import '../util/constants.dart' as Constants;
import 'package:http/http.dart' as Http;
import 'package:xml_rpc/client.dart' as xml_rpc;

import '../models/user.dart';
import '../models/user_model.dart';
import '../models/user_model_admin.dart';
import '../services/api_service.dart';
import '../services/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  List<int>? _isUserExist;
  List<int> get getProductQty => _isUserExist!;

  List<UserData> _registerUser = [];
  List<UserData> get getRegister => _registerUser;

  void setRegister(List<UserData> regUser) {
    _registerUser = regUser;
    notifyListeners();
  }

  void setValidUser(List<int> validateUser) {
    _isUserExist = validateUser;
    notifyListeners();
  }

  // User userData;
  Future<Map<String, dynamic>> login(String email, String password) async {
    print(email);
    print(password);
    var result;

    var sessionID = "";
    var session = "";

    // final Map<String, dynamic> loginData = {
    //   'user': {'db': "moveforward", 'login': email, 'password': password}
    // };

    var loginData = {
      "jsonrpc": ApiService.jsonRPCversion,
      "params": {
        "db": ApiService.database,
        "login": email,
        "password": password
      }
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(ApiService.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      UserAdmin userAdmin;
      if (ApiService.environment != 'production') {
        userAdmin = UserAdmin(
            uid: 170,
            name: "MilkyAdmin",
            username: "milkyadmin",
            partnerDisplayName: "MoveForward Inc., MilkyAdmin",
            companyId: 1,
            partnerId: 254);
      } else {
        userAdmin = UserAdmin(
            uid: 58,
            name: "API-User",
            username: "apiuser@buynowpaylater.asia",
            partnerDisplayName: "MoveForward Inc., API-User",
            companyId: 1,
            partnerId: 166);
      }

      String jsonEncodeUserAdmin = jsonEncode(userAdmin);

      if (responseData.containsKey('result')) {
        var userData = responseData['result'];
        var resBody = {};
        resBody["password"] = password;
        var pass = json.encode(resBody);

        var resBodyAd = {};

        if (ApiService.environment != 'production') {
          resBodyAd["passwordAd"] = "Admin1234!";
        } else {
          resBodyAd["passwordAd"] = "&c4c9QZ&6plr";
        }

        var passAd = json.encode(resBodyAd);

        // Get Session  ID
        var elem = '';
        for (var element in response.headers.values) {
          if (element.contains('session_id')) {
            session = element.split(";")[0];
            sessionID = session.split("=")[1];

            elem = element;
          }
        }

        var resHeader = {};
        resHeader["sessionID"] = sessionID;
        var sessionId = json.encode(resHeader);
        print(sessionId);
        UserData authUser = UserData.fromJson(userData);
        UserPwd userPwd = UserPwd.fromJson(jsonDecode(pass));
        UserSession userSessionID = UserSession.fromJson(jsonDecode(sessionId));

        UserAdmin userAdmin =
            UserAdmin.fromJson(jsonDecode(jsonEncodeUserAdmin));
        UserPwdAdmin userPwdAdmin = UserPwdAdmin.fromJson(jsonDecode(passAd));

        UserPreferences().saveUser(authUser);
        UserPreferences().savePwd(userPwd);
        UserPreferences().saveSession(userSessionID);

        UserPreferences().saveUserAdmin(userAdmin);
        UserPreferences().savePwdAd(userPwdAdmin);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'status': false,
          'message': responseData['error']['data']['message']
        };
      }
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<int> register(String email, String phone, String password,
      String passwordConfirmation, String name) async {
    Future<int>? registerUser;
    final url = Uri.parse(ApiService.objects);
    String passwordAd;
    int uidAd;
    if (ApiService.environment != 'production') {
      passwordAd = 'Admin1234!';
      uidAd = 170;
    } else {
      passwordAd = '&c4c9QZ&6plr';
      uidAd = 58;
    }

    try {
      var result = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          uidAd,
          passwordAd,
          'res.users',
          'create',
          [
            {
              'name': name,
              'login': email,
              'mobile': phone,
              'password': password,
              'email': email,
              'country_id': 176, // Philippines
              'sel_groups_1_8_9': 8
            }
          ],
        ],
      );

      registerUser = Future.value(result);

      // if (result > 0) {
      //   getNewUser(email, password, passwordConfirmation, result);
      // }
    } catch (e) {
      throw Exception(e);
    }
    return registerUser;
  }

  Future<List<UserData>> getNewUser(String email, String password,
      String passwordConfirmation, int userID) async {
    List<UserData> registerUser = [];
    final url = Uri.parse(ApiService.objects);

    String passwordAd;
    int uidAd;
    if (ApiService.environment != 'production') {
      passwordAd = 'Admin1234!';
      uidAd = 170;
    } else {
      passwordAd = '&c4c9QZ&6plr';
      uidAd = 58;
    }
    try {
      var result = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          uidAd,
          passwordAd,
          'res.users',
          'search_read',
          [
            [
              ['id', '=', userID]
            ]
          ],
          // {}
        ],
      );

      if (result.length > 0) {
        login(email, password);
      }

      // setRegister(registerUser);
    } catch (e) {
      throw Exception(e);
    }
    return registerUser;
  }

  //   Future<void> cacheUserSignInData(User user) async {
  //   await SharedPreferences.getInstance().then((prefs) {
  //     prefs.setString('CACHE_USER_DATA', jsonEncode(user.toCacheData()));
  //   });
  // }

  Future<List<int>> validateUser(String email, String password,
      String passwordConfirmation, String name) async {
    List<int> isUserExist = [];
    final url = Uri.parse(ApiService.objects);
    print(email);
    print(password);
    print(passwordConfirmation);
    print(name);

    String passwordAd;
    int uidAd;
    if (ApiService.environment != 'production') {
      passwordAd = 'Admin1234!';
      uidAd = 170;
    } else {
      passwordAd = '&c4c9QZ&6plr';
      uidAd = 58;
    }
    try {
      var result = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          uidAd,
          passwordAd,
          'res.users',
          'search',
          [
            [
              ['login', '=', email]
            ]
          ],
          // {}
        ],
      );
      // print(result);

      result.forEach((_user) {
        isUserExist.add(_user);
      });

      setValidUser(isUserExist);
    } catch (e) {
      print(e);
    }
    return isUserExist;
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      // UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  Future<void> signOut() async {
    _loggedInStatus = Status.LoggedOut;
    print(_loggedInStatus);
    UserPreferences().removeUser();
    // await googleSignIn.signOut();
    notifyListeners();
  }
}
