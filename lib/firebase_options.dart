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
    apiKey: 'AIzaSyD-tmv2JWV0bk_jcA9Bq7S_Z040flB6bR4',
    appId: '1:628089003387:web:63336b3e337279132a31de',
    messagingSenderId: '628089003387',
    projectId: 'adventures-app-78791',
    authDomain: 'adventures-app-78791.firebaseapp.com',
    storageBucket: 'adventures-app-78791.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQZh_qy9DjJpVv2J1bCoTms-2XHzlNCo4',
    appId: '1:628089003387:android:765662e88f9480b72a31de',
    messagingSenderId: '628089003387',
    projectId: 'adventures-app-78791',
    storageBucket: 'adventures-app-78791.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABnecWZ7uoLmPMtIG_ce184NuzKODKhbQ',
    appId: '1:628089003387:ios:e82576ddef7db3cf2a31de',
    messagingSenderId: '628089003387',
    projectId: 'adventures-app-78791',
    storageBucket: 'adventures-app-78791.appspot.com',
    iosClientId: '628089003387-hrl12kgbqqotkgub3plkcj4j2snjnmni.apps.googleusercontent.com',
    iosBundleId: 'com.example.adventuresApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABnecWZ7uoLmPMtIG_ce184NuzKODKhbQ',
    appId: '1:628089003387:ios:3feed320bc8df6842a31de',
    messagingSenderId: '628089003387',
    projectId: 'adventures-app-78791',
    storageBucket: 'adventures-app-78791.appspot.com',
    iosClientId: '628089003387-6ghv19l4qasgfa0mfr0m3qelgcj5k19u.apps.googleusercontent.com',
    iosBundleId: 'com.example.adventuresApp.RunnerTests',
  );
}
