import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final SupabaseClient supabase = Supabase.instance.client;

  List<Widget> get _pages => [
        DashboardPeminjamContent(
          onAjukan: () {
            setState(() => _selectedIndex = 1);
          },
        ),
        const DataPeminjamanScreen(
          role: 'peminjam',
        ),
        const RiwayatPeminjamScreen(),
        const ProfilPeminjamScreen(),
      ];

  String _getAppBarTitle() {
    switch (_selectedIndex) {
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
          _getAppBarTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_rounded),
            label: 'Transaksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

/* ===========================
   DASHBOARD CONTENT (SUPABASE CONNECTED)
   =========================== */
class DashboardPeminjamContent extends StatelessWidget {
  final VoidCallback onAjukan;

  const DashboardPeminjamContent({
    super.key,
    required this.onAjukan,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

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
            const SizedBox(height: 16),

            /// 🔗 CONNECT KE SUPABASE (TANPA UBAH DESIGN)
            FutureBuilder<int>(
              future: supabase
                  .from('peminjaman')
                  .select('id')
                  .eq('peminjam_id', userId ?? '')
                  .then((data) => data.length),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (snapshot.hasError) {
                  return const SizedBox();
                }

                return Text(
                  'Total pengajuan kamu: ${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAjukan,
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                label: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
