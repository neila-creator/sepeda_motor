import 'package:flutter/material.dart';
import 'data_peminjaman_screen.dart';
import 'riwayat_peminjam_screen.dart';
import 'profil_peminjam_screen.dart';

class DashboardPeminjam extends StatefulWidget {
  const DashboardPeminjam({super.key});

  @override
  State<DashboardPeminjam> createState() => _DashboardPeminjamState();
}

class _DashboardPeminjamState extends State<DashboardPeminjam> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPeminjamContent(),
    DataPeminjamanScreen(), // Transaksi
    RiwayatPeminjamScreen(), // Riwayat
    ProfilPeminjamScreen(), // Profil
  ];

  // ✅ Fitur Baru: Fungsi untuk menentukan judul AppBar secara dinamis
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Peminjaman';
      case 2:
        return 'Riwayat';
      case 3:
        return 'Profil';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(), // ✅ Sekarang judul berubah sesuai _selectedIndex
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Menghindari back button otomatis
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        indicatorColor: Colors.blue.shade100,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.swap_horiz_rounded), label: 'Transaksi'),
          NavigationDestination(
              icon: Icon(Icons.history_rounded), label: 'Riwayat'),
          NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}

/* ===================== DASHBOARD CONTENT ===================== */
// Tidak ada perubahan pada DashboardPeminjamContent dan fiturnya
class DashboardPeminjamContent extends StatelessWidget {
  const DashboardPeminjamContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dashboard Peminjam',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  icon: Icons.check_circle_rounded,
                  number: '5',
                  label: 'Peminjaman Aktif',
                  color: Colors.blue.shade600,
                ),
                _buildStatCard(
                  icon: Icons.build_rounded,
                  number: '8',
                  label: 'Alat Dipinjam',
                  color: Colors.orange.shade600,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur ajukan peminjaman belum tersedia'),
                    ),
                  );
                },
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                label: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Alat yang dipinjam',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildAlatRow(
              alat: 'Kunci Ring Set 8–24mm',
              status: 'Terlambat',
              jumlah: '4',
              color: Colors.red.shade600,
            ),
            _buildAlatRow(
              alat: 'Kunci Sok 1/2 inch',
              status: 'Dipinjam',
              jumlah: '1',
              color: Colors.blue.shade600,
            ),
            _buildAlatRow(
              alat: 'Kunci Ring Set 8–24mm',
              status: 'Dipinjam',
              jumlah: '2',
              color: Colors.blue.shade600,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                number,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildAlatRow({
    required String alat,
    required String status,
    required String jumlah,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(alat, style: const TextStyle(fontWeight: FontWeight.w500)),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Text(
          jumlah,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
