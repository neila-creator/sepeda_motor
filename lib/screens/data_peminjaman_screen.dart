import 'package:flutter/material.dart';

import '../services/supabase_client.dart';

class DataPeminjamanScreen extends StatefulWidget {
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

  // LOGIKA FILTER: Admin lihat semua, User lihat miliknya sendiri
  void _fetchPeminjamanRealtime() {
    final user = SupabaseService.client.auth.currentUser;

    if (widget.role == 'admin') {
      // ================= ADMIN: LIHAT SEMUA =================
      SupabaseService.client
          .from('peminjaman')
          .stream(primaryKey: ['id'])
          .order('id', ascending: false)
          .listen((rows) {
            if (!mounted) return;
            setState(() {
              dataPeminjaman = List<Map<String, dynamic>>.from(rows);
              isLoading = false;
            });
          }, onError: (error) {
            debugPrint("Stream Admin Error: $error");
          });
    } else {
      // ================= USER: HANYA DATA SENDIRI =================
      if (user == null) return;

      SupabaseService.client
          .from('peminjaman')
          .stream(primaryKey: ['id'])
          .eq('id_user', user.id)
          .order('id', ascending: false)
          .listen((rows) {
            if (!mounted) return;
            setState(() {
              dataPeminjaman = List<Map<String, dynamic>>.from(rows);
              isLoading = false;
            });
          }, onError: (error) {
            debugPrint("Stream User Error: $error");
          });
    }
  }

  Future<void> _updateStatus(int id, String statusBaru) async {
    try {
      await SupabaseService.client
          .from('peminjaman')
          .update({'status': statusBaru}).eq('id', id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal update: Cek Policy di Supabase")),
      );
    }
  }

  void _showFormPeminjaman() {
    final alatCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();
    final user = SupabaseService.client.auth.currentUser;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Form Pengajuan Pinjaman",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
                controller: alatCtrl,
                decoration: const InputDecoration(labelText: "Nama Alat")),
            TextField(
                controller: jumlahCtrl,
                decoration: const InputDecoration(labelText: "Jumlah"),
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F69D0),
                  minimumSize: const Size(double.infinity, 45)),
              onPressed: () async {
                try {
                  // Menambahkan id_user secara otomatis saat insert
                  await SupabaseService.client.from('peminjaman').insert({
                    'id_user': user?.id,
                    'alat': alatCtrl.text,
                    'peminjam': user?.email?.split('@')[0] ?? 'User',
                    'jumlah': int.tryParse(jumlahCtrl.text) ?? 0,
                    'status': 'Pending'
                  });
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Gagal! Pastikan kolom id_user ada di DB")),
                  );
                }
              },
              child: const Text("Ajukan Sekarang",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Peminjaman Alat",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (widget.role != 'admin')
            IconButton(
                onPressed: _showFormPeminjaman,
                icon: const Icon(Icons.add_box,
                    color: Color(0xFF3F69D0), size: 30))
        ],
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
        Text(
            widget.role == 'admin'
                ? "Persetujuan Admin"
                : "Status Pinjaman Saya",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          columns: [
            const DataColumn(label: Text('Alat')),
            const DataColumn(label: Text('Peminjam')),
            const DataColumn(label: Text('Status')),
            if (widget.role == 'admin') const DataColumn(label: Text('Aksi')),
          ],
          rows: dataPeminjaman.map((item) {
            return DataRow(cells: [
              DataCell(Text(item['alat'] ?? '-')),
              DataCell(Text(item['peminjam'] ?? '-')),
              DataCell(_buildStatusBadge(item['status'] ?? '')),
              if (widget.role == 'admin')
                DataCell(
                  item['status'] == 'Pending'
                      ? Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () =>
                                    _updateStatus(item['id'], 'Disetujui')),
                            IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    _updateStatus(item['id'], 'Ditolak')),
                          ],
                        )
                      : const Icon(Icons.done_all,
                          color: Colors.grey, size: 20),
                ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = const Color(0xFF3F69D0);
    if (status == 'Disetujui') color = Colors.green;
    if (status == 'Ditolak') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
