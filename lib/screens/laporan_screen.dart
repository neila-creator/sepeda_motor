import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  int totalAlat = 0;
  int totalTransaksi = 0;
  int peminjamanAktif = 0;
  int alatRusak = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLaporanData();
  }

  Future<void> _fetchLaporanData() async {
    try {
      final supabase = Supabase.instance.client;

      final resAlat = await supabase.from('data_alat').select();
      final resTransaksi = await supabase.from('peminjaman').select();
      final resAktif =
          await supabase.from('peminjaman').select().eq('status', 'dipinjam');
      final resRusak =
          await supabase.from('data_alat').select().eq('status_alat', 'rusak');

      setState(() {
        totalAlat = resAlat.length;
        totalTransaksi = resTransaksi.length;
        peminjamanAktif = resAktif.length;
        alatRusak = resRusak.length;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error laporan: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Laporan Sistem',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
                children: [
                  ReportCard(
                    value: totalAlat.toString(),
                    title: 'Total Alat',
                  ),
                  ReportCard(
                    value: totalTransaksi.toString(),
                    title: 'Total Transaksi',
                  ),
                  ReportCard(
                    value: peminjamanAktif.toString(),
                    title: 'Peminjaman Aktif',
                  ),
                  ReportCard(
                    value: alatRusak.toString(),
                    title: 'Alat Rusak',
                  ),
                ],
              ),
            ),
    );
  }
}

/* ================== REPORT CARD ================== */
class ReportCard extends StatelessWidget {
  final String value;
  final String title;

  const ReportCard({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF62A9EB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5FF),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: const Text(
              'Detail',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
