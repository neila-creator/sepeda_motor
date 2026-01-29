import 'package:flutter/material.dart';
import 'kategori_alat_screen.dart';
import 'manajemen_user_screen.dart';
import 'pengembalian_screen.dart';
import 'laporan_screen.dart';

class ProfilScreen extends StatelessWidget {
  final String role; // wajib ditambahkan untuk membedakan Admin/Petugas

  const ProfilScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isPetugas = role.toLowerCase() == 'petugas';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bagian profil utama (disesuaikan role)
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: const Text(
                      'A',
                      style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPetugas ? 'Aditia' : 'Amin Utama',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPetugas ? 'aditia@bengkel.com' : 'admin@bengkel.com',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPetugas ? 'Petugas' : 'Administrator',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List menu – beda untuk Petugas & Admin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: isPetugas
                    ? [
                        _buildMenuItem(
                          icon: Icons.undo,
                          title: 'Pengembalian',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PengembalianScreen()),
                            );
                          },
                        ),
                      ]
                    : [
                        _buildMenuItem(
                          icon: Icons.category,
                          title: 'Kategori Alat',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const KategoriAlatScreen()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.people,
                          title: 'Manajemen User',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ManajemenUserScreen()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.undo,
                          title: 'Pengembalian',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PengembalianScreen()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.bar_chart,
                          title: 'Laporan',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LaporanScreen()),
                            );
                          },
                        ),
                      ],
              ),
            ),

            const SizedBox(height: 40),

            // Footer sistem + versi (sama untuk semua)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.handshake, color: Colors.blue, size: 30),
                    const SizedBox(width: 8),
                    const Text(
                      'Sistem Peminjaman Bengkel Motor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Tombol Logout merah besar (sama untuk semua)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout berhasil')),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}