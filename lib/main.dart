import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kgf_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kgf_app/data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  /// -- Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  /// -- Initialize Local Storage
  await GetStorage.init();

  /// -- Splash Screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// -- Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  runApp(const App());
}
