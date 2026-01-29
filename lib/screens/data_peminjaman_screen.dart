import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataPeminjamanScreen extends StatefulWidget {
  const DataPeminjamanScreen({super.key});

  @override
  State<DataPeminjamanScreen> createState() => _DataPeminjamanScreenState();
}

class _DataPeminjamanScreenState extends State<DataPeminjamanScreen> {
  late Box _peminjamanBox;

  @override
  void initState() {
    super.initState();
    _peminjamanBox = Hive.box('peminjamanBox'); // Gunakan box terpisah atau sama dengan alatBox
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'terlambat':
        return Colors.red.shade600;
      case 'dipinjam':
        return Colors.orange.shade700;
      default:
        return Colors.green.shade600;
    }
  }

  void _showTambahPeminjamanModal({Map<dynamic, dynamic>? existingItem, int? index}) {
    final isEdit = existingItem != null && index != null;
    final alatCtrl = TextEditingController(text: existingItem?['alat'] ?? '');
    final peminjamCtrl = TextEditingController(text: existingItem?['peminjam'] ?? '');
    final jumlahCtrl = TextEditingController(text: existingItem?['jumlah']?.toString() ?? '');
    String? selectedStatus = existingItem?['status'] ?? 'dipinjam';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'Edit Peminjaman' : 'Tambah Peminjaman',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: alatCtrl,
                      decoration: InputDecoration(
                        labelText: 'Alat*',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: peminjamCtrl,
                      decoration: InputDecoration(
                        labelText: 'Peminjam*',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      hint: const Text('Status*'),
                      items: ['Dipinjam', 'Terlambat', 'Dikembalikan']
                          .map((e) => DropdownMenuItem(value: e.toLowerCase(), child: Text(e)))
                          .toList(),
                      onChanged: (val) => setModalState(() => selectedStatus = val),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: jumlahCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah*',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (alatCtrl.text.trim().isEmpty ||
                                  peminjamCtrl.text.trim().isEmpty ||
                                  jumlahCtrl.text.trim().isEmpty ||
                                  selectedStatus == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lengkapi semua field!')),
                                );
                                return;
                              }

                              final data = {
                                'alat': alatCtrl.text.trim(),
                                'peminjam': peminjamCtrl.text.trim(),
                                'status': selectedStatus!,
                                'jumlah': int.tryParse(jumlahCtrl.text.trim()) ?? 0,
                              };

                              if (isEdit) {
                                _peminjamanBox.putAt(index!, data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Peminjaman berhasil diupdate')),
                                );
                              } else {
                                _peminjamanBox.add(data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Peminjaman berhasil ditambahkan')),
                                );
                              }

                              Navigator.pop(context);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(isEdit ? 'Update' : 'Tambah'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final peminjamanList = _peminjamanBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header putih dengan garis tipis bawah
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Data Peminjaman',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _showTambahPeminjamanModal(),
                        child: const Text(
                          'Tambah Peminjaman',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
                  Expanded(flex: 3, child: Text('Alat', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Peminjam', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.grey),

            Expanded(
              child: peminjamanList.isEmpty
                  ? const Center(child: Text('Belum ada peminjaman'))
                  : ListView.builder(
                      itemCount: peminjamanList.length,
                      itemBuilder: (context, index) {
                        final item = peminjamanList[index] as Map<dynamic, dynamic>;
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text(item['alat'] ?? '-')),
                              Expanded(flex: 2, child: Text(item['peminjam'] ?? '-')),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(item['status'] ?? 'dipinjam'),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      (item['status'] ?? 'Dipinjam')[0].toUpperCase() + (item['status'] ?? 'Dipinjam').substring(1),
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text((item['jumlah'] as int? ?? 0).toString(), textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}