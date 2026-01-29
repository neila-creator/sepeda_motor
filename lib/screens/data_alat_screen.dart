import 'package:flutter/material.dart';

class DataPeminjamanScreen extends StatefulWidget {
  const DataPeminjamanScreen({super.key});

  @override
  State<DataPeminjamanScreen> createState() => _DataPeminjamanScreenState();
}

class _DataPeminjamanScreenState extends State<DataPeminjamanScreen> {
  final List<Map<String, dynamic>> _peminjamanList = [];

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase() ?? '') {
      case 'terlambat':
        return Colors.red.shade600;
      case 'dipinjam':
        return Colors.blue.shade600;
      default:
        return Colors.green.shade600;
    }
  }

  void _showTambahPeminjamanModal() {
    final alatCtrl = TextEditingController();
    final peminjamCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();
    String? selectedStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Peminjaman',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: alatCtrl,
                decoration: InputDecoration(
                  labelText: 'Alat',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: peminjamCtrl,
                decoration: InputDecoration(
                  labelText: 'Peminjam',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: const [
                  DropdownMenuItem(value: 'Dipinjam', child: Text('Dipinjam')),
                  DropdownMenuItem(value: 'Terlambat', child: Text('Terlambat')),
                ],
                onChanged: (value) => selectedStatus = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: jumlahCtrl,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
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
                        if (alatCtrl.text.isEmpty ||
                            peminjamCtrl.text.isEmpty ||
                            selectedStatus == null ||
                            jumlahCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lengkapi semua field!')),
                          );
                          return;
                        }

                        setState(() {
                          _peminjamanList.add({
                            'alat': alatCtrl.text.trim(),
                            'peminjam': peminjamCtrl.text.trim(),
                            'status': selectedStatus!,
                            'jumlah': int.tryParse(jumlahCtrl.text.trim()) ?? 0,
                          });
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Peminjaman berhasil ditambahkan')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Tambah'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Peminjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data Peminjaman',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _showTambahPeminjamanModal,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Peminjaman'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Alat', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Peminjam', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          Expanded(
            child: _peminjamanList.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada peminjaman',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _peminjamanList.length,
                    itemBuilder: (context, index) {
                      final item = _peminjamanList[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(item['alat'] as String? ?? '-')),
                            Expanded(flex: 2, child: Text(item['peminjam'] as String? ?? '-')),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(item['status'] as String?),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
        onDestinationSelected: (index) {},
        backgroundColor: Colors.white,
        indicatorColor: Colors.blue.shade100,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.build_rounded), label: 'Alat'),
          NavigationDestination(icon: Icon(Icons.swap_horiz_rounded), label: 'Peminjaman'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Laporan'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}