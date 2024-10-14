import 'package:flutter/material.dart';
import 'package:project/screens/register_class.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/leave_request.dart';
import 'package:project/screens/notification.dart';
import 'package:project/screens/roll_call.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: RollCallScreen(),
    );
  }
}
