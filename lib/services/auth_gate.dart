import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/login_screen.dart';
import '../screens/dashboard_shared.dart';
import '../screens/dashboard_peminjam.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // Perbaikan: Mencari role berdasarkan User ID (UUID)
  Future<String> _getUserRoleById(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint('User profile tidak ditemukan untuk ID: $userId');
        return 'peminjam';
      }

      return response['role'] ?? 'peminjam';
    } catch (e) {
      debugPrint('Error saat mengambil role: $e');
      return 'peminjam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return const LoginScreen();
        }

        final userId = session.user.id;

        return FutureBuilder<String>(
          future: _getUserRoleById(userId),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data ?? 'peminjam';

            if (role == 'admin' || role == 'petugas') {
              return DashboardShared(role: role);
            } else {
              return const DashboardPeminjam();
            }
          },
        );
      },
    );
  }
}
