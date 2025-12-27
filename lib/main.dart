import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nommetric/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Ensures Flutter is ready before we start Firebase [cite: 5]
  WidgetsFlutterBinding.ensureInitialized();

  // Connects the app to your Firebase project [cite: 5]
  // Note: This will require a 'google-services.json' file to work [cite: 5]
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // ProviderScope is required for Riverpod state management [cite: 55, 62]
    const ProviderScope(
      child: NomMetricApp(),
    ),
  );
}

class NomMetricApp extends StatelessWidget {
  const NomMetricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NomMetric',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}