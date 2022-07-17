import 'package:chat/UI/Auth/Register.dart';
import 'package:chat/UI/Rooms/Home.dart';
import 'package:chat/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static String Route_Name = 'login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';

  String password = '';

  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/pattern.png'), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          title: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07),
              child: Text('Login')),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
          children: [
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(12),
              child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (String value) {
                        email = value;
                      },
                      validator: (value) {
                        return validateEmail(value!);
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          label: Text(
                            'Email',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    TextFormField(
                      onChanged: (String value) {
                        password = value;
                      },
                      validator: (value) {
                        return validatePassword(value!);
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          label: Text(
                            'Password',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blueAccent,
                              decorationThickness: 3,
                              fontSize: 16),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            loginToFireBase();
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.45),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 30,
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Register.Route_Name);
                            },
                            child: Text(
                              'Create New Account?',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent,
                                  decorationThickness: 3,
                                  fontSize: 16),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    RegExp regex =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty || value
        .trim()
        .isEmpty) {
      return 'Please enter email';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid email';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    RegExp regex =
    RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
    if (value.isEmpty || value
        .trim()
        .isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void loginToFireBase() async{
    if(!key.currentState!.validate()){
      return;
    }
    showLoading(context);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      hideLoading(context);
      Navigator.pushReplacementNamed(context, Home.Route_Name);
    } on FirebaseAuthException catch (e) {
      hideLoading(context);
      if (e.code == 'user-not-found') {
        showError(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showError(context, 'Wrong password provided for that user.');
      }
    }
  }
}
