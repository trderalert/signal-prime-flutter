import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  /// Flutter Local Notification Plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Android notification details
  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails('kumar-electrical', 'channel',
          channelDescription: 'kumar-electrical',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          ticker: 'ticker');

  /// iOS notification details
  DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
  );

  /// Overall notification settings
  NotificationDetails get notificationDetails => NotificationDetails(
      iOS: iosNotificationDetails, android: androidNotificationDetails);

  /// Constructor
  NotificationService();

  static Future<NotificationService> init() async {
    final NotificationService service = NotificationService();
    await service._initialize();
    return service;
  }

  /// Check if the user authorized to receive push notification
  Future<void> _initialize() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
      );
    } catch (_) {
    } finally {
      await _configureLocalNotificationSettings();
    }

    await _listenToFirebaseMessaging();
  }

  ///
  Future<void> _listenToFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("DEV DEBUG ::: OnMessage Called");
      showNotification(message);
    });

    // showNotification(const RemoteMessage(notification: RemoteNotification(
    //     title: 'Test',
    //     body: 'Test notification'
    // )));
  }

  /// Show a local notification
  Future<void> showNotification(RemoteMessage message) async {
    debugPrint("DEV DEBUG ::: Initiated listen firebase messaging");

    // Remote Messaging From Backend
    final Map<String, dynamic> data = message.data;
    final String? titleValue = data['title'];
    final String? messageValue = data['message'];

    // Remote Messaging From Firebase
    final String? testTitle = message.notification?.title;
    final String? testMessageValue = message.notification?.body;

    if (testTitle != null && testMessageValue != null) {
      debugPrint("DEV DEBUG::: Direct push from firebase has been received");
      _flutterLocalNotificationsPlugin.show(
          0, testTitle, testMessageValue, notificationDetails);
    } else if (titleValue != null && messageValue != null) {
      debugPrint("DEV DEBUG ::: Push from backend has been received");
      _flutterLocalNotificationsPlugin.show(
          0, titleValue, messageValue, notificationDetails);
    } else {
      return;
    }
  }

  ///
  Future<void> _configureLocalNotificationSettings() async {
    //Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_status_bar_notification');

    // iOS Settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    //
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      /// ON TAP NOTIFICATION WHILE IN FOREGROUND OR MINIMISED (NOT TERMINATED)
      onSelectPushNotificationMessage();
    });
  }

  ///
  static void onSelectPushNotificationMessage() {
    debugPrint("DEV DEBUG ::: Clicked the notification");
  }
}
