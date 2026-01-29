import 'package:flutter/material.dart';

class DashboardPeminjam extends StatefulWidget {
  const DashboardPeminjam({super.key});

  @override
  State<DashboardPeminjam> createState() => _DashboardPeminjamState();
}

class _DashboardPeminjamState extends State<DashboardPeminjam> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardPeminjamContent(),
    Center(child: Text('Halaman Transaksi')),
    Center(child: Text('Halaman Riwayat')),
    Center(child: Text('Halaman Profil')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Dashboard Peminjam'),
        backgroundColor: const Color.fromARGB(255, 251, 252, 252),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        indicatorColor: Colors.blue.shade100,
        destinations: const <Widget>[
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

class DashboardPeminjamContent extends StatelessWidget {
  const DashboardPeminjamContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Dashboard
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 2 Card Statistik
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  icon: Icons.check_circle_rounded,
                  number: '5',
                  label: 'peminjaman aktif',
                  color: Colors.blue.shade700,
                ),
                _buildStatCard(
                  icon: Icons.swap_horiz_rounded,
                  number: '5',
                  label: 'alat yang\ndipinjam',
                  color: Colors.blue.shade700,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Ajukan Peminjaman
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: arahkan ke form ajukan peminjaman
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur ajukan peminjaman belum tersedia')),
                  );
                },
                icon: const Icon(Icons.swap_horiz, size: 20),
                label: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Bagian Alat yang Dipinjam + Tabel
            const Text(
              'Alat yang dipinjam',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header Tabel
                    Row(
                      children: const [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Alat',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Jumlah',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Baris data
                    _buildTableRow(
                      alat: 'Kunci Ring Set 8-24mm',
                      status: 'Terlambat',
                      jumlah: '4',
                      statusColor: Colors.red.shade600,
                    ),
                    const Divider(),

                    _buildTableRow(
                      alat: 'Kunci Sok 1/2 inch Set',
                      status: 'Dipinjam',
                      jumlah: '1',
                      statusColor: const Color.fromARGB(255, 0, 25, 245),
                    ),
                    const Divider(),

                    _buildTableRow(
                      alat: 'Kunci Ring Set 8-24mm',
                      status: 'Dipinjam',
                      jumlah: '2',
                      statusColor: const Color.fromARGB(255, 0, 25, 245),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                number,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow({
    required String alat,
    required String status,
    required String jumlah,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(alat),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20), // lingkaran penuh
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              jumlah,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}