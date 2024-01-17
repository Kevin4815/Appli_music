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
    apiKey: 'AIzaSyAIaxlRp4vfPZ3kMBwtKyc3491F8cw_Yhw',
    appId: '1:81716928099:web:4854a09ac54179b36ae256',
    messagingSenderId: '81716928099',
    projectId: 'appli-music-d7341',
    authDomain: 'appli-music-d7341.firebaseapp.com',
    storageBucket: 'appli-music-d7341.appspot.com',
    measurementId: 'G-ZSJ3TRQTDJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVkthPSC_lK3iZjDmPLtFdJ-rXsSpDp80',
    appId: '1:81716928099:android:a7f141ee2f12fffd6ae256',
    messagingSenderId: '81716928099',
    projectId: 'appli-music-d7341',
    storageBucket: 'appli-music-d7341.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBLx3IcTxwlBd4RSm-Tf-oa4pP7WgEhaKc',
    appId: '1:81716928099:ios:caf251b8d36919c26ae256',
    messagingSenderId: '81716928099',
    projectId: 'appli-music-d7341',
    storageBucket: 'appli-music-d7341.appspot.com',
    iosBundleId: 'com.example.appliMusic',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBLx3IcTxwlBd4RSm-Tf-oa4pP7WgEhaKc',
    appId: '1:81716928099:ios:caf08e71a2ef42f06ae256',
    messagingSenderId: '81716928099',
    projectId: 'appli-music-d7341',
    storageBucket: 'appli-music-d7341.appspot.com',
    iosBundleId: 'com.example.appliMusic.RunnerTests',
  );
}
