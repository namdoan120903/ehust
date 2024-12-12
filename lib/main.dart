import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/provider/AbsenceProvider.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/provider/ChatProvider.dart';
import 'package:project/provider/ClassProvider.dart';
import 'package:project/provider/FireBaseApi.dart';
import 'package:project/provider/NotificationProvider.dart';
import 'package:project/provider/RollCallProvider.dart';
import 'package:project/provider/SurveyProvider.dart';
import 'package:project/screens/lecturer/lecturer_class.dart';
import 'package:project/screens/lecturer/lecturer_class_edit.dart';
import 'package:project/screens/lecturer/lecturer_class_list.dart';
import 'package:project/screens/lecturer/lecturer_create_class.dart';
import 'package:project/screens/lecturer/lecturer_home.dart';
import 'package:project/screens/lecturer/roll_call.dart';
import 'package:project/screens/notification.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/student/leave_request.dart';
import 'package:project/screens/student/student_class_register.dart';
import 'package:project/screens/student/student_home.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/student/student_survey.dart';
import 'package:project/provider/AbsenceProvider.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/provider/ClassProvider.dart';
import 'package:project/provider/MaterialProvider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FireBaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ClassProvider()),
          ChangeNotifierProvider(create: (_) => SurveyProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => RollCallProvider()),
          ChangeNotifierProvider(create: (_) => MaterialProvider()),
          ChangeNotifierProvider(create: (_) => AbsenceProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          routes: {
            '/student': (context) => StudentHome(),
            '/student/class/register': (context) => StudentClassRegister(),
            '/student/leave_request': (context) => LeaveRequestScreen(),
            '/lecturer': (context) => LecturerHome(),
            '/lecturer/class': (context) => LecturerClass(),
            '/lecturer/class/create': (context) => LecturerCreateClass(),
            '/lecturer/class/edit': (context) => LecturerEditClass(),
            '/student/survey': (context) => StudentSurvey(),
            '/lecturer/class/take_attendance': (context) => RollCallScreen(),
            '/lecturer/class_list': (context) => LecturerClassList(
                  route: "",
                ),
            '/profile': (context) => ProfileScreen(),
            '/signin': (context) => SignInScreen(),
            '/signup': (context) => SignUpScreen(),
            '/notifications': (context) => NotificationsScreen(),
            '/student/survey': (context) => StudentSurvey(),
          },
          home: SignInScreen(),
        ),
      );
}
