import 'package:flutter/material.dart';

import 'data_alat_screen.dart' as alat;
import 'data_peminjaman_screen.dart' as peminjaman;
import 'laporan_screen.dart';
import 'profil_screen.dart';
import 'riwayat_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class DashboardShared extends StatefulWidget {
  final String role;

  const DashboardShared({super.key, required this.role});

  @override
  State<DashboardShared> createState() => _DashboardSharedState();
}

class _DashboardSharedState extends State<DashboardShared> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardContent(role: widget.role),
      const alat.DataAlatScreen(),
      peminjaman.DataPeminjamanScreen(
        role: widget.role,
      ),
      widget.role == 'Petugas' ? const RiwayatScreen() : const LaporanScreen(),
      ProfilScreen(role: widget.role),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  String _getHeaderTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Data Alat';
      case 2:
        return 'Peminjaman';
      case 3:
        return widget.role == 'Petugas' ? 'Riwayat' : 'Laporan';
      case 4:
        return 'Profil';
      default:
        return 'Dashboard';
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getHeaderTitle(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ================= CONTENT =================
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        destinations: widget.role == 'Petugas'
            ? const [
                NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
                NavigationDestination(
                    icon: Icon(Icons.build_rounded), label: 'Alat'),
                NavigationDestination(
                    icon: Icon(Icons.swap_horiz_rounded), label: 'Peminjaman'),
                NavigationDestination(
                    icon: Icon(Icons.history_rounded), label: 'Riwayat'),
                NavigationDestination(
                    icon: Icon(Icons.person_rounded), label: 'Profil'),
              ]
            : const [
                NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
                NavigationDestination(
                    icon: Icon(Icons.build_rounded), label: 'Alat'),
                NavigationDestination(
                    icon: Icon(Icons.swap_horiz_rounded), label: 'Peminjaman'),
                NavigationDestination(
                    icon: Icon(Icons.bar_chart_rounded), label: 'Laporan'),
                NavigationDestination(
                    icon: Icon(Icons.person_rounded), label: 'Profil'),
              ],
      ),
    );
  }
}

// ================= DASHBOARD CONTENT =================

class DashboardContent extends StatelessWidget {
  final String role;

  const DashboardContent({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang, $role!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 28),

          // ================= STAT CARD =================
          Row(
            children: [
              Expanded(
                child: _statCard(
                  Icons.build_rounded,
                  Colors.blue,
                  '10',
                  'Total Alat',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  Icons.check_circle_rounded,
                  Colors.green,
                  '5',
                  'Tersedia',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  Icons.autorenew_rounded,
                  Colors.orange,
                  '5',
                  'Transaksi',
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ================= ACTIVITY =================
          Text(
            'Aktivitas Terbaru',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              title: const Text('Meminjam Kunci Shock 10-14mm'),
              subtitle: const Text('Neila • 18 Jan 2026 10:30'),
              leading: const Icon(Icons.history),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, Color color, String number, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
