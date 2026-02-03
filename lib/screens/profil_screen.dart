import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'kategori_alat_screen.dart';
import 'manajemen_user_screen.dart';
import 'pengembalian_screen.dart';
import 'laporan_screen.dart';

class ProfilScreen extends StatefulWidget {
  final String role;

  const ProfilScreen({super.key, required this.role});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final User? user = Supabase.instance.client.auth.currentUser;

  // ✅ FUNGSI LOGOUT SUPABASE
  Future<void> _handleLogout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout berhasil')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal logout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Memastikan role seragam kecil untuk pengecekan
    final currentRole = widget.role.toLowerCase();
    final isPetugas = currentRole == 'petugas';

    // Mengambil inisial dari email untuk avatar
    String initial = user?.email?.substring(0, 1).toUpperCase() ?? 'U';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- HEADER PROFIL (AMBIL DARI SUPABASE) ---
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isPetugas ? Colors.orange : Colors.blue,
                    child: Text(
                      initial,
                      style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.email?.split('@')[0].toUpperCase() ?? 'USER BENGKEL',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'Tidak ada email',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPetugas ? Colors.orange : Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget
                          .role, // Menampilkan role sesuai yang dikirim dari Dashboard
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- MENU LIST (ADAPTIF ROLE) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Menu yang tampil untuk semua (Admin & Petugas)
                  _buildMenuItem(
                    icon: Icons.undo,
                    title: 'Pengembalian Alat',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PengembalianScreen()));
                    },
                  ),

                  // Menu Khusus Admin
                  if (!isPetugas) ...[
                    _buildMenuItem(
                      icon: Icons.category,
                      title: 'Kategori Alat',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const KategoriAlatScreen()));
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.people,
                      title: 'Manajemen User',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ManajemenUserScreen()));
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.bar_chart,
                      title: 'Laporan Sistem',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LaporanScreen()));
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Footer
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.handshake, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Sistem Peminjaman Bengkel',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Text('Version 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey)),

            const SizedBox(height: 30),

            // ✅ TOMBOL LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar Aplikasi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: Colors.blue.shade700, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
