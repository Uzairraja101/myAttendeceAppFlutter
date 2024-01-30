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
    apiKey: 'AIzaSyAIgQ4CeF_ZDQZX2IYPa_l6hrnLjkrE-tc',
    appId: '1:619124846667:web:4951d52a637e46d7b11dce',
    messagingSenderId: '619124846667',
    projectId: 'myattendiie',
    authDomain: 'myattendiie.firebaseapp.com',
    storageBucket: 'myattendiie.appspot.com',
    measurementId: 'G-XGYTSTTYNV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABcMZfgCVDVJK35R6LXsCT76Dpxw7FlME',
    appId: '1:619124846667:android:31ecd4fd1d8cec99b11dce',
    messagingSenderId: '619124846667',
    projectId: 'myattendiie',
    storageBucket: 'myattendiie.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAM8HrEvk5WbpVuOe7cucXCtzEwWAatVg0',
    appId: '1:619124846667:ios:475c03494dc4c87fb11dce',
    messagingSenderId: '619124846667',
    projectId: 'myattendiie',
    storageBucket: 'myattendiie.appspot.com',
    iosBundleId: 'com.example.myAttendiie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAM8HrEvk5WbpVuOe7cucXCtzEwWAatVg0',
    appId: '1:619124846667:ios:6f675e3ffb4d0590b11dce',
    messagingSenderId: '619124846667',
    projectId: 'myattendiie',
    storageBucket: 'myattendiie.appspot.com',
    iosBundleId: 'com.example.myAttendiie.RunnerTests',
  );
}