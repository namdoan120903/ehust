import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/main.dart'; // Import the file where navigatorKey is declared

class FireBaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    _secureStorage.write(key: 'fcm_token', value: token);
    print('FCM Token: $token');
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    try {
      navigatorKey.currentState?.pushNamed('/notifications');
    } catch (e) {
      print("Error navigating to NotificationsScreen: $e");
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await initPushNotifications();
    await getFcmToken();
  }
}

// Top-level background handler
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
