import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataAlatScreen extends StatefulWidget {
  const DataAlatScreen({super.key});

  @override
  State<DataAlatScreen> createState() => _DataAlatScreenState();
}

class _DataAlatScreenState extends State<DataAlatScreen> {
  late Box _alatBox;

  @override
  void initState() {
    super.initState();
    _alatBox = Hive.box('alatbox');

    // Menambahkan Data Demo agar tampilan sama dengan gambar jika box kosong
    if (_alatBox.isEmpty) {
      _alatBox.addAll([
        {'nama': 'Kunci Ring Set 8-24mm', 'stok': 5, 'status': 'tersedia'},
        {'nama': 'Kunci Ring Set 8-24mm', 'stok': 5, 'status': 'dipinjam'},
        {'nama': 'Kunci Ring Set 8-24mm', 'stok': 5, 'status': 'dipinjam'},
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Data Alat',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFFFFBFA), // Warna background krem muda halus
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
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
                      // Icon Kunci Biru di pojok kanan atas kartu
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

                  // Search Bar & Tombol Tambah Kecil (Sesuai Gambar)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari alat...',
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
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

                  // Header Tabel
                  const Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text('Nama Alat',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      Expanded(
                          flex: 1,
                          child: Text('Stok',
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

                  // List Data
                  ValueListenableBuilder(
                    valueListenable: _alatBox.listenable(),
                    builder: (context, Box box, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final item = box.getAt(index);
                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 0.5))),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              onLongPress: () => box
                                  .deleteAt(index), // Hapus jika ditekan lama
                              title: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Text(item['nama'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87))),
                                  Expanded(
                                      flex: 1,
                                      child: Text(item['stok'].toString(),
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(fontSize: 13))),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: _buildStatusBadge(
                                              item['status']))),
                                ],
                              ),
                            ),
                          );
                        },
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

  Widget _buildStatusBadge(String status) {
    bool isTersedia = status.toLowerCase() == 'tersedia';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: isTersedia ? const Color(0xFF4CAF50) : const Color(0xFFFFB74D),
          borderRadius: BorderRadius.circular(15)),
      child: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  // ✅ Dialog Form "Tambah Alat" (Mirip Gambar Samping)
  void _showFormAlat() {
    final nameCtrl = TextEditingController();
    final stokCtrl = TextEditingController();
    String? status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tambah Alat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nama Alat*',
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: stokCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Stok*',
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Status*',
                hintStyle: const TextStyle(color: Colors.black26),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: ['tersedia', 'dipinjam']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => status = v,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal',
                      style: TextStyle(color: Color(0xFF3F69D0))),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty &&
                        stokCtrl.text.isNotEmpty &&
                        status != null) {
                      _alatBox.add({
                        'nama': nameCtrl.text,
                        'stok': int.parse(stokCtrl.text),
                        'status': status
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F69D0),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Tambah',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
