import 'package:flutter/material.dart';
import '../services/supabase_client.dart';

class KategoriAlatScreen extends StatefulWidget {
  const KategoriAlatScreen({super.key});

  @override
  State<KategoriAlatScreen> createState() => _KategoriAlatScreenState();
}

class _KategoriAlatScreenState extends State<KategoriAlatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _namaKategoriController = TextEditingController();
  final TextEditingController _deskripsiController =
      TextEditingController(); // Controller Baru

  List<Map<String, dynamic>> _kategoriList = [];
  List<Map<String, dynamic>> _filteredKategori = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKategori();
  }

  void _fetchKategori() {
    SupabaseService.client
        .from('kategori_alat')
        .stream(primaryKey: ['id'])
        .order('nama_kategori', ascending: true)
        .listen((data) {
          if (mounted) {
            setState(() {
              _kategoriList = data;
              _filteredKategori = data;
              _isLoading = false;
            });
          }
        }, onError: (error) {
          debugPrint('Error Fetch: $error');
          if (mounted) setState(() => _isLoading = false);
        });
  }

  Future<void> _upsertKategori({int? id}) async {
    final name = _namaKategoriController.text.trim();
    final desc = _deskripsiController.text.trim(); // Ambil input deskripsi
    if (name.isEmpty) return;

    final data = {
      'nama_kategori': name,
      'deskripsi': desc, // Simpan ke kolom deskripsi
      'image_url':
          'https://images.unsplash.com/photo-1581092160562-40aa08e78837',
    };

    try {
      if (id == null) {
        await SupabaseService.client.from('kategori_alat').insert(data);
      } else {
        await SupabaseService.client
            .from('kategori_alat')
            .update(data)
            .eq('id', id);
      }
      _namaKategoriController.clear();
      _deskripsiController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteKategori(int id) async {
    try {
      await SupabaseService.client.from('kategori_alat').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error Delete: $e');
    }
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredKategori = _kategoriList
          .where((item) => (item['nama_kategori'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showTambahKategoriModal({Map<String, dynamic>? item}) {
    _namaKategoriController.text = item?['nama_kategori'] ?? '';
    _deskripsiController.text =
        item?['deskripsi'] ?? ''; // Set value deskripsi saat edit

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                  item == null ? 'Tambah Kategori' : 'Edit Kategori',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _namaKategoriController,
                  decoration: InputDecoration(
                    labelText: 'Nama Kategori',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                // Input Deskripsi Baru
                TextField(
                  controller: _deskripsiController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Contoh: Obeng, Tang, dll',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _namaKategoriController.clear();
                          _deskripsiController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Batal',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _upsertKategori(id: item?['id']);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Konfirmasi',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kategori Alat',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () => _showTambahKategoriModal(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daftar Kategori',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _filterSearch,
                  decoration: InputDecoration(
                    hintText: 'Cari kategori...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            0.75, // Disesuaikan agar muat teks lebih banyak
                      ),
                      itemCount: _filteredKategori.length,
                      itemBuilder: (context, index) {
                        final item = _filteredKategori[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.network(
                                    item['image_url'] ?? '',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, e, s) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Text(
                                  item['nama_kategori'] ?? '-',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Menampilkan Deskripsi di Grid
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  item['deskripsi'] ?? '',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 11),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue, size: 18),
                                    onPressed: () =>
                                        _showTambahKategoriModal(item: item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 18),
                                    onPressed: () =>
                                        _deleteKategori(item['id']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
