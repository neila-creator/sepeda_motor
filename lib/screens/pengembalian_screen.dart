import 'package:flutter/material.dart';

class PengembalianScreen extends StatelessWidget {
  const PengembalianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengembalian',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header putih dengan garis tipis bawah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: const Text(
              'Pengembalian Alat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Header tabel
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                    flex: 3,
                    child: Text('Alat',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text('Jumlah',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child: Text('Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          // List data pengembalian
          Expanded(
            child: ListView.builder(
              itemCount: 1, // ganti dengan data real nanti (misal dari Hive)
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 3, child: Text('Kunci Sok Set 1/2 inch')),
                      Expanded(
                        flex: 1,
                        child: Text('1', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Terlambat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex:
            2, // sesuaikan index tab kalau di dashboard_shared (misal Transaksi atau Pengembalian)
        onDestinationSelected: (index) {
          // TODO: navigasi antar tab
        },
        backgroundColor: Colors.white,

        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.build_rounded), label: 'Alat'),
          NavigationDestination(
              icon: Icon(Icons.swap_horiz_rounded), label: 'Transaksi'),
          NavigationDestination(
              icon: Icon(Icons.bar_chart_rounded), label: 'Laporan'),
          NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
