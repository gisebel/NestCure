import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDUKFtBIDucIbnRmuTs5KrAa6vCVh0BMPw',
    appId: '1:110021199237:web:e48fa93cc12a13793270ec',
    messagingSenderId: '110021199237',
    projectId: 'nestcure-3e93b',
    authDomain: 'nestcure-3e93b.firebaseapp.com',
    storageBucket: 'nestcure-3e93b.firebasestorage.app',
    measurementId: 'G-5D91QPH72T',
    databaseURL: 'https://nestcure-3e93b.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhfwkn5ru4A85jrtbF6gHYvHKSmDEW61c',
    appId: '1:110021199237:android:eda2420a223023843270ec',
    messagingSenderId: '110021199237',
    projectId: 'nestcure-3e93b',
    storageBucket: 'nestcure-3e93b.firebasestorage.app',
    databaseURL: 'https://nestcure-3e93b.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBU7fOe4IkcBUGDjGfFMsAIeo6-FKqhsbo',
    appId: '1:110021199237:ios:dce54a569d7a0eb93270ec',
    messagingSenderId: '110021199237',
    projectId: 'nestcure-3e93b',
    storageBucket: 'nestcure-3e93b.firebasestorage.app',
    iosBundleId: 'com.example.nestcure',
    databaseURL: 'https://nestcure-3e93b.firebaseio.com',
  );
}