import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/screens/lecturer_class.dart';
import 'package:project/screens/lecturer_class_edit.dart';
import 'package:project/screens/lecturer_create_class.dart';
import 'package:project/screens/lecturer_home.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/student_home.dart';
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
        '/student': (context) => StudentHome(),
        '/lecturer': (context) => LecturerHome(),
        '/lecturer/class': (context)=> LecturerClass(),
        '/lecturer/class/create': (context)=> LecturerCreateClass(),
        '/lecturer/class/edit': (context)=> LecturerEditClass(),
        '/profile': (context) => ProfileScreen(),
        '/signin': (context)=> SignInScreen(),
        '/signup': (context)=> SignUpScreen(),
      },
      home: SignInScreen(),
    ),
  );
}
