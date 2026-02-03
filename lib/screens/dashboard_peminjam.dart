import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import ini harus ada agar tidak error "Target of URI doesn't exist"
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

  String? _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return null;
      case 1:
        return 'Transaksi Peminjaman';
      case 2:
        return 'Riwayat Saya';
      case 3:
        return 'Profil Pengguna';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? title = _getAppBarTitle();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const DashboardPeminjamContent(), // Konten utama dengan kartu biru
          const DataPeminjamanScreen(role: 'peminjam'),
          const RiwayatPeminjamScreen(),
          const ProfilPeminjamScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        indicatorColor: const Color(0xFFE3F2FD),
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

/* =============================================================
   ISI KONTEN DASHBOARD (KARTU STATISTIK + TOMBOL + TABEL BIRU)
   ============================================================= */
class DashboardPeminjamContent extends StatefulWidget {
  const DashboardPeminjamContent({super.key});

  @override
  State<DashboardPeminjamContent> createState() =>
      _DashboardPeminjamContentState();
}

class _DashboardPeminjamContentState extends State<DashboardPeminjamContent> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _listPeminjaman = [];
  int _totalAktif = 0;
  int _totalAlat = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // Ambil data peminjaman milik user ini
      // Pastikan kolom 'id_user' sesuai dengan di database Supabase kamu!
      final data = await supabase
          .from('peminjaman')
          .select()
          .eq('id_user', user.id)
          .or('status.eq.dipinjam,status.eq.terlambat');

      if (mounted) {
        setState(() {
          _listPeminjaman = List<Map<String, dynamic>>.from(data);
          _totalAktif = data.length;
          _totalAlat = data.fold(
              0, (sum, item) => sum + (int.parse(item['jumlah'].toString())));
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('Dashboard Peminjam',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // --- KARTU STATISTIK ---
          Row(
            children: [
              _buildStatCard(_totalAktif.toString(), 'peminjaman\naktif',
                  Icons.check_circle_outline, Colors.blue),
              const SizedBox(width: 15),
              _buildStatCard(_totalAlat.toString(), 'alat yang\ndipinjam',
                  Icons.swap_horiz, Colors.blueGrey),
            ],
          ),

          const SizedBox(height: 25),

          // --- TOMBOL AJUKAN ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // Contoh: Navigasi ke tab Transaksi (index 1)
              },
              icon: const Icon(Icons.swap_horiz, color: Colors.white),
              label: const Text('ajukan peminjaman',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F69D0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // --- TABEL DENGAN BORDER BIRU (Sesuai Gambar 1) ---
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text('Alat',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      Expanded(
                          flex: 1,
                          child: Text('Jumlah',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator())
                    : _listPeminjaman.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Tidak ada data aktif"))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _listPeminjaman.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _listPeminjaman[index];
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(item['alat'] ?? '-',
                                            style:
                                                const TextStyle(fontSize: 13))),
                                    Expanded(
                                        flex: 2,
                                        child:
                                            _buildBadge(item['status'] ?? '')),
                                    Expanded(
                                        flex: 1,
                                        child: Text(item['jumlah'].toString(),
                                            textAlign: TextAlign.right)),
                                  ],
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String val, String title, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color:
                    Colors.black.withValues(alpha: 0.05), // ✅ Update withValues
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
                backgroundColor:
                    color.withValues(alpha: 0.1), // ✅ Update withValues
                child: Icon(icon, color: color)),
            const SizedBox(height: 10),
            Text(val,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String status) {
    Color color =
        status.toLowerCase() == 'terlambat' ? Colors.red : Colors.blue;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(status,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
