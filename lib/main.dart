import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'Screen/login.dart';
import 'Screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    await NotificationService().initialize();
  } catch (e) {
    debugPrint("Firebase gagal diinisialisasi: $e");
    await NotificationService().initialize();
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FutsalApp());
}

class FutsalApp extends StatelessWidget {
  const FutsalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutsalKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F3D2E),
          primary: const Color(0xFF0F3D2E),
        ),
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}