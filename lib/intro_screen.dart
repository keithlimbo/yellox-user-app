import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellox_driver_app/screens/homepage.dart';
import 'package:yellox_driver_app/screens/login.dart';

import 'providers/user_profile_provider.dart';
import 'providers/user_provider.dart';
import 'services/shared_preference.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  getUserProfile() async {
    var _userFromCache = await Provider.of<UserProvider>(context, listen: false)
        .getUserFromCacheD();
    var _userFromCacheDPwd = await UserPreferences().getUserPwd();
    var _userFromCacheDAd = UserPreferences().getUserAdmin();
    var _userFromCacheDPwdAd = UserPreferences().getUserPwdAdmin();
    _userFromCacheDPwdAd.then((value) {
      _userFromCacheDAd.then((val) {
        var _userProfile = Provider.of<UserProfileProvider>(context,
                listen: false)
            .getUserProfiles(value.passwordAd!, val.uid!, _userFromCache.uid!);
        return _userProfile;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserProfile();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 214, 28, 1),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "YELLOX intro screen",
                  style: TextStyle(
                      fontSize: 48, color: Color.fromRGBO(40, 40, 38, 1)),
                ),
              ),
              FittedBox(
                fit: BoxFit.none,
                child: Text(
                  "Express Delivery",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(60, 60, 60, 1)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
