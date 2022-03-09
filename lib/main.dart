import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellox_driver_app/intro_screen.dart';
import 'package:yellox_driver_app/providers/auth.dart';
import 'package:yellox_driver_app/splashcreen.dart';

import 'models/user_model.dart';
import 'providers/user_profile_provider.dart';
import 'providers/user_provider.dart';
import 'screens/homepage.dart';
import 'services/shared_preference.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<UserData>? getUserData() => UserPreferences().getUser();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Move Forward',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     brightness: Brightness.light,
    //     canvasColor: Colors.transparent,
    //     primarySwatch: Colors.blue,
    //     fontFamily: "Poppins",
    //     scaffoldBackgroundColor: const Color(0xFFFFFFFF)
    //   ),
    //   home: SplashScreen(),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => ProductsProvider()),
        // ChangeNotifierProvider(create: (_) => CartProvider()),
        // ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        // ChangeNotifierProvider(create: (_) => OrderProvider()),
        // ChangeNotifierProvider(create: (_) => BrandsProvider()),
        // ChangeNotifierProvider(create: (_) => LoansProvider()),
      ],
      child: MaterialApp(
        title: 'Move Forward',
        theme: ThemeData(
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          primarySwatch: Colors.blue,
          fontFamily: "Poppins",
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        ),
        // navigatorKey: navigatorKey,
        home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SplashScreen(); // still loading
              UserData? userData = snapshot.data as UserData;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (userData.uid == null)
                    return SplashScreen();
                  else
                    // UserPreferences().removeUser();
                    // return MainPage();
                    return IntroScreen();
              }
            }),
        // routes: {
        // '/dashboard': (context) => DashBoard(),
        // '/login': (context) => Login(),
        // '/register': (context) => Register(),
        // '/splash-screen': (context) => SplashScreen(),
        // '/main-page-education': (context) => MainPageEducation(),
        // }
      ),
    );
  }
}
