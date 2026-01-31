import 'package:flutter/material.dart';

class ManajemenUserScreen extends StatefulWidget {
  const ManajemenUserScreen({super.key});

  @override
  State<ManajemenUserScreen> createState() => _ManajemenUserScreenState();
}

class _ManajemenUserScreenState extends State<ManajemenUserScreen> {
  final List<Map<String, String>> _users = [
    {'email': 'admin@gmail.com', 'role': 'ADMIN'},
    {'email': 'aditia@gmail.com', 'role': 'PETUGAS'},
    {'email': 'neila@gmail.com', 'role': 'PENGGUNA'},
    {'email': 'tutik@gmail.com', 'role': 'PEMINJAM'},
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
        return Colors
            .blue.shade300; // Menyesuaikan warna badge biru muda di gambar
      default:
        return Colors.grey;
    }
  }

  // =========================
  // UPGRADED DIALOG (Sesuai Gambar)
  // =========================
  void _showTambahUserModal({Map<String, String>? existing, int? index}) {
    final isEdit = existing != null && index != null;
    final emailCtrl = TextEditingController(text: existing?['email'] ?? '');
    String? selectedRole = existing?['role'] ?? 'PENGGUNA';

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? 'Edit User' : 'Tambah User',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // INPUT EMAIL
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      hintText: 'User*',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.black26),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // INPUT ROLE
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: ['ADMIN', 'PETUGAS', 'PENGGUNA', 'PEMINJAM']
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child:
                                Text(e, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (val) => setModalState(() => selectedRole = val),
                    decoration: InputDecoration(
                      hintText: 'Role*',
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.black26),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal',
                            style: TextStyle(color: Colors.blue)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (emailCtrl.text.trim().isEmpty ||
                              selectedRole == null) return;
                          setState(() {
                            if (isEdit) {
                              _users[index!] = {
                                'email': emailCtrl.text.trim(),
                                'role': selectedRole!
                              };
                            } else {
                              _users.add({
                                'email': emailCtrl.text.trim(),
                                'role': selectedRole!
                              });
                            }
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F69D0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isEdit ? 'Simpan' : 'Tambah',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
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
      builder: (_) => AlertDialog(
        title: const Text('Hapus User'),
        content: const Text('Yakin ingin menghapus user ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _users.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
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
        centerTitle: true,
        title: const Text(
          'Manajemen User',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBFA), // Warna krem halus sesuai gambar
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // HEADER BOX: Judul & Tombol Tambah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manajemen User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () => _showTambahUserModal(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F69D0),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('+ Tambah User',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // HEADER TABEL
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text('User',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13))),
                    Expanded(
                        flex: 2,
                        child: Text('Role',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13))),
                    SizedBox(width: 70), // Spacer untuk action button
                  ],
                ),
              ),
              const Divider(thickness: 1),

              // LIST USER
              _users.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Belum ada user'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _users.length,
                      itemBuilder: (_, index) {
                        final user = _users[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12, width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(user['email']!,
                                    style: const TextStyle(fontSize: 12)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(user['role']!),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      user['role']!.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              // ACTION BUTTONS
                              SizedBox(
                                width: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _showTambahUserModal(
                                          existing: user, index: index),
                                      child: const Icon(Icons.edit,
                                          color: Colors.blue, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => _confirmDelete(index),
                                      child: const Icon(Icons.delete,
                                          color: Colors.red, size: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
