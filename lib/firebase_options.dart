import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuPgKYUDDDGm46RnOAKOSh4ezzZHHpsrs',
    appId: '1:1040641710984:android:97bc2112ef3b923b5eb83d',
    messagingSenderId: '1040641710984',
    projectId: 'mindease-b361d',
    storageBucket: 'mindease-b361d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_IOS_API_KEY',
    appId: 'REPLACE_WITH_IOS_APP_ID',
    messagingSenderId: '1040641710984',
    projectId: 'mindease-b361d',
    storageBucket: 'mindease-b361d.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBuPgKYUDDDGm46RnOAKOSh4ezzZHHpsrs',
    appId: '1:1040641710984:web:REPLACE',
    messagingSenderId: '1040641710984',
    projectId: 'mindease-b361d',
    authDomain: 'mindease-b361d.firebaseapp.com',
    storageBucket: 'mindease-b361d.firebasestorage.app',
    measurementId: null,
  );
}
