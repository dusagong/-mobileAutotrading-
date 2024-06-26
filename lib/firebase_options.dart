// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAaklC4I-UfYQeryZpbVxWrQfMltQu-yvQ',
    appId: '1:86410707775:web:90103f82276c3aab98098a',
    messagingSenderId: '86410707775',
    projectId: 'mobile-auto-trading',
    authDomain: 'mobile-auto-trading.firebaseapp.com',
    storageBucket: 'mobile-auto-trading.appspot.com',
    measurementId: 'G-B989CY4BTQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDz7B2hTPNKqdJ2UaefeabE35umoC1flq4',
    appId: '1:86410707775:android:ed24ec1d299d033498098a',
    messagingSenderId: '86410707775',
    projectId: 'mobile-auto-trading',
    storageBucket: 'mobile-auto-trading.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyeeFpY8cHN6FaRZ7xIwIHAbckaP-OLfU',
    appId: '1:86410707775:ios:ddad47f45d7675ee98098a',
    messagingSenderId: '86410707775',
    projectId: 'mobile-auto-trading',
    storageBucket: 'mobile-auto-trading.appspot.com',
    iosBundleId: 'hantuflutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDyeeFpY8cHN6FaRZ7xIwIHAbckaP-OLfU',
    appId: '1:86410707775:ios:5e5198874495b13198098a',
    messagingSenderId: '86410707775',
    projectId: 'mobile-auto-trading',
    storageBucket: 'mobile-auto-trading.appspot.com',
    iosBundleId: 'com.example.tradeApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAaklC4I-UfYQeryZpbVxWrQfMltQu-yvQ',
    appId: '1:86410707775:web:1ffd965f52f7905b98098a',
    messagingSenderId: '86410707775',
    projectId: 'mobile-auto-trading',
    authDomain: 'mobile-auto-trading.firebaseapp.com',
    storageBucket: 'mobile-auto-trading.appspot.com',
    measurementId: 'G-NNYW42C8W1',
  );
}
