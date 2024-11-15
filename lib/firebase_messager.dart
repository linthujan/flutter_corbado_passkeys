import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
  print('Payload ${message.notification?.android?.sound}');
  print('Channel ${jsonEncode(message.toMap())}');
}

Future<http.Response> registerToken(String fcmToken) {
  return http.post(
    Uri.parse('https://tough-terminally-koala.ngrok-free.app/api/device'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'fcm_token': fcmToken,
      'platform': 'ANDROID',
      'user_id': 'cf7ea967-c644-418b-a48c-9a3086ebfb7a',
      // 'device_name': manufacturer + model,
      // 'device_id': androidId,
    }),
  );
}

class FirebaseMessager {
  final _firebaseMessager = FirebaseMessaging.instance;

  static void handleForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Title ${message.notification?.title}');
      print('Body ${message.notification?.body}');
      print('Payload ${message.data}');
      print('Payload ${message.notification?.android?.sound}');
      print('Channel ${jsonEncode(message.notification?.android)}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> initNotification() async {
    // await _firebaseMessager.setAutoInitEnabled(true);
    final settings = await _firebaseMessager.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    await _firebaseMessager.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await _firebaseMessager.getToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', jsonEncode(fcmToken));

    if (Platform.isAndroid) {
      await registerToken(fcmToken!);
    }

    print('Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
    handleForeground();
    // FirebaseMessaging.onMessage.listen(handleBackgroundMessage);
  }
}
