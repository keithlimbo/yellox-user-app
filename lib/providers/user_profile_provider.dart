import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import '../models/user.dart';
// import '../util/app_url.dart';
// import '../util/shared_preference.dart';
// import '../util/constants.dart' as Constants;
import 'package:http/http.dart' as Http;
import 'package:xml_rpc/client.dart' as xml_rpc;

import '../models/user_model.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import 'db_providers.dart';

class UserProfileProvider with ChangeNotifier {
  List<UserProfile> _userProfile = [];
  List<UserProfile> get getUserProfile => _userProfile;

  List<UserProfile> _userMobileNumber = [];
  List<UserProfile> get getUpdatedMobileNumber => _userMobileNumber;

  void setUserProfile(List<UserProfile> userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  void setUpdatedMobileNumber(List<UserProfile> userMobileNumber) {
    _userMobileNumber = userMobileNumber;
    notifyListeners();
  }

  Future<List<UserProfile>> getUserProfiles(
      String password, int userIdAd, int userID) async {
    List<UserProfile> userProfile = [];
    final url = Uri.parse(ApiService.objects);
    try {
      var result = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userIdAd,
          password,
          'res.users',
          'search_read',
          [
            [
              ['id', '=', userID]
            ]
          ],
          {
            'fields': [
              'name',
              'email',
              'vat',
              'company_name',
              'phone',
              'mobile',
              'street',
              'street2',
              'city',
              'country_id',
              'state_id',
              'message_attachment_count',
              'email_verified',
              'smile_user_id',
              'smile_user_record',
              'mobile_verified',
              'account_status',
              'employment_status',
              'preferred_payment_dates'
            ]
          }
        ],
      );
      print(result);
      result.forEach((_userProfile) {
        userProfile.add(UserProfile.fromJson(_userProfile));
        DBProvider.db.createUserProfile(UserProfile.fromJson(_userProfile));
      });
      setUserProfile(userProfile);
    } catch (e) {
      print(e);
    }
    return userProfile;
  }

  Future<List<UserProfile>> updateEmailStatus(
      String password, int userID, String phone) async {
    List<UserProfile> userProfile = [];
    final url = Uri.parse(ApiService.objects);
    try {
      var result = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userID,
          password,
          'res.users',
          'write',
          [
            [userID],
            {'account_status': 'verified', 'date_verified': DateTime.now()}
          ],
        ],
      );
      print(result);

      result.forEach((_userProfile) {
        userProfile.add(UserProfile.fromJson(_userProfile));
      });

      setUpdatedMobileNumber(userProfile);
    } catch (e) {
      print(e);
    }
    return userProfile;
  }

  Future<Map<String, dynamic>> updateMobileNumber(
      String password, int userIDAd, int userID, String phone) async {
    final url = Uri.parse(ApiService.objects);
    var result;
    try {
      var res = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userIDAd,
          password,
          'res.users',
          'write',
          [
            [userID],
            {'mobile': phone}
          ],
        ],
      );
      if (res == true) {
        result = {'status': res, 'message': 'Successful'};
      } else {
        result = {'status': res, 'message': 'Error'};
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  sendEmailVerification(String email, String password, String sessionID) async {
    var result;

    var params = {
      "jsonrpc": ApiService.jsonRPCversion,
      "id": null,
      "params": {"email": email}
    };

    Response res = await post(
      Uri.parse(ApiService.sendVerifyEmail),
      body: json.encode(params),
      headers: {
        'X-Openerp-Session-Id': sessionID,
        'Content-Type': 'application/json'
      },
    );
  }

  Future<Map<String, dynamic>> sendEmailVerificationCode(
      String email, String password, String sessionID, String code) async {
    var result;

    var params = {
      "jsonrpc": ApiService.jsonRPCversion,
      "id": null,
      "params": {"code": "$code"}
    };

    Response res = await post(
      Uri.parse(ApiService.sendVerifyEmailCode),
      body: json.encode(params),
      headers: {
        'X-Openerp-Session-Id': sessionID,
        'Content-Type': 'application/json'
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(res.body);
      if (responseData.containsKey('result')) {
        var userData = responseData['result'];
        result = {'status': true, 'message': 'Successful', 'user': userData};
      } else if (responseData.containsKey('error')) {
        result = {
          'status': false,
          'message': responseData['error']['data']['message']
        };
      }
    } else {
      result = {'status': false, 'message': json.decode(res.body)['error']};
    }
    return result;
  }

  Future<Map<String, dynamic>> sendSMSVerification(
      String email, int userID, String password, String sessionID) async {
    var result;
    var params = {
      "jsonrpc": ApiService.jsonRPCversion,
      "method": ApiService.methodCall,
      "params": {"user_id": userID}
    };
    Response res = await post(
      Uri.parse(ApiService.sendVerifySMS + userID.toString()),
      body: json.encode(params),
      headers: {
        'X-Openerp-Session-Id': sessionID,
        'Content-Type': 'application/json'
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(res.body);
      if (responseData.containsKey('result')) {
        var userData = responseData['result'];
        result = {'status': true, 'message': 'Successful', 'user': userData};
      } else if (responseData.containsKey('error')) {
        result = {
          'status': false,
          'message': responseData['error']['data']['message']
        };
      }
    } else {
      result = {'status': false, 'message': json.decode(res.body)['error']};
    }
    return result;
  }

  Future<Map<String, dynamic>> sendSMSVerificationCode(
      String password,
      int userIDAd,
      String email,
      int userID,
      String sessionID,
      String code) async {
    var result;

    var params = {
      "jsonrpc": ApiService.jsonRPCversion,
      "id": null,
      "params": {"code": "$code"}
    };

    Response res = await post(
      Uri.parse(ApiService.sendVerifySMSCode + userID.toString()),
      body: json.encode(params),
      headers: {
        'X-Openerp-Session-Id': sessionID,
        'Content-Type': 'application/json'
      },
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(res.body);
      if (responseData.containsKey('result')) {
        var userData = responseData['result'];
        result = {'status': true, 'message': 'Successful', 'user': userData};
        updateMobileVerificationCode(password, userIDAd, userID, code);
      } else {
        result = {
          'status': false,
          'message': responseData['error']['data']['message']
        };
      }
    } else {
      result = {'status': false, 'message': json.decode(res.body)['error']};
    }
    return result;
  }

  updateMobileVerificationCode(
      String password, int userIDAd, int userID, String code) async {
    final url = Uri.parse(ApiService.objects);
    var result;
    try {
      var res = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userIDAd,
          password,
          'res.users',
          'write',
          [
            [userID],
            {'mobile_verification_code': code}
          ],
        ],
      );
      if (res == true) {
        result = {'status': res, 'message': 'Successful'};
      } else {
        result = {'status': res, 'message': 'Error'};
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> updateEmploymentStatus(String password,
      int userIDAd, int userID, String employmentStatus) async {
    final url = Uri.parse(ApiService.objects);
    var result;
    try {
      var res = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userIDAd,
          password,
          'res.users',
          'write',
          [
            [userID],
            {'employment_status': employmentStatus}
          ],
        ],
      );
      if (res == true) {
        result = {'status': res, 'message': 'Successful'};
      } else {
        result = {'status': res, 'message': 'Error'};
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<Map<String, dynamic>> createPersonalInfo(
      String password,
      int userIDAd,
      int userID,
      int partnerID,
      String employmentStatus,
      List<String> _image,
      List<String> fileName,
      String address,
      String birthday,
      String gender,
      String companyName,
      String employerContactNo,
      String employerID,
      String totalMonthlyIncome,
      String selectedSalary) async {
    final url = Uri.parse(ApiService.objects);
    var result;

    List<int> resAttachment = [];
    try {
      for (int i = 0; i < _image.length; i++) {
        var res = await xml_rpc.call(
          url,
          'execute_kw',
          [
            ApiService.database,
            userIDAd,
            password,
            'ir.attachment',
            'create',
            [
              {
                'name': fileName[i],
                'datas': _image[i],
                'res_model': 'res.partner',
                'res_id': partnerID
              }
            ],
          ],
        );
        if (res > 0) {
          resAttachment.add(res);
        } else {
          print('Error attachment');
        }
      }

      if (resAttachment.length > 0) {
        String body = '''
                        <b>Employment Status:</b> $employmentStatus <br>
                        <b>Home Address:</b> $address<br>
                        <b>Date of Birth:</b> $birthday<br>
                        <b>Employer's Company Name:</b> $companyName<br>
                        <b>Employer's Contact Number:</b> $employerContactNo<br>
                        <b>Total Monthly Income:</b> $totalMonthlyIncome<br>
                         <b>Salary Date:</b> $selectedSalary<br>
                        ''';

        var msgResult = await xml_rpc.call(
          url,
          'execute_kw',
          [
            ApiService.database,
            userIDAd,
            password,
            'mail.message',
            'create',
            [
              {
                'body': body,
                'message_type': 'comment',
                'model': 'res.partner',
                'attachment_ids': resAttachment,
                'res_id': partnerID,
                'partner_ids': [partnerID]
              }
            ],
          ],
        );

        var partnerResult = await xml_rpc.call(
          url,
          'execute_kw',
          [
            ApiService.database,
            userIDAd,
            password,
            'res.partner',
            'write',
            [
              [partnerID],
              {
                'street': address,
                'country_id': 176,
                'birthday': birthday,
                'gender': gender.toLowerCase(),
                'company_name': companyName,
                'account_status': 'pending',
                'preferred_payment_dates': selectedSalary
              }
            ]
          ],
        );

        result = {'status': partnerResult, 'message': 'Success'};
      } else {
        result = {'status': false, 'message': 'Attachment Error'};
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<Map<String, dynamic>> updatePersonalInfo(
      String password,
      int userIDAd,
      int userID,
      String name,
      String email,
      String mobileNo,
      String companyName,
      String vatNo,
      String salaryDates) async {
    final url = Uri.parse(ApiService.objects);

    bool noData = false;
    var companyToSend;
    var salaryDatesToSend;
    if (companyName == 'No data provided') {
      companyToSend = noData;
    } else {
      companyToSend = companyName;
    }
    if (salaryDates == 'No data available') {
      salaryDatesToSend = noData;
    } else {
      salaryDatesToSend = salaryDates;
    }
    var result;
    try {
      var res = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userIDAd,
          password,
          'res.users',
          'write',
          [
            [userID],
            {
              'name': name,
              'email': email,
              'vat': vatNo,
              'company_name': companyToSend,
              'mobile': mobileNo,
              'preferred_payment_dates': salaryDatesToSend
            }
          ],
        ],
      );
      if (res == true) {
        result = {'status': res, 'message': 'Successful'};
      } else {
        result = {'status': res, 'message': 'Error'};
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<Map<String, dynamic>> updateSmile(
      String password,
      int userIDAd,
      int userID,
      String smileUserId,
      String accountID,
      String sessionID) async {
    final url = Uri.parse(ApiService.objects);
    var result;
    try {
      var res = await xml_rpc.call(
        url,
        'execute_kw',
        [
          ApiService.database,
          userIDAd,
          password,
          'res.users',
          'write',
          [
            [userID],
            {
              'smile_user_id': smileUserId.trim(),
            }
          ],
        ],
      );

      var params = {
        "jsonrpc": ApiService.jsonRPCversion,
        "id": null,
        "params": {}
      };

      Response response = await post(
        Uri.parse(ApiService.sendVerifySmileChangeAccount +
            accountID.toString().trim()),
        body: json.encode(params),
        headers: {
          'X-Openerp-Session-Id': sessionID,
          'Content-Type': 'application/json'
        },
      );

      // print(response.body);

      if (res == true) {
        result = {'status': res, 'message': 'Successful'};
      } else {
        result = {'status': res, 'message': 'Error'};
      }
      //  var resDecode = jsonDecode(response.body);
      // print(response.body);
      // if (response.body.contains('result')) {

      //   result = {
      //     'result': resDecode['result']['message'],
      //     'message': 'Successful'
      //   };
      // } else {
      //   print('No result');

      //   result = {
      //     'result': resDecode['error']['data']['message'],
      //     'message': 'Error'
      //   };
      // }

    } catch (e) {
      print(e);
    }

    return result;
  }

  resetPassword(email, sessionID) async {
    var result;
    try {
      var params = {
        "jsonrpc": ApiService.jsonRPCversion,
        "id": null,
        "params": {"login": email}
      };

      Response res = await post(
        Uri.parse(ApiService.resetPassword),
        body: json.encode(params),
        headers: {
          'X-Openerp-Session-Id': sessionID,
          'Content-Type': 'application/json'
        },
      );

      print(res.body);
      var resDecode = jsonDecode(res.body);
      if (resDecode['result'] != null) {
        result = {
          'result': resDecode['result']['message'],
          'message': 'Successful'
        };
      } else {
        result = {
          'result': resDecode['error']['data']['message'],
          'message': 'Error'
        };
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  additionalDocs(
    String password,
    int userIDAd,
    int userID,
    int partnerID,
    List<String> _image,
    List<String> fileName,
  ) async {
    final url = Uri.parse(ApiService.objects);
    var result;

    List<int> resAttachment = [];
    try {
      for (int i = 0; i < _image.length; i++) {
        var res = await xml_rpc.call(
          url,
          'execute_kw',
          [
            ApiService.database,
            userIDAd,
            password,
            'ir.attachment',
            'create',
            [
              {
                'name': fileName[i],
                'datas': _image[i],
                'res_model': 'res.partner',
                'res_id': partnerID
              }
            ],
          ],
        );
        if (res > 0) {
          resAttachment.add(res);
          result = {'status': res, 'message': 'Successful'};
        } else {
          result = {'status': res, 'message': 'Error'};
        }
      }
    } catch (e) {
      print(e);
    }
    return result;
  }
}
