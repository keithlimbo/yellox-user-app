import 'package:flutter/material.dart';
import 'package:yellox_driver_app/screens/login.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _loginForm = GlobalKey<FormState>();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 214, 28, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600.0) {
            return _tabletSignUpView();
          } else {
            return _phoneSignUpView();
          }
        },
      ),
    );
  }

  Widget _phoneSignUpView() {
    return CustomScrollView(slivers: [
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
                    "Create an Account",
                    textScaleFactor: 2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Please Fill in the Fields Below",
                    textScaleFactor: 1.4,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const SizedBox(height: 30),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Full Name",
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
                    child: TextField(
                      controller: fullName,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                        hintText: "Enter Fullname",
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
                        "Mobile Number",
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
                    child: TextField(
                      controller: mobileNumber,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: Colors.blue),
                        hintText: "Enter your number",
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
                    child: TextFormField(
                      controller: password,
                      obscureText: _isObscure,
                      validator: (value) =>
                          value!.isEmpty ? "Please enter password" : null,
                      decoration: InputDecoration(
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
                            onPressed: () {},
                            child: const Text('Continue',
                                style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                fixedSize: const Size(300, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ));
                                  },
                                  child: const Text("Sign in"))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
    ]);
  }

  Widget _tabletSignUpView() {
    return const Scaffold();
  }
}
