import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/main.dart';
import 'package:project/provider/NotificationProvider.dart';
import 'package:provider/provider.dart'; // Import the file where navigatorKey is declared

class FireBaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> initNotifications() async {
    print("INIT FB API");
    await _firebaseMessaging.requestPermission();
    await getFcmToken();
    await initPushNotifications();
  }

  Future<void> getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    _secureStorage.write(key: 'fcm_token', value: token);
    print('FCM Token: $token');
  }

  Future<void> initPushNotifications() async {
    print("INIT PUSH NOTI");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // Handle notifications when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Foreground message received: ${message.notification?.title}, ${message.notification?.body}");
      // Optionally display a dialog or local notification
      final notificationProvider = Provider.of<NotificationProvider>(
          navigatorKey.currentContext!,
          listen: false);
      notificationProvider.getUnreadNotificationCount();
    });
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    try {
      navigatorKey.currentState?.pushNamed('/notifications');
    } catch (e) {
      print("Error navigating to NotificationsScreen: $e");
    }
  }
}
