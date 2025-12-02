// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LoginDemoApp());
}

class LoginDemoApp extends StatelessWidget {
  const LoginDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _remember = false;
  bool _obscure = true;
  bool _loading = false;

  static const _prefEmailKey = 'saved_email';
  static const _prefRememberKey = 'remember_me';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_prefRememberKey) ?? false;
    final savedEmail = prefs.getString(_prefEmailKey) ?? '';
    if (remember && savedEmail.isNotEmpty) {
      setState(() {
        _remember = true;
        _emailCtrl.text = savedEmail;
      });
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final email = v.trim();
    final emailRegex = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  Future<void> _onSubmit() async {
    // validasi form
    if (!_formKey.currentState!.validate()) return;

    // mulai loading
    setState(() => _loading = true);

    // simulasi proses login (ganti dengan panggilan API asli)
    await Future.delayed(const Duration(seconds: 2));

    // selesai simulasi
    setState(() => _loading = false);

    // jika remember dicentang -> simpan email & flag
    final prefs = await SharedPreferences.getInstance();
    if (_remember) {
      await prefs.setBool(_prefRememberKey, true);
      await prefs.setString(_prefEmailKey, _emailCtrl.text.trim());
    } else {
      await prefs.setBool(_prefRememberKey, false);
      await prefs.remove(_prefEmailKey);
    }

    // sukses — pindah ke HomePage
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(email: _emailCtrl.text.trim())),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // kalau loading true, kita bisa tampilkan barrier sederhana
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FlutterLogo(size: 72),
                            const SizedBox(height: 12),
                            const Text('Masuk ke Aplikasi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            const Text('Silakan masukkan email dan password Anda.'),
                            const SizedBox(height: 18),

                            // Email
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 12),

                            // Password + show/hide
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 12),

                            // Remember me + forgot password link
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (v) => setState(() => _remember = v ?? false),
                                ),
                                const SizedBox(width: 6),
                                const Text('Remember me'),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // contoh: tampilkan dialog reset password (dummy)
                                    showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                        title: const Text('Lupa Password'),
                                        content: const Text('Fitur reset password belum diimplementasikan pada demo ini.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text('Lupa password?'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Tombol submit (tampilkan loading di dalamnya)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _onSubmit,
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                child: _loading
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Sedang masuk...'),
                                  ],
                                )
                                    : const Text('Masuk'),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // info kecil
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Belum punya akun? Daftar di kampus :)')));
                              },
                              child: const Text('Belum punya akun? Daftar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // semi-transparent loading overlay (opsional)
          if (_loading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
        ],
      ),
    );
  }
}

/// HomePage sederhana setelah login
class HomePage extends StatelessWidget {
  final String email;
  const HomePage({super.key, required this.email});

  Future<void> _logout(BuildContext context) async {
    // contoh: saat logout kita bisa menghapus saved email jika user memilih "forget"
    final prefs = await SharedPreferences.getInstance();
    // di demo ini kita tidak otomatis hapus saved email — tapi beri opsi:
    final shouldForget = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Ingin menghapus data Remember me dari perangkat?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Jangan hapus')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (shouldForget == true) {
      await prefs.remove(_LoginKeys.prefEmail);
      await prefs.setBool(_LoginKeys.prefRemember, false);
    }

    // kembali ke login
    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Text('Selamat datang, $email', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

/// kecil: kunci pref agar tidak tersebar string literal di banyak tempat
class _LoginKeys {
  static const prefEmail = 'saved_email';
  static const prefRemember = 'remember_me';
}
