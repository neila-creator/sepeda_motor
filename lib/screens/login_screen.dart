import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_shared.dart'; // Dashboard untuk Admin & Petugas
import 'dashboard_peminjam.dart'; // Dashboard untuk Peminjam

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;
  String? errorMessage;

  Future<void> loginSupabase() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result.user != null) {
        // Ambil data role dari tabel profiles
        final userData = await Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', result.user!.id)
            .maybeSingle();

        if (userData == null) {
          setState(
              () => errorMessage = 'User profile tidak ditemukan di database.');
          return;
        }

        // Normalisasi string role (admin/petugas/peminjam)
        String role =
            (userData['role'] ?? 'peminjam').toString().trim().toLowerCase();

        if (!mounted) return;

        // ✅ LOGIKA NAVIGASI: Arahkan ke Dashboard yang sesuai
        if (role == 'admin' || role == 'petugas') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardShared(role: role)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPeminjam()),
          );
        }
      }
    } catch (e) {
      setState(() =>
          errorMessage = 'Login gagal: Periksa kembali email & password.');
      debugPrint("Login Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF91B4F8),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.build_circle_rounded,
                        size: 80, color: Color(0xFF91B4F8)),
                    const SizedBox(height: 16),
                    const Text(
                      'Workshop Tools',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12)),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate())
                                  loginSupabase();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF91B4F8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Login',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
