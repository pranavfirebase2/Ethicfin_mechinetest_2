import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
///
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
    apiKey: 'AIzaSyD3QpQpxWUVUOHkk7ZZVGaA9hzn7UUaFaE',
    appId: '1:717376638619:web:2dcea594a4ef0ce912403e',
    messagingSenderId: '717376638619',
    projectId: 'ethicfin-todo',
    authDomain: 'ethicfin-todo.firebaseapp.com',
    storageBucket: 'ethicfin-todo.firebasestorage.app',
    measurementId: 'G-3ZWLPBMB5W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2OiZuinMGx6OzKpr2i4TyArelip8kVys',
    appId: '1:717376638619:android:bed1f25b4032fb0312403e',
    messagingSenderId: '717376638619',
    projectId: 'ethicfin-todo',
    storageBucket: 'ethicfin-todo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkwyhQsTbfq9eMDLWkfdoS10OyTSZm8TI',
    appId: '1:717376638619:ios:6d4387293bb1824a12403e',
    messagingSenderId: '717376638619',
    projectId: 'ethicfin-todo',
    storageBucket: 'ethicfin-todo.firebasestorage.app',
    iosBundleId: 'com.example.ethicfinMechinetest2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkwyhQsTbfq9eMDLWkfdoS10OyTSZm8TI',
    appId: '1:717376638619:ios:6d4387293bb1824a12403e',
    messagingSenderId: '717376638619',
    projectId: 'ethicfin-todo',
    storageBucket: 'ethicfin-todo.firebasestorage.app',
    iosBundleId: 'com.example.ethicfinMechinetest2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3QpQpxWUVUOHkk7ZZVGaA9hzn7UUaFaE',
    appId: '1:717376638619:web:ff6803abcfb9089312403e',
    messagingSenderId: '717376638619',
    projectId: 'ethicfin-todo',
    authDomain: 'ethicfin-todo.firebaseapp.com',
    storageBucket: 'ethicfin-todo.firebasestorage.app',
    measurementId: 'G-8SY0RXKRB9',
  );
}
