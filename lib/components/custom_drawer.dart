import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellox_driver_app/helpers/style.dart';
import 'package:yellox_driver_app/screens/homepage.dart';
import 'package:yellox_driver_app/screens/mywallet/mywallet.dart';

import '../providers/auth.dart';
import '../providers/user_provider.dart';
import '../screens/login.dart';

String _currentRoute = "/";

void doRoute(BuildContext context, String name, MaterialPageRoute route) {
  if (_currentRoute != name) {
    Navigator.of(context).pushReplacement(route);
  } else {
    Navigator.pop(context);
  }
  _currentRoute = name;
}

String? name;

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authService = Provider.of<AuthProvider>(context);
    return Consumer<UserProvider>(builder: (context, _user, child) {
      name = _user.getUserFromCache.name ?? '';
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: primaryYellow),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          children: [
                            const CircleAvatar(
                                radius: 24,
                                backgroundColor: white,
                                child: Icon(Icons.person)),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: black),
                                ),
                                Text(
                                  "Basic Level",
                                  style: TextStyle(color: grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 30,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.access_time_outlined,
                                size: 24,
                                color: grey,
                              ),
                              Text(
                                "10.5",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Hours online",
                                style: TextStyle(fontSize: 10, color: grey),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.speed_outlined,
                                size: 24,
                                color: grey,
                              ),
                              Text(
                                "30KM",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Total Distance",
                                style: TextStyle(fontSize: 10, color: grey),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.view_list_outlined,
                                size: 24,
                                color: grey,
                              ),
                              Text(
                                "20",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Total Jobs",
                                style: TextStyle(fontSize: 10, color: grey),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.home, size: 32),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: drawerTitleFontSize),
                ),
                onTap: () {
                  doRoute(
                      context,
                      "/",
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                leading:
                    const Icon(Icons.account_balance_wallet_outlined, size: 32),
                title: Text(
                  "My Wallet",
                  style: TextStyle(fontSize: drawerTitleFontSize),
                ),
                onTap: () {
                  doRoute(
                      context,
                      "/mywallet/",
                      MaterialPageRoute(
                          builder: (context) => const MyWallet()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.history, size: 32),
                title: Text(
                  "History",
                  style: TextStyle(fontSize: drawerTitleFontSize),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                leading:
                    const Icon(Icons.notifications_active_outlined, size: 32),
                title: Text(
                  "Notifications",
                  style: TextStyle(fontSize: drawerTitleFontSize),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.settings, size: 32),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: drawerTitleFontSize),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: drawerTitleFontSize),
                ),
                dense: true,
                leading: const Icon(Icons.logout, size: 32),
                trailing: Icon(Icons.chevron_right, color: Colors.yellow[50]),
                onTap: () {
                  authService.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Logout Successfully"),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Close',
                      onPressed: () {},
                    ),
                  ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
