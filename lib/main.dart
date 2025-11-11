import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:klaussified/app.dart';
import 'package:klaussified/firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use path-based URLs for web (no hash)
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // Disable debug logging in release mode for better performance
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Enable high performance mode for web on high refresh rate displays
  if (kIsWeb) {
    // Disable default scrollbars on web for better performance
    // This prevents unnecessary repaints
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const KlaussifiedApp());
}
