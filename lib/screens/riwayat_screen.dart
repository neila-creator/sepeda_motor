import 'package:flutter/material.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _dariTanggalCtrl = TextEditingController();
  final TextEditingController _sampaiTanggalCtrl = TextEditingController();

  bool _isLoading = false;

  // Contoh data riwayat persis seperti screenshotmu
  final List<Map<String, dynamic>> _riwayatList = [
    {
      'alat': 'Kunci Ring Set Ring 8-24mm',
      'peminjam': 'Neila',
      'status': 'Terlambat',
      'jumlah': 4,
    },
    {
      'alat': 'Kunci Sok Set 1/2 inch',
      'peminjam': 'Tutik',
      'status': 'Dipinjam',
      'jumlah': 1,
    },
    {
      'alat': 'Kunci Ring Set Ring 8-24mm',
      'peminjam': 'Nella',
      'status': 'Dipinjam',
      'jumlah': 2,
    },
  ];

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'terlambat':
        return Colors.red.shade600;
      case 'dipinjam':
        return Colors.blue.shade600; // biru seperti di screenshot
      default:
        return Colors.green.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header putih dengan garis tipis bawah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: const Text(
              'Riwayat Peminjaman',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Filter tanggal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dariTanggalCtrl,
                    decoration: InputDecoration(
                      labelText: 'Dari tanggal',
                      hintText: 'dd/mm/yyyy',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _sampaiTanggalCtrl,
                    decoration: InputDecoration(
                      labelText: 'Sampai tanggal',
                      hintText: 'dd/mm/yyyy',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ],
            ),
          ),

          // Header tabel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                    flex: 3,
                    child: Text('Alat',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text('Peminjam',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text('Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('Jumlah',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          // List riwayat
          Expanded(
            child: _riwayatList.isEmpty
                ? const Center(child: Text('Belum ada riwayat peminjaman'))
                : ListView.builder(
                    itemCount: _riwayatList.length,
                    itemBuilder: (context, index) {
                      final item = _riwayatList[index];
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(item['alat'] as String? ?? '-')),
                            Expanded(
                                flex: 2,
                                child:
                                    Text(item['peminjam'] as String? ?? '-')),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                        item['status'] as String?),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    item['status'] as String? ?? 'Tersedia',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  (item['jumlah'] as int? ?? 0).toString(),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3, // Riwayat adalah tab 3
        onDestinationSelected: (index) {
          // TODO: navigasi ke tab lain (bisa pakai Navigator atau callback ke dashboard)
          if (index != 3) {
            Navigator.pop(context); // contoh sederhana kembali ke dashboard
          }
        },
        backgroundColor: Colors.white,

        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.build_rounded), label: 'Alat'),
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
