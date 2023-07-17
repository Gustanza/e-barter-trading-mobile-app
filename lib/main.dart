import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'oss_stuff/oss_screen.dart';
import 'nyumbani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Usahili(),
      ));
    } else {
      runApp(MaterialApp(
          debugShowCheckedModeBanner: false, home: ControllerWaFeed()));
    }
  });
}
