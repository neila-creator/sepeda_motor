import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_shared.dart'; // untuk Admin & Petugas
import 'dashboard_peminjam.dart'; // untuk Peminjam

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

  // ================= LOGIKA LOGIN SUPABASE =================
  Future<void> loginSupabase() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 1️⃣ Login Supabase Auth
      final result = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("DEBUG: loginSupabase -> user: ${result.user?.id}"); // 🔹 debugging

      if (result.user != null) {
        // 2️⃣ Ambil role dari tabel 'profiles'
        final userData = await Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', result.user!.id)
            .single();

        print("DEBUG: userData dari Supabase: $userData"); // 🔹 debugging

        String role = (userData['role'] ?? '').toString().toLowerCase();

        print("DEBUG: role setelah lowerCase: $role"); // 🔹 debugging

        if (!mounted) return;

        // 3️⃣ Navigasi berdasarkan role
        if (role == 'admin' || role == 'petugas') {
          print("DEBUG: masuk ke DashboardShared"); // 🔹 debugging
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardShared(role: role)),
          );
        } else if (role == 'peminjam') {
          print("DEBUG: masuk ke DashboardPeminjam"); // 🔹 debugging
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPeminjam()),
          );
        } else {
          setState(() {
            errorMessage = 'Role tidak dikenali.';
          });
          print("DEBUG: role tidak dikenali"); // 🔹 debugging
        }
      } else {
        print("DEBUG: result.user == null"); // 🔹 debugging
      }
    } on AuthException catch (e) {
      setState(() => errorMessage = e.message);
      print("DEBUG: AuthException -> ${e.message}"); // 🔹 debugging
    } catch (e) {
      setState(() => errorMessage = 'Gagal memverifikasi akun.');
      print("DEBUG: catch error -> $e"); // 🔹 debugging
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  // ==========================================================

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
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF91B4F8),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'assets/images/image.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.build_rounded,
                                size: 80, color: Colors.white);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // JUDUL
                    const Text(
                      'Workshop\nTools',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // INPUT EMAIL
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email*',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Email wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // INPUT PASSWORD
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password*',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Password wajib diisi'
                          : null,
                    ),

                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12)),
                      ),

                    const SizedBox(height: 32),

                    // TOMBOL LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  loginSupabase();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF91B4F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
