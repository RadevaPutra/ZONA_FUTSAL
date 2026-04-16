import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screen/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const LoginScreen(),
    );
  }
}