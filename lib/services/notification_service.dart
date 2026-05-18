import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseMessaging? _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Inisialisasi FCM secara aman
    try {
      _fcm = FirebaseMessaging.instance;
    } catch (e) {
      debugPrint("FCM tidak tersedia: $e");
    }
    // 1. Inisialisasi Notifikasi Lokal
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    // 2. Request Izin FCM
    if (_fcm == null) return;
    
    NotificationSettings settings = await _fcm!.requestPermission();
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _fcm!.getToken();
      print("Device Token: $token");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          showNotification(
            message.notification!.title ?? "Pesan Baru",
            message.notification!.body ?? "",
          );
        }
      });
    }
  }

  Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'zona_futsal_channel',
      'Zona Futsal Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    
    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  Future<void> showBookingReminder(String fieldName, String time) async {
    const androidDetails = AndroidNotificationDetails(
      'booking_channel',
      'Booking Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    await _localNotifications.show(
      0,
      'Booking Berhasil! ⚽',
      'Jadwal tanding di $fieldName pukul $time telah dicatat.',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
