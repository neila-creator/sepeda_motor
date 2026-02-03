import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Tambah import ini

class RiwayatPeminjamScreen extends StatefulWidget {
  const RiwayatPeminjamScreen({super.key});

  @override
  State<RiwayatPeminjamScreen> createState() => _RiwayatPeminjamScreenState();
}

class _RiwayatPeminjamScreenState extends State<RiwayatPeminjamScreen> {
  final TextEditingController _dariTanggalCtrl = TextEditingController();
  final TextEditingController _sampaiTanggalCtrl = TextEditingController();

  // Variabel baru untuk koneksi Supabase
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _riwayatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDataRiwayat(); // Ambil data pas halaman dibuka
  }

  // Fungsi ambil data tanpa ubah struktur list kamu
  Future<void> _fetchDataRiwayat() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      final data = await supabase
          .from('peminjaman')
          .select()
          .eq('id_user', userId!)
          .order('created_at', ascending: false);

      setState(() {
        _riwayatList = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

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
    // Desain tetap sama persis
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
            child: _riwayatList.isEmpty
                ? const Center(
                    child: Text('Belum ada riwayat peminjaman'),
                  )
                : ListView.builder(
                    itemCount: _riwayatList.length,
                    itemBuilder: (context, index) {
                      final item = _riwayatList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(item['alat'] ??
                                  '-'), // Hubungkan ke kolom 'alat'
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color:
                                        _getStatusColor(item['status'] ?? ''),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    item['status'] ??
                                        '-', // Hubungkan ke kolom 'status'
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
                                item['jumlah']
                                    .toString(), // Hubungkan ke kolom 'jumlah'
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
