import 'package:flutter/material.dart';
import 'package:project/screens/leave_request.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/register_class.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/student_home.dart';
import 'package:project/screens/class_information.dart';
import 'package:project/screens/class_list.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
      initialRoute: '/', // Màn hình khởi đầu
      routes: {
        '/studenthome': (context) => StudentHome(),
        '/profile': (context) => ProfileScreen(),
        '/signin': (context)=> SignInScreen(),
        '/signup': (context)=> SignUpScreen(),
        '/classinformation': (context)=> ClassInformation(),
        '/classlist': (context)=> ClassList()
      },
      home: LeaveRequestScreen(),
    );
  }
}

