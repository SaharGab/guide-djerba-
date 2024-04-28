// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA632mLhPWJJslYlJSYb-a8SgXri9wIyLc',
    appId: '1:168430217962:web:dd6d4b44fb6cbc50c18593',
    messagingSenderId: '168430217962',
    projectId: 'guide-djerba',
    authDomain: 'guide-djerba.firebaseapp.com',
    storageBucket: 'guide-djerba.appspot.com',
    measurementId: 'G-YTLFY3FMQR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw8FKaHnTt_JMrh3mW909I1_EytxLfFi0',
    appId: '1:168430217962:android:fa2893b97830a5a8c18593',
    messagingSenderId: '168430217962',
    projectId: 'guide-djerba',
    storageBucket: 'guide-djerba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0sfHfhWXtIkAA5HnT1mdc0AmxVJkcGps',
    appId: '1:168430217962:ios:d37ab404d266bedcc18593',
    messagingSenderId: '168430217962',
    projectId: 'guide-djerba',
    storageBucket: 'guide-djerba.appspot.com',
    iosBundleId: 'com.example.projetPfe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0sfHfhWXtIkAA5HnT1mdc0AmxVJkcGps',
    appId: '1:168430217962:ios:2f52f0d75ddec70ec18593',
    messagingSenderId: '168430217962',
    projectId: 'guide-djerba',
    storageBucket: 'guide-djerba.appspot.com',
    iosBundleId: 'com.example.projetPfe.RunnerTests',
  );
}