import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/provider/AuthProvider.dart';
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
import 'package:project/screens/lecturer/send_notification.dart';
import 'package:project/screens/notification.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/sign_in_screen.dart';
import 'package:project/screens/sign_up_screen.dart';
import 'package:project/screens/student/leave_request.dart';
import 'package:project/screens/student/student_class_register.dart';
import 'package:project/screens/student/student_home.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      if (message.notification != null) {
        print('Notification Body: ${message.notification!.body}');
      }
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
    });
  }

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
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          routes: {
            '/student': (context) => StudentHome(),
            '/student/class/register': (context) => StudentClassRegister(),
            '/student/leave_request': (context) => LeaveRequestScreen(),
            '/lecturer': (context) => LecturerHome(),
            '/lecturer/class': (context) => LecturerClass(),
            '/lecturer/class/create': (context) => LecturerCreateClass(),
            '/lecturer/class/edit': (context) => LecturerEditClass(),
            '/lecturer/class/take_attendance': (context) => RollCallScreen(),
            '/lecturer/class_list': (context) => LecturerClassList(
                  route: "",
                ),
            '/lecturer/send_notification': (context) => SendNotificationScreen(
                  userName: "Nguyen Tan",
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
