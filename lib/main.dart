import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import SEMUA screens yang sudah ada di project
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_shared.dart';
import 'screens/dashboard_peminjam.dart';
import 'screens/data_alat_screen.dart';
import 'screens/data_peminjaman_screen.dart';
import 'screens/laporan_screen.dart';
import 'screens/profil_screen.dart';
import 'screens/manajemen_user_screen.dart';
import 'screens/kategori_alat_screen.dart';
import 'screens/pengembalian_screen.dart';
import 'screens/riwayat_screen.dart'; // ← tambahan penting untuk tab Riwayat Petugas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Buka SEMUA box yang dibutuhkan
  await Hive.openBox('alatBox');           // Data Alat
  await Hive.openBox('peminjamanBox');     // Data Peminjaman
  await Hive.openBox('userBox');           // Manajemen User
  await Hive.openBox('riwayatBox');        // ← tambahan untuk Riwayat (opsional, kalau pakai Hive di riwayat_screen.dart)

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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      initialRoute: '/', // mulai dari splash

      // Route management (sudah di-upgrade untuk support semua role)
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());

          case '/main':
            final role = settings.arguments as String? ?? 'Peminjam';
            return MaterialPageRoute(
              builder: (_) {
                if (role == 'Admin' || role == 'Petugas') {
                  return DashboardShared(role: role); // satu file shared, navbar beda berdasarkan role
                } else {
                  return const DashboardPeminjam();
                }
              },
            );

          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}