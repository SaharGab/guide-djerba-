import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/firebase_options.dart';
import 'package:projet_pfe/screens/event_details_screen.dart';
import 'package:projet_pfe/splash.dart';
import 'dart:async';

import 'package:projet_pfe/widgets/notification_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EventUtils.deleteExpiredEvents();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('========User is currently signed out!');
      } else {
        print('===========User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 808),
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          routes: {'/notifications': (context) => const NotificationScreen()},
          debugShowCheckedModeBanner: false,
          home: Splash(),
        );
      },
    );
  }
}
