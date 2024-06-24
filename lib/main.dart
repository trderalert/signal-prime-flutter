import 'dart:async';
import 'dart:math';

import 'package:base_setup/application/auto_router/auto_router.dart';
import 'package:base_setup/data/service/notification.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

const onSurface = Color(0xFF21b81b);
const onSurfaceVariant = Color(0xFF919197);

late final FirebaseApp app;
late final FirebaseAuth auth;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final Workmanager workManager = Workmanager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // We store the app and auth to make testing with a named instance easier.
  app = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: app);

  await NotificationService.init();

  workManager.initialize(callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  final datetime = DateTime.now();
  final workManagerTime = DateTime(datetime.year, datetime.month, datetime.day, datetime.hour + 1, datetime.minute, 0);
  final currentDuration20 = workManagerTime.timeZoneOffset;
  final currentDuration15 = (workManagerTime.add(const Duration(minutes: -5))).timeZoneOffset;

  workManager.registerPeriodicTask("trade-view-news", "News Alert !",
      frequency: currentDuration20, initialDelay: currentDuration20, inputData: {'alert': 'alert_20'});

  workManager.registerPeriodicTask("trade-view-news-before", "News Alert !",
      frequency: currentDuration15, initialDelay: currentDuration15, inputData: {'alert': 'alert_15'});

  runApp(const MyApp());
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  workManager.executeTask((task, inputData) {
    if (kDebugMode) {
      print("Native called background task: $task");
    } //simpleTask will be emitted here.
    flutterLocalNotificationsPlugin.cancel(0);
    flutterLocalNotificationsPlugin.cancel(1);

    if (auth.currentUser != null) {
      flutterLocalNotificationsPlugin.show(Random().nextInt(1000000000), 'News Alert',
          'There are some new news to check', NotificationService().notificationDetails);
    }
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer1Hour;
  Timer? _timer55Minutes;

  @override
  void initState() {
    _schedulePeriodicTaskEveryOneHour();
    super.initState();
  }

  @override
  void dispose() {
    _timer1Hour?.cancel();
    _timer55Minutes?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      title: 'Signals Prime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white,
          )),
      routerConfig: appRouter.config(),
    );
  }

  DateTime? nextScheduleTime;

  void _schedulePeriodicTaskEveryOneHour() {
    // Get the current time
    DateTime currentTime = nextScheduleTime ?? DateTime.now();
    nextScheduleTime ??= currentTime.add(const Duration(hours: 1));

    // Calculate the duration until the next schedule time
    Duration? durationUntilNextSchedule = nextScheduleTime?.difference(currentTime);

    final nextSchedule55 = nextScheduleTime?.add(const Duration(minutes: -5));
    _schedulePeriodicTaskEvery55Minutes(nextSchedule55!.timeZoneOffset);

    print('durationUntilNextSchedule $durationUntilNextSchedule');
    print('nextSchedule55 $nextSchedule55');

    // Schedule the periodic task
    _timer1Hour = Timer.periodic(durationUntilNextSchedule ?? const Duration(hours: 1), (timer) {
      nextScheduleTime = nextScheduleTime?.add(const Duration(hours: 1));
      _timer1Hour?.cancel();
      if (auth.currentUser != null) {
        flutterLocalNotificationsPlugin.show(
            1, 'News Alert', 'There are some new news to check', NotificationService().notificationDetails);
      }
      _schedulePeriodicTaskEveryOneHour();
    });
  }

  void _schedulePeriodicTaskEvery55Minutes(Duration duration) {
    _timer55Minutes?.cancel();
    _timer55Minutes = Timer.periodic(duration, (timer) {
      if (auth.currentUser != null) {
        flutterLocalNotificationsPlugin.show(
            0, 'News Alert', 'There are some new news to check', NotificationService().notificationDetails);
      }
      _timer55Minutes?.cancel();
    });
  }
}
