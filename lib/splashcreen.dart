import 'package:flutter/material.dart';
import 'package:yellox_driver_app/screens/login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => LoginPage(),
    //       ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(""),
        )
        // SafeArea(child: child)
      ],
    )
        // Center(
        //   child: IntrinsicWidth(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         FittedBox(
        //           fit: BoxFit.fitWidth,
        //           child: Text(
        //             "YELLOX",
        //             style: TextStyle(
        //                 fontSize: 48, color: Color.fromRGBO(40, 40, 38, 1)),
        //           ),
        //         ),
        //         FittedBox(
        //           fit: BoxFit.none,
        //           child: Text(
        //             "Express Delivery",
        //             style: TextStyle(
        //                 fontSize: 18, color: Color.fromRGBO(60, 60, 60, 1)),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
