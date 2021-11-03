import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/login_screen.dart';
import './screens/navigation_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendster',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        backgroundColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.indigo,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
        if (userSnapshot.hasData) {
          return NavigationScreen();
        }
        return LoginScreen();
      },),
    );
  }
}

