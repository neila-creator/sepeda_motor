import 'package:flutter/material.dart';

class RiwayatPeminjamScreen extends StatefulWidget {
  const RiwayatPeminjamScreen({super.key});

  @override
  State<RiwayatPeminjamScreen> createState() => _RiwayatPeminjamScreenState();
}

class _RiwayatPeminjamScreenState extends State<RiwayatPeminjamScreen> {
  final TextEditingController _dariTanggalCtrl = TextEditingController();
  final TextEditingController _sampaiTanggalCtrl = TextEditingController();

  final String namaPeminjam = 'Neila';
  bool _isLoading = false;

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
      'peminjam': 'Neila',
      'status': 'Dikembalikan',
      'jumlah': 2,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'terlambat':
        return Colors.red.shade600;
      case 'dipinjam':
        return Colors.blue.shade600;
      default:
        return Colors.green.shade600;
    }
  }

  @override
  void dispose() {
    _dariTanggalCtrl.dispose();
    _sampaiTanggalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final riwayatPeminjam =
        _riwayatList.where((item) => item['peminjam'] == namaPeminjam).toList();

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
        centerTitle: true,
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: const Text(
              'Riwayat Peminjaman',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // FILTER TANGGAL (UI ONLY)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dariTanggalCtrl,
                    decoration: InputDecoration(
                      labelText: 'Dari tanggal',
                      hintText: 'dd/mm/yyyy',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _sampaiTanggalCtrl,
                    decoration: InputDecoration(
                      labelText: 'Sampai tanggal',
                      hintText: 'dd/mm/yyyy',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // HEADER TABEL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
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
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // LIST RIWAYAT
          Expanded(
            child: riwayatPeminjam.isEmpty
                ? const Center(
                    child: Text('Belum ada riwayat peminjaman'),
                  )
                : ListView.builder(
                    itemCount: riwayatPeminjam.length,
                    itemBuilder: (context, index) {
                      final item = riwayatPeminjam[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(item['alat']),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(item['status']),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    item['status'],
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
                                item['jumlah'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
