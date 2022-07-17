import 'package:chat/Models/MyUser.dart';
import 'package:chat/UI/Auth/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat/utils.dart';

import 'package:flutter/material.dart';

class Register extends StatefulWidget {
   Register({Key? key}) : super(key: key);

  static String Route_Name = 'Register';

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = '';

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
          toolbarHeight: MediaQuery
              .of(context)
              .size
              .height * 0.1,
          title: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07),
              child: Text('Create  Account')),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding:
          EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.25),
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
                      'Welcome To Chat!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        return validateName(value!);
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Your Name',
                          label: Text(
                            'Name',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        return validateEmail(value!);
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          label: Text(
                            'Email',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        return validatePassword(value!);
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          label: Text(
                            'Password',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            registerToFireBase();
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.03,
                              ),
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.25),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 30,
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, Login.Route_Name);
                            },
                            child: Text(
                              'Already Have Account?',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent,
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

  String? validateName(String value) {
    if (value.isEmpty || value
        .trim()
        .isEmpty) {
      return 'Please enter your name';
    } else {
      return null;
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

  void registerToFireBase() async {
    if (!key.currentState!.validate()) {
      return;
    }
    showLoading(context);
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
        //add()
      );
      //todo: add user to firebase auth
      MyUser.withConverter().doc(userCredential.user!.uid)
          .set(MyUser(id: userCredential.user!.uid, name: name, email: email));
      hideLoading(context);
      Navigator.pushNamed(context, Login.Route_Name);
    } on FirebaseAuthException catch (e) {
      hideLoading(context);
      if (e.code == 'email-already-in-use') {
        showError(context, 'The email already used for another account.');
      }
    }
  }
}