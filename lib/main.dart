import 'package:chat/UI/Auth/Login.dart';
import 'package:chat/UI/Auth/Register.dart';
import 'package:chat/UI/Rooms/Home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        Login.Route_Name: (_)=> Login(),
        Register.Route_Name: (_)=> Register(),
        Home.Route_Name:(_)=> Home()
      },
      initialRoute: Login.Route_Name,
    );
  }
}