import 'package:flutter/material.dart';

class ManajemenUserScreen extends StatefulWidget {
  const ManajemenUserScreen({super.key});

  @override
  State<ManajemenUserScreen> createState() => _ManajemenUserScreenState();
}

class _ManajemenUserScreenState extends State<ManajemenUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  String? _selectedRole;

  // Contoh data seperti screenshotmu (statis untuk demo)
  final List<Map<String, String>> _users = [
    {'email': 'admin@bengkel.com', 'role': 'ADMIN'},
    {'email': 'aditia@bengkel.com', 'role': 'PETUGAS'},
    {'email': 'neila@bengkel.com', 'role': 'PENGGUNA'},
    {'email': 'tutik@bengkel.com', 'role': 'PEMINJAM'},
  ];

  Color _getRoleColor(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return Colors.red;
      case 'PETUGAS':
        return Colors.blue;
      case 'PENGGUNA':
        return Colors.green;
      case 'PEMINJAM':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showTambahUserModal({Map<String, String>? existing, int? index}) {
    final isEdit = existing != null && index != null;
    _emailCtrl.text = existing?['email'] ?? '';
    _selectedRole = existing?['role'] ?? 'PENGGUNA';

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
                      isEdit ? 'Edit User' : 'Tambah User',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        labelText: 'User*',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      hint: const Text('Role*'),
                      items: ['ADMIN', 'PETUGAS', 'PENGGUNA', 'PEMINJAM']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setModalState(() => _selectedRole = val),
                      decoration: InputDecoration(
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
                              if (_emailCtrl.text.trim().isEmpty || _selectedRole == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Lengkapi semua field!')),
                                );
                                return;
                              }

                              // Simpan atau update data
                              setState(() {
                                if (isEdit) {
                                  _users[index!] = {
                                    'email': _emailCtrl.text.trim(),
                                    'role': _selectedRole!,
                                  };
                                } else {
                                  _users.add({
                                    'email': _emailCtrl.text.trim(),
                                    'role': _selectedRole!,
                                  });
                                }
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User berhasil disimpan')),
                              );
                              Navigator.pop(context);
                              _emailCtrl.clear();
                              _selectedRole = null;
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

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User'),
        content: const Text('Yakin ingin menghapus user ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _users.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
        title: const Text(
          'User',
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
              border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manajemen User',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Tombol Tambah User di tengah
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _showTambahUserModal(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Tambah User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
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
                Expanded(flex: 3, child: Text('User', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                SizedBox(width: 80), // ruang edit & delete
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.grey),

          Expanded(
            child: _users.isEmpty
                ? const Center(child: Text('Belum ada user'))
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(user['email'] ?? '-')),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(user['role'] ?? ''),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    user['role'] ?? 'PENGGUNA',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () => _showTambahUserModal(existing: user, index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => _confirmDelete(index),
                                  ),
                                ],
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
    );
  }
}