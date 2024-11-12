import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/student_home.dart';
import 'package:project/screens/student_home.dart';
import 'package:project/screens/create_assigment_screen.dart';
import 'package:project/screens/submit_assigment_screen1.dart';
import 'package:project/screens/submit_assigment_screen2.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>AuthProvider()),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Màn hình khởi đầu
      routes: {
        '/studenthome': (context) => StudentHome(),
        '/profile': (context) => ProfileScreen(),
        '/signin': (context)=> SignInScreen(),
        '/signup': (context)=> SignUpScreen(),
      },
// -----------------------------------------------------------------------------
      home: SignUpScreen(),
      // home: CreateAssignmentScreen(),
      // home: SubmitAssignmentScreen1(),
      // home: SubmitAssignmentScreen2(),
// -----------------------------------------------------------------------------
    ),
  );
}
