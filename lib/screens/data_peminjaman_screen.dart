import 'package:flutter/material.dart';
import '../services/supabase_client.dart';

// Pastikan nama class ini TEPAT SEPERTI INI
class DataPeminjamanScreen extends StatefulWidget {
  // Gunakan 'String?' (opsional) agar dashboard peminjam tidak error saat tidak mengirim role
  final String? role;
  const DataPeminjamanScreen({super.key, this.role});

  @override
  State<DataPeminjamanScreen> createState() => _DataPeminjamanScreenState();
}

class _DataPeminjamanScreenState extends State<DataPeminjamanScreen> {
  List<Map<String, dynamic>> dataPeminjaman = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPeminjamanRealtime();
  }

  // FITUR UTAMA: Realtime logic dari Supabase tetap dipertahankan
  void _fetchPeminjamanRealtime() {
    SupabaseService.client
        .from('peminjaman')
        .stream(primaryKey: ['id']).listen((rows) {
      if (mounted) {
        setState(() {
          dataPeminjaman = List<Map<String, dynamic>>.from(rows);
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Peminjaman Saya',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 20),
                  _buildTableContainer(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Daftar Pinjam',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ElevatedButton.icon(
          onPressed: () => _handleTambahPeminjaman(),
          icon: const Icon(Icons.add, size: 18, color: Colors.white),
          label: const Text('Tambah Peminjaman',
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F69D0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildTableContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
                label: Text('Alat',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Peminjam',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Status',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label:
                    Text('Jml', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: dataPeminjaman
              .map((item) => DataRow(cells: [
                    DataCell(Text(item['nama_alat'] ?? '-',
                        style: const TextStyle(fontSize: 12))),
                    DataCell(Text(item['peminjam'] ?? '-')),
                    DataCell(_buildStatusBadge(item['status'] ?? '')),
                    DataCell(Text(item['jumlah']?.toString() ?? '0')),
                  ]))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isDone = status.toLowerCase() == 'dikembalikan';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF4CAF50) : const Color(0xFF3F69D0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _handleTambahPeminjaman() {
    // Masukkan logika dialog tambah data kamu di sini
  }
}
