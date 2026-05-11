import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gdg_campus_coffee/app.dart';
import 'package:gdg_campus_coffee/seed_data.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kDebugMode) print('🔥 Starting Firebase Initialization...');
  
  try {
    await Firebase.initializeApp();
    if (kDebugMode) print('✅ Firebase Initialized.');
    
    // Run seed in background to prevent blocking startup
    seedDatabase();
  } catch (e) {
    if (kDebugMode) print('❌ Critical Error during Startup: $e');
  }
  
  runApp(const App());
}
