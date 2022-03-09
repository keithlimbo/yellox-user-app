// import 'dart:html';
// import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellox_driver_app/screens/homepage.dart';
import 'package:yellox_driver_app/screens/signup.dart';

import '../providers/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String? _username, _password;

  Map _source = {ConnectivityResult.none: false};

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 214, 28, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600.0) {
            return _tabletLoginView();
          } else {
            return _phoneLoginView();
          }
        },
      ),
    );
  }

  Widget _phoneLoginView() {
    final AuthProvider authService = Provider.of<AuthProvider>(context);
    var doLogin = () {
      final form = _loginForm.currentState;
      // if (_source.keys.toList()[0] == ConnectivityResult.none) {
      // showAlertDialog(context);
      // print('test');
      // } else {
      if (form!.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            authService.login(_username!, _password!);

        successfulMessage.then((response) {
          if (response['status']) {
            // User user = response['user'];
            // Provider.of<UserProvider>(context, listen: false).setUser(user);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Login Successful"),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ),
            ));
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (_) => ShopHomeScreen()));
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const HomePage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response['message'].toString()),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ),
            ));
          }
        });
      } else {
        print("form is invalid");
      }
      // }
    };
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Form(
            key: _loginForm,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    "Welcome!",
                    textScaleFactor: 2.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Sign up with your phone\nnumber",
                    textScaleFactor: 1.4,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const SizedBox(height: 30),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 10),
                  Container(
                    // width: 300,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 4, 2, 4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    // child: TextField(
                    //   controller: mobileNumber,
                    //   decoration: const InputDecoration(
                    //     prefixIcon: Icon(Icons.phone, color: Colors.blue),
                    //     hintText: "Enter your number",
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //     border: InputBorder.none,
                    //     fillColor: Colors.blueGrey,
                    //   ),
                    // ),
                    child: TextFormField(
                      controller: email,
                      style: TextStyle(fontSize: 16.0),
                      // validator: validateEmail,
                      onSaved: (value) => _username = value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: Colors.blue),
                        hintText: "Enter your email",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        fillColor: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 10),
                  Container(
                    // width: 300,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 4, 2, 4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    // child: TextFormField(
                    //   controller: password,
                    //   obscureText: _isObscure,
                    //   validator: (value) =>
                    //       value!.isEmpty ? "Please enter password" : null,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         _isObscure
                    //             ? Icons.visibility
                    //             : Icons.visibility_off,
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           _isObscure = !_isObscure;
                    //         });
                    //       },
                    //     ),
                    //     hintText: "Enter your password",
                    //     hintStyle: const TextStyle(color: Colors.grey),
                    //     border: InputBorder.none,
                    //     fillColor: Colors.blueGrey,
                    //   ),
                    // ),
                    child: TextFormField(
                      controller: password,
                      style: TextStyle(fontSize: 16.0),
                      validator: (value) =>
                          value!.isEmpty ? "Please enter password" : null,
                      onSaved: (value) => _password = value,
                      decoration: InputDecoration(
                        labelText: 'PASSWORD',
                        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        hintText: "Enter your password",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        fillColor: Colors.blueGrey,
                      ),
                      obscureText: true,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 50),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              maxHeight: kToolbarHeight, maxWidth: 200),
                          margin: const EdgeInsets.only(top: 5, bottom: 10),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              doLogin();
                            },
                            child: const Text('Sign in',
                                style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                fixedSize: const Size(300, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "New on our platform?",
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ));
                                },
                                child: const Text("Create an account"))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Expanded(
                                child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            )),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Or",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            )),
                          ],
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.facebook,
                                    color: Colors.blue),
                                label: const Text(
                                  "Facebook",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    minimumSize: const Size(140, 45),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.open_in_browser_outlined,
                                    color: Colors.green),
                                label: const Text(
                                  "Google",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    minimumSize: const Size(140, 45),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _tabletLoginView() {
    return const Text("Tablet View");
  }
}
