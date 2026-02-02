import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ INIT SUPABASE (WAJIB)
  await Supabase.initialize(
    url: 'https://tfnuarqygddehvfqpmvn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRmbnVhcnF5Z2RkZWh2ZnFwbXZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc4OTUzMzksImV4cCI6MjA4MzQ3MTMzOX0.UzvaQQ6OAjw4541iJedFS-E7WGfFDnT3byGypfPkxlw',
  );

  // ✅ INIT HIVE (TETAP)
  await Hive.initFlutter();
  await Hive.openBox('alatBox');
  await Hive.openBox('peminjamanBox');
  await Hive.openBox('userBox');
  await Hive.openBox('riwayatBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workshop Tools',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
