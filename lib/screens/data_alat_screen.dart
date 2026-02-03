import 'package:flutter/material.dart';
import '../services/supabase_client.dart';

class DataAlatScreen extends StatefulWidget {
  const DataAlatScreen({super.key});

  @override
  State<DataAlatScreen> createState() => _DataAlatScreenState();
}

class _DataAlatScreenState extends State<DataAlatScreen> {
  List<Map<String, dynamic>> dataAlat = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenToAlat();
  }

  void _listenToAlat() {
    // Perbaikan: Menggunakan tabel 'data_alat'
    SupabaseService.client
        .from('data_alat')
        .stream(primaryKey: ['id'])
        .order('nama', ascending: true)
        .listen((rows) {
          if (!mounted) return;
          setState(() {
            dataAlat = List<Map<String, dynamic>>.from(rows);
            filteredData = dataAlat;
            isLoading = false;
          });
        }, onError: (e) {
          debugPrint("Error: $e");
        });
  }

  Future<void> _upsertAlat(String nama, int harga, String status,
      {int? id}) async {
    // Perbaikan: Nama kolom sesuai database
    final data = {'nama': nama, 'harga_harian': harga, 'status': status};

    try {
      if (id == null) {
        await SupabaseService.client.from('data_alat').insert(data);
      } else {
        await SupabaseService.client
            .from('data_alat')
            .update(data)
            .eq('id', id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteAlat(int id) async {
    try {
      await SupabaseService.client.from('data_alat').delete().eq('id', id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _filterSearch(String query) {
    setState(() {
      filteredData = dataAlat
          .where((item) => (item['nama'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showFormAlat({Map<String, dynamic>? item}) {
    final nameCtrl = TextEditingController(text: item?['nama']);
    // Menggunakan harga_harian dari database
    final hargaCtrl =
        TextEditingController(text: item?['harga_harian']?.toString());
    String? selectedStatus = item?['status'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(item == null ? 'Tambah Alat Baru' : 'Edit Alat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Alat*')),
            TextField(
                controller: hargaCtrl,
                decoration: const InputDecoration(labelText: 'Harga Harian*'),
                keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(labelText: 'Status*'),
              items: ['baik', 'rusak'] // Sesuai data di database Anda
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => selectedStatus = v,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty &&
                  hargaCtrl.text.isNotEmpty &&
                  selectedStatus != null) {
                _upsertAlat(
                    nameCtrl.text, int.parse(hargaCtrl.text), selectedStatus!,
                    id: item?['id']);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F69D0)),
            child: Text(item == null ? 'Simpan' : 'Update',
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alat?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
              onPressed: () {
                _deleteAlat(id);
                Navigator.pop(context);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isBaik = status.toLowerCase() == 'baik';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: isBaik ? const Color(0xFF4CAF50) : const Color(0xFFFFB74D),
          borderRadius: BorderRadius.circular(15)),
      child: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Data Alat',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBFA),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Alat',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      //MAINTENANCE/ ICON OBENG//
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFF3F69D0),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.build,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: searchCtrl,
                            onChanged: _filterSearch,
                            decoration: InputDecoration(
                              hintText: 'Cari alat...',
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _showFormAlat(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xFF90B0FF),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text('Nama Alat',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      Expanded(
                          flex: 1,
                          child: Text('Harga',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      Expanded(
                          flex: 2,
                          child: Text('Status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                    ],
                  ),
                  const Divider(color: Colors.black26, thickness: 1),
                  isLoading
                      ? const Center(
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator()))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final item = filteredData[index];
                            return InkWell(
                              onTap: () => _showFormAlat(item: item),
                              onLongPress: () => _confirmDelete(item['id']),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black12,
                                            width: 0.5))),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(item['nama'] ?? '-',
                                            style:
                                                const TextStyle(fontSize: 12))),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            item['harga_harian'].toString(),
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 13))),
                                    Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: _buildStatusBadge(
                                                item['status'] ?? ''))),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
