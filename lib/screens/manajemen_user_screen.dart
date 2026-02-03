import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManajemenUserScreen extends StatefulWidget {
  const ManajemenUserScreen({super.key});

  @override
  State<ManajemenUserScreen> createState() => _ManajemenUserScreenState();
}

class _ManajemenUserScreenState extends State<ManajemenUserScreen> {
  final supabase = Supabase.instance.client;

  // Mendapatkan warna berdasarkan role
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'petugas':
        return Colors.blue;
      case 'peminjam':
        return Colors.blue.shade300;
      default:
        return Colors.green;
    }
  }

  // ==========================================
  // LOGIKA DATABASE & AUTH
  // ==========================================

  // Fungsi Tambah User Baru via Auth
  Future<void> _tambahUserBaru(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil didaftarkan!')),
        );
      }
    } catch (e) {
      debugPrint("Error SignUp: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString()}')),
        );
      }
    }
  }

  // Fungsi Update Role
  Future<void> _updateUserRole(String id, String newRole) async {
    try {
      await supabase
          .from('profiles')
          .update({'role': newRole.toLowerCase()}).eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Role berhasil diperbarui')),
        );
      }
    } catch (e) {
      debugPrint("Error Update: $e");
    }
  }

  // Fungsi Hapus User
  Future<void> _deleteUser(String id) async {
    try {
      await supabase.from('profiles').delete().eq('id', id);
    } catch (e) {
      debugPrint("Error Delete: $e");
    }
  }

  // ==========================================
  // MODAL DIALOGS
  // ==========================================

  void _showAddUserModal() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tambah User Baru',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                  labelText: 'Email', hintText: 'user@mail.com'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password', hintText: 'Minimal 6 karakter'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F69D0)),
            onPressed: () {
              if (emailCtrl.text.isNotEmpty && passCtrl.text.length >= 6) {
                _tambahUserBaru(emailCtrl.text.trim(), passCtrl.text.trim());
                Navigator.pop(context);
              }
            },
            child:
                const Text('Daftarkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditUserModal(Map<String, dynamic> user) {
    String selectedRole = user['role']?.toString().toUpperCase() ?? 'PEMINJAM';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Role User'),
          content: DropdownButtonFormField<String>(
            value: selectedRole,
            items: ['ADMIN', 'PETUGAS', 'PEMINJAM']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setModalState(() => selectedRole = val!),
            decoration: const InputDecoration(
                labelText: 'Role', border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F69D0)),
              onPressed: () {
                _updateUserRole(user['id'], selectedRole);
                Navigator.pop(context);
              },
              child:
                  const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
        title: const Text('Manajemen User',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('profiles').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBFA),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Daftar User Sistem',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: _showAddUserModal,
                        icon: const Icon(Icons.person_add,
                            size: 16, color: Colors.white),
                        label: const Text('Tambah',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F69D0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  users.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Belum ada data user'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (_, index) {
                            final user = users[index];
                            final roleStr =
                                user['role']?.toString() ?? 'peminjam';

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(user['email'] ?? '-',
                                  style: const TextStyle(fontSize: 13)),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(roleStr),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(roleStr.toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 9)),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue, size: 20),
                                      onPressed: () =>
                                          _showEditUserModal(user)),
                                  IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 20),
                                      onPressed: () => _deleteUser(user['id'])),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
