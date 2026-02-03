import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data_alat_screen.dart' as alat;
import 'data_peminjaman_screen.dart' as peminjaman;
import 'laporan_screen.dart';
import 'profil_screen.dart';
import 'riwayat_screen.dart';

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
    // Identifikasi role sekali saja agar kode lebih bersih
    final bool isPetugas = widget.role.toLowerCase() == 'petugas';

    _pages = [
      DashboardContent(role: widget.role),
      const alat.DataAlatScreen(),
      peminjaman.DataPeminjamanScreen(role: widget.role),
      // Menyesuaikan halaman ke-4 berdasarkan role
      isPetugas ? const RiwayatScreen() : const LaporanScreen(),
      ProfilScreen(role: widget.role),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  String _getHeaderTitle() {
    final bool isPetugas = widget.role.toLowerCase() == 'petugas';
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Data Alat';
      case 2:
        return 'Peminjaman';
      case 3:
        return isPetugas ? 'Riwayat' : 'Laporan';
      case 4:
        return 'Profil';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPetugas = widget.role.toLowerCase() == 'petugas';

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
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: Text(
                _getHeaderTitle(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // ================= CONTENT =================
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor:
            isPetugas ? Colors.orange.shade100 : Colors.blue.shade100,
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          const NavigationDestination(
              icon: Icon(Icons.build_rounded), label: 'Alat'),
          const NavigationDestination(
              icon: Icon(Icons.swap_horiz_rounded), label: 'Pinjam'),
          // Ikon adaptif: History untuk Petugas, Bar Chart untuk Admin
          NavigationDestination(
              icon: Icon(
                  isPetugas ? Icons.history_rounded : Icons.bar_chart_rounded),
              label: isPetugas ? 'Riwayat' : 'Laporan'),
          const NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}

// ================= KONTEN DASHBOARD (DB CONNECTED) =================

class DashboardContent extends StatefulWidget {
  final String role;
  const DashboardContent({super.key, required this.role});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final supabase = Supabase.instance.client;
  int totalAlat = 0;
  int alatTersedia = 0;
  int totalTransaksi = 0;
  List<dynamic> aktivitasTerbaru = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final resAlat = await supabase.from('data_alat').select();
      final resTersedia = await supabase
          .from('data_alat')
          .select()
          .eq('status_alat', 'tersedia');
      final resTransaksi = await supabase.from('peminjaman').select();
      final resAktivitas = await supabase
          .from('peminjaman')
          .select()
          .order('id', ascending: false)
          .limit(5);

      if (mounted) {
        setState(() {
          totalAlat = (resAlat as List).length;
          alatTersedia = (resTersedia as List).length;
          totalTransaksi = (resTransaksi as List).length;
          aktivitasTerbaru = resAktivitas as List;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _fetchStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${widget.role}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Cek status bengkel hari ini',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // STAT CARD SECTION
            Row(
              children: [
                _buildCard(Icons.inventory_2_rounded, Colors.blue,
                    totalAlat.toString(), 'Total Alat'),
                const SizedBox(width: 10),
                _buildCard(Icons.check_circle_rounded, Colors.green,
                    alatTersedia.toString(), 'Ready'),
                const SizedBox(width: 10),
                _buildCard(Icons.assignment_rounded, Colors.orange,
                    totalTransaksi.toString(), 'Transaksi'),
              ],
            ),

            const SizedBox(height: 30),
            const Text('Aktivitas Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            aktivitasTerbaru.isEmpty
                ? const Center(child: Text("Belum ada data peminjaman."))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: aktivitasTerbaru.length,
                    itemBuilder: (context, index) {
                      final data = aktivitasTerbaru[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.person_outline)),
                          title: Text(data['alat'] ?? 'Alat Unknown'),
                          subtitle:
                              Text('Peminjam: ${data['peminjam'] ?? '-'}'),
                          trailing: Text(data['status'] ?? '-',
                              style: TextStyle(
                                  color: data['status'] == 'Kembali'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, Color color, String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(val,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
