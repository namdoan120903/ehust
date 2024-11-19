import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/provider/ClassProvider.dart';
import 'package:project/provider/NotificationProvider.dart';
import 'package:project/provider/RollCallProvider.dart';
import 'package:project/provider/SurveyProvider.dart';
import 'package:project/screens/lecturer/lecturer_class.dart';
import 'package:project/screens/lecturer/lecturer_class_edit.dart';
import 'package:project/screens/lecturer/lecturer_class_list.dart';
import 'package:project/screens/lecturer/lecturer_create_class.dart';
import 'package:project/screens/lecturer/lecturer_home.dart';
import 'package:project/screens/lecturer/send_notification.dart';
import 'package:project/screens/notification.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/student/leave_request.dart';
import 'package:project/screens/student/student_class_register.dart';
import 'package:project/screens/student/student_home.dart';
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
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ClassProvider()),
          ChangeNotifierProvider(create: (_) => SurveyProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => RollCallProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/', // Màn hình khởi đầu
          routes: {
            '/student': (context) => StudentHome(),
            '/student/class/register': (context) => StudentClassRegister(),
            '/student/leave_request': (context) => LeaveRequestScreen(),
            '/lecturer': (context) => LecturerHome(),
            'lecturer/send_notification': (context) =>
                SendNotificationScreen(userName: "Nguyen Tan"),
            '/lecturer/class': (context) => LecturerClass(),
            '/lecturer/class/create': (context) => LecturerCreateClass(),
            '/lecturer/class/edit': (context) => LecturerEditClass(),
            '/lecturer/class_list': (context) => LecturerClassList(
                  route: "",
                ),
            '/profile': (context) => ProfileScreen(),
            '/signin': (context) => SignInScreen(),
            '/signup': (context) => SignUpScreen(),
            '/notifications': (context) => NotificationsScreen(),
          },
          home: SignInScreen(),
        ),
      );
}
