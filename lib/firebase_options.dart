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
    apiKey: 'AIzaSyAoaKvYWa7KX8AuenkPZMFCKpoKBt_JJxc',
    appId: '1:169763294370:web:f5c072022968de4fbb1bfb',
    messagingSenderId: '169763294370',
    projectId: 'cronosalud-37e76',
    authDomain: 'cronosalud-37e76.firebaseapp.com',
    storageBucket: 'cronosalud-37e76.firebasestorage.app',
    measurementId: 'G-2HJDZSFWFE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMK8KuAKKhrecgAH-m4LUSWosrI7Dpgwk',
    appId: '1:169763294370:android:d852c2037d144b79bb1bfb',
    messagingSenderId: '169763294370',
    projectId: 'cronosalud-37e76',
    storageBucket: 'cronosalud-37e76.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDG2qpSRclF2BEwFsq4aTHq1thd85Z5DTo',
    appId: '1:169763294370:ios:9c4bb832ce07211cbb1bfb',
    messagingSenderId: '169763294370',
    projectId: 'cronosalud-37e76',
    storageBucket: 'cronosalud-37e76.firebasestorage.app',
    iosBundleId: 'com.example.appCs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDG2qpSRclF2BEwFsq4aTHq1thd85Z5DTo',
    appId: '1:169763294370:ios:9c4bb832ce07211cbb1bfb',
    messagingSenderId: '169763294370',
    projectId: 'cronosalud-37e76',
    storageBucket: 'cronosalud-37e76.firebasestorage.app',
    iosBundleId: 'com.example.appCs',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAoaKvYWa7KX8AuenkPZMFCKpoKBt_JJxc',
    appId: '1:169763294370:web:aee2898ea724e11ebb1bfb',
    messagingSenderId: '169763294370',
    projectId: 'cronosalud-37e76',
    authDomain: 'cronosalud-37e76.firebaseapp.com',
    storageBucket: 'cronosalud-37e76.firebasestorage.app',
    measurementId: 'G-3VX68XHQS6',
  );
}
