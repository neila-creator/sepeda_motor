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
    _peminjamanBox = Hive.box('peminjamanbox');

    // ✅ DEMO DATA (Sesuai Gambar)
    if (_peminjamanBox.isEmpty) {
      _peminjamanBox.addAll([
        {
          'alat': 'Kunci Ring Set 8-24mm',
          'peminjam': 'Neila',
          'status': 'Terlambat',
          'jumlah': 4
        },
        {
          'alat': 'Kunci Sok Set 1/2 inch',
          'peminjam': 'Neila',
          'status': 'dipinjam',
          'jumlah': 1
        },
        {
          'alat': 'Kunci Ring Set 8-24mm',
          'peminjam': 'Neila',
          'status': 'dipinjam',
          'jumlah': 2
        },
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Peminjaman',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(
                0xFFFFFBFA), // Warna background krem muda halus sesuai gambar
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Judul & Tombol Tambah (Sesuai image_125e17.png)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Data Peminjaman',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                  ElevatedButton(
                    onPressed: () => _showFormPeminjaman(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F69D0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('+ Tambah Peminjaman',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Header Tabel
              const Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text('Alat',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('Peminjam',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('Status',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 1,
                      child: Text('Jumlah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                ],
              ),
              const Divider(thickness: 1, color: Colors.black26),

              // List Data CRUD
              ValueListenableBuilder(
                valueListenable: _peminjamanBox.listenable(),
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
                          onLongPress: () => box.deleteAt(index), // Fitur Hapus
                          title: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text(item['alat'],
                                      style: const TextStyle(fontSize: 11))),
                              Expanded(
                                  flex: 2,
                                  child: Text(item['peminjam'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11))),
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: _badgeStatus(item['status']))),
                              Expanded(
                                  flex: 1,
                                  child: Text(item['jumlah'].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11))),
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
      ),
    );
  }

  Widget _badgeStatus(String status) {
    Color color = const Color(0xFF3F69D0); // Default biru (dipinjam)
    if (status.toLowerCase() == 'terlambat') color = Colors.red;
    if (status.toLowerCase() == 'kembali') color = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  // ✅ DIALOG INPUT (99% Mirip Gambar: Horizontal Field)
  void _showFormPeminjaman() {
    final alatCtrl = TextEditingController();
    final namaCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();
    String status = 'dipinjam';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tambah Peminjaman",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: alatCtrl,
                        decoration: _inputStyle("Alat*"))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: namaCtrl,
                        decoration: _inputStyle("Peminjam*"))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: status,
                    decoration: _inputStyle("Status*"),
                    items: ['dipinjam', 'Terlambat', 'Dikembali']
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child:
                                Text(e, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (v) => status = v!,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: jumlahCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputStyle("Jumlah*"))),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal",
                        style: TextStyle(color: Color(0xFF3F69D0)))),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (alatCtrl.text.isNotEmpty && namaCtrl.text.isNotEmpty) {
                      _peminjamanBox.add({
                        'alat': alatCtrl.text,
                        'peminjam': namaCtrl.text,
                        'status': status,
                        'jumlah': int.tryParse(jumlahCtrl.text) ?? 1,
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F69D0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text("Tambah",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12)),
      );
}
