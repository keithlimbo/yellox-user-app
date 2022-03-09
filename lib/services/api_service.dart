import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiService {
  static String url(int nrResults) {
    return 'http://api.randomuser.me/?results=$nrResults';
  }

  static Future<List<User>> getUsers({int nrUsers = 1}) async {
    try {
      var response = await http.get(Uri.parse(nrUsers.toString()),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        Iterable list = data["results"];
        List<User> users = list.map((l) => User.fromJson(l)).toList();
        return users;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // static const String liveBaseURL = "https://dev.moveforward.ph/web/";
  static const String liveBaseURL =
      "https://moveforward.ph/web/"; // To change when switching to production
  // static const String environment = 'development';
  static const String environment =
      'production'; // To change when switching to production
  // static const String localBaseURL = "http://10.0.2.2:4000/api/v1";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "session/authenticate?";
  static const String register = baseURL + "/registration";
  static const String forgotPassword = baseURL + "/forgot-password";
  static const String registerWeb = baseURL + "/signup";
  static const String methodCall = "call";
  static const String sendVerifyEmail = baseURL + "account/verify-email/send";
  static const String sendVerifyEmailCode =
      baseURL + "account/verify-email/verify";
  static const String sendVerifySMS =
      baseURL + "account/verify/send_verification_code/";
  static const String sendVerifySMSCode =
      baseURL + "account/verify/verify_verification_code/";
  static const String sendVerifySmileChangeAccount =
      baseURL + "account/verify/smile_change_account/";
  static const String getSmileTokenMFI =
      baseURL + "account/verify/smile_fetch_token/";
  static const String resetPassword = baseURL + "account/reset-password";

// Affiliate Accounts
  static const String smileURL = "https://sandbox.smileapi.io/v1/";
  static const String smileUsername = "sak-c25d6eb4fb85474d9ded2ee99d045c29";
  static const String smilePassword = "rJvHi0U#eigf\$sF1O6";
  static const String smileEncrypted = "c2FrLWMyNWQ2ZWI0ZmI4NTQ3NGQ5ZGVkMmVlOTlkMDQ1YzI5OnJKdkhpMFUjZWlnZiRzRjFPNg==";
  static const String smileTokenURL = "https://link-sandbox.smileapi.io/v1";

  // static const String smileURL =
  //     "https://open.smileapi.io/v1/"; // To change when switching to production
  // static const String smileUsername =
  //     "pak-d2f8f4339a7544b9a414aa8a7d1b5e56 "; // To change when switching to production
  // static const String smilePassword =
  //     "oniV9@!Fd0EzePXDUj"; // To change when switching to production
  // static const String smileEncrypted =
  //     "cGFrLWQyZjhmNDMzOWE3NTQ0YjlhNDE0YWE4YTdkMWI1ZTU2Om9uaVY5QCFGZDBFemVQWERVag=="; // To change when switching to production
  // static const String smileTokenURL =
  //     "https://link.smileapi.io/v1"; // To change when switching to production

  // static const String liveBaseURL2 = "https://dev.moveforward.ph/";
  static const String liveBaseURL2 =
      "https://moveforward.ph/"; // To change when switching to production
  static const String baseURL2 = liveBaseURL2;
  static const String login2 = baseURL2 + "xmlrpc/2/common";
  static const String objects = baseURL2 + "xmlrpc/2/object";

  static const String addToCart = liveBaseURL2 + "shop/cart/update?product_id=";
  static const String deleteCart = liveBaseURL2 + "shop/cart/update_json";
  static const String noImage =
      "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";
  static const String imageWebUrl = liveBaseURL + 'image/product.product/';
  static const String imageWebReso = '/image_128';

  static const String jsonRPCversion = "2.0";
  // static const String database = "mf_2021-07-22";
  static const String database =
      "moveforward"; // To change when switching to production

// Dragonpay
  static const String merchantID = 'SAMPLEGEN';
  static const String ccy = 'PHP';
  static const String description = 'MoveForward Inc';

  static const String fbPageID = '100919782119229';
}
