import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/login_screen.dart';
import '../screens/dashboard_shared.dart';
import '../screens/dashboard_peminjam.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();

      return data['role']?.toString().toLowerCase();
    } catch (e) {
      debugPrint('ERROR get role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    // BELUM LOGIN
    if (session == null) {
      return const LoginScreen();
    }

    // SUDAH LOGIN → CEK ROLE
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data;

        // ADMIN & PETUGAS → DASHBOARD SHARED
        if (role == 'admin' || role == 'petugas') {
          return DashboardShared(role: role!);
        }

        // DEFAULT → PEMINJAM
        return const DashboardPeminjam();
      },
    );
  }
}
