import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NexedApp());
}

class NexedApp extends StatelessWidget {
  const NexedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexedAI Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070A0F),
        fontFamily: 'sans-serif',
      ),
      home: const MobileFrameWrapper(),
    );
  }
}

// ============================================================================
// 1. MOBILE FRAME WRAPPER (PENGATUR AUTENTIKASI & FRAME PONSEl WEB/DESKTOP)
// ============================================================================
class MobileFrameWrapper extends StatefulWidget {
  const MobileFrameWrapper({super.key});

  @override
  State<MobileFrameWrapper> createState() => _MobileFrameWrapperState();
}

class _MobileFrameWrapperState extends State<MobileFrameWrapper> {
  // Status Autentikasi Aplikasi
  bool _isLoggedIn = false;
  bool _isRegistering = false; // Toggle antara Login & Register

  // Data Profil Pengguna Aktif
  String _userName = 'Ahmad Fauzi';
  String _userNim = 'V3922001';
  String _userRole = 'Mahasiswa';

  // Indeks Navigasi Tab Utama
  int _currentIndex = 0;

  void _onLogin(String email, String password) {
    setState(() {
      _isLoggedIn = true;
      _userNim = email;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('👋 Selamat datang di NexedAI, $_userName!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onRegister(String name, String email, String password, String role) {
    setState(() {
      _userName = name;
      _userNim = email;
      _userRole = role;
      _isLoggedIn = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Akun $role berhasil didaftarkan! Selamat belajar, $name.'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
      _isRegistering = false;
      _currentIndex = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔒 Anda telah berhasil keluar dari akun.'),
        backgroundColor: Color(0xFF38BDF8),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isMobileScreen = screenWidth <= 480;

        // Konten Inti Aplikasi Berdasarkan Status Login
        Widget innerContent;

        if (!_isLoggedIn) {
          // ALUR SEBELUM LOGIN (AUTENTIKASI)
          if (_isRegistering) {
            innerContent = RegisterScreen(
              onRegister: _onRegister,
              onNavigateToLogin: () => setState(() => _isRegistering = false),
            );
          } else {
            innerContent = LoginScreen(
              onLogin: _onLogin,
              onNavigateToRegister: () => setState(() => _isRegistering = true),
            );
          }
        } else {
          // ALUR SETELAH LOGIN (DASHBOARD UTAMA DENGAN BOTTOM NAV)
          innerContent = Scaffold(
            backgroundColor: const Color(0xFF0B0F17),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Dynamic Island / Speaker Pill Ponsel (Mode Desktop Frame)
                  if (!isMobileScreen)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 6),
                        width: 80,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                  // Konten Halaman Aktif Sesuai Tab
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        DashboardTab(
                          userName: _userName,
                          onNavigateToTab: _onTabTapped,
                        ),
                        RoadmapTab(onNavigateToTab: _onTabTapped),
                        const ActiveRecallTab(),
                        AccountTab(
                          userName: _userName,
                          userNim: _userNim,
                          userRole: _userRole,
                          onLogout: _onLogout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        }

        // Jika dibuka langsung di smartphone asli / layar sempit
        if (isMobileScreen) {
          return innerContent;
        }

        // Tampilan Desktop Browser: Dibungkus container smartphone di tengah layar
        final frameHeight = screenHeight > 920 ? 860.0 : (screenHeight - 32.0).clamp(580.0, 860.0);

        return Scaffold(
          backgroundColor: const Color(0xFF070A0F),
          body: Center(
            child: Container(
              width: 420,
              height: frameHeight,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0B0F17),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 35,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: innerContent,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1424),
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Beranda',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.map_outlined,
                label: 'Roadmap',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.article_outlined,
                label: 'Kuis AI',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Akun',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = _currentIndex == index;

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              const SizedBox(height: 7),
            Icon(
              icon,
              color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF38BDF8) : const Color(0xFF64748B),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. HALAMAN LOGIN (AUTENTIKASI MASUK)
// ============================================================================
class LoginScreen extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final VoidCallback onNavigateToRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onNavigateToRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'V3922001');
  final _passwordController = TextEditingController(text: 'secret123');
  bool _isPasswordVisible = false;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _errorMessage = 'Harap isi NIM/Email dan Kata Sandi terlebih dahulu.';
      });
      return;
    }

    setState(() => _errorMessage = null);
    widget.onLogin(email, pass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F17),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // LOGO & BADGE NEXEDAI
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFF0B0F17),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(text: 'Nexed', style: TextStyle(color: Colors.white)),
                          TextSpan(text: 'AI', style: TextStyle(color: Color(0xFF38BDF8))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155), width: 0.8),
                      ),
                      child: const Text(
                        'D3 TI SV UNS',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // HEADER TEKS
              const Text(
                'Selamat Datang Kembali',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Masuk untuk mengakses materi kurikulum kognitif dan simulasi AI adaptifmu.',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12.5,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // PESAN ERROR (JIKA ADA)
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFFEF4444), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // INPUT FIELD: EMAIL / NIM
              const Text(
                'EMAIL ATAU NIM',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
                ),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined, color: Color(0xFF38BDF8), size: 20),
                    hintText: 'Contoh: V3922001',
                    hintStyle: TextStyle(color: Color(0xFF475569), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // INPUT FIELD: KATA SANDI
              const Text(
                'KATA SANDI',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF38BDF8), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF64748B),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: 'Masukkan kata sandi',
                    hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // REMEMBER ME & LUPA KATA SANDI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    borderRadius: BorderRadius.circular(6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF38BDF8),
                            checkColor: const Color(0xFF0B0F17),
                            side: const BorderSide(color: Color(0xFF334155), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) => setState(() => _rememberMe = val ?? true),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Ingat Saya',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Hubungi admin prodi D3 TI SV UNS untuk reset password NIM.'),
                        ),
                      );
                    },
                    child: const Text(
                      'Lupa Sandi?',
                      style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // TOMBOL MASUK AKUN
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _handleLogin,
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text(
                    'Masuk Akun',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.2),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0B0F17),
                    elevation: 4,
                    shadowColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // DEMO QUICK HINT CHIP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.tips_and_updates_outlined, color: Color(0xFFF59E0B), size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Demo D3 TI: NIM "V3922001" terisi otomatis. Klik tombol di atas untuk langsung masuk.',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10.5, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // TAUTAN PINDAH KE REGISTER
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                    ),
                    InkWell(
                      onTap: widget.onNavigateToRegister,
                      child: const Text(
                        'Daftar sekarang',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. HALAMAN REGISTER (PENDAFTARAN AKUN BARU)
// ============================================================================
class RegisterScreen extends StatefulWidget {
  final Function(String name, String email, String password, String role) onRegister;
  final VoidCallback onNavigateToLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onNavigateToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController(text: 'Ahmad Fauzi');
  final _emailController = TextEditingController(text: 'V3922001');
  final _passwordController = TextEditingController(text: 'secret123');
  bool _isPasswordVisible = false;
  String _selectedRole = 'Mahasiswa';
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() {
        _errorMessage = 'Semua field wajib diisi untuk pendaftaran kurikulum.';
      });
      return;
    }

    if (pass.length < 6) {
      setState(() {
        _errorMessage = 'Kata sandi minimal 6 karakter.';
      });
      return;
    }

    setState(() => _errorMessage = null);
    widget.onRegister(name, email, pass, _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F17),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // HEADER KECIL & TOMBOL KEMBALI
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70, size: 22),
                    onPressed: widget.onNavigateToLogin,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Pendaftaran Akun Baru',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // SUBTITLE PENDAFTARAN
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded, color: Color(0xFF38BDF8), size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kurikulum D3 TI SV UNS',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Akses jalur kurikulum adaptif & active recall berbasis AI.',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ERROR MESSAGE
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFFEF4444), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // PILIHAN ROLE (MAHASISWA / DOSEN)
              const Text(
                'PERAN AKADEMIK',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleSelector(
                      role: 'Mahasiswa',
                      icon: Icons.person_outline_rounded,
                      subtitle: 'Pelajar Terdaftar',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildRoleSelector(
                      role: 'Dosen',
                      icon: Icons.psychology_outlined,
                      subtitle: 'Instruktur & Asisten',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // INPUT: NAMA LENGKAP
              const Text(
                'NAMA LENGKAP',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded, color: Color(0xFF38BDF8), size: 20),
                    hintText: 'Contoh: Ahmad Fauzi',
                    hintStyle: TextStyle(color: Color(0xFF475569), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // INPUT: EMAIL / NIM
              const Text(
                'EMAIL ATAU NIM KAMPUS',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
                ),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined, color: Color(0xFF38BDF8), size: 20),
                    hintText: 'Contoh: V3922001',
                    hintStyle: TextStyle(color: Color(0xFF475569), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // INPUT: KATA SANDI
              const Text(
                'KATA SANDI',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF38BDF8), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF64748B),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: 'Minimal 6 karakter',
                    hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // TOMBOL UTAMA: MULAI BELAJAR GRATIS
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _handleRegister,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text(
                    'Mulai Belajar Gratis',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.2),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0B0F17),
                    elevation: 4,
                    shadowColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TAUTAN KEMBALI KE LOGIN
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                    ),
                    InkWell(
                      onTap: widget.onNavigateToLogin,
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector({
    required String role,
    required IconData icon,
    required String subtitle,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7).withValues(alpha: 0.18) : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF64748B),
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. TAB BERANDA / DASHBOARD (PERSIS SCREENSHOT MOCKUP HP)
// ============================================================================
class DashboardTab extends StatelessWidget {
  final String userName;
  final Function(int) onNavigateToTab;

  const DashboardTab({
    super.key,
    this.userName = 'Ahmad Fauzi',
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP BAR: LOGO NEXED AI + D3 TI SV UNS + LONCENG NOTIFIKASI
          _buildTopBar(context),
          const SizedBox(height: 18),

          // 2. KARTU LEVEL 10 • MASTER (350 / 500 XP)
          _buildLevelCard(context),
          const SizedBox(height: 12),

          // 3. KARTU MODUL AKTIF (LOOPING & ITERASI)
          _buildActiveModuleCard(context),
          const SizedBox(height: 22),

          // 4. JUDUL SEKSI "AKSI CEPAT AI"
          const Text(
            'Aksi Cepat AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 12),

          // 5. GRID 2X2 KARTU AKSI CEPAT
          _buildQuickActionsGrid(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Ikon Petir Bersudut Biru
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Color(0xFF0B0F17),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            // Brand NexedAI
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                children: [
                  TextSpan(
                    text: 'Nexed',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(color: Color(0xFF38BDF8)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badge Khusus "D3 TI SV UNS"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF334155),
                  width: 0.8,
                ),
              ),
              child: const Text(
                'D3 TI SV UNS',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        // Lonceng Notifikasi
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF131B2E),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF38BDF8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Color(0xFFF59E0B),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Level 10 • Master',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '350',
                      style: TextStyle(color: Color(0xFF38BDF8)),
                    ),
                    TextSpan(
                      text: ' / 500 XP',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 5.5,
              child: LinearProgressIndicator(
                value: 0.70,
                backgroundColor: const Color(0xFF1E293B),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveModuleCard(BuildContext context) {
    return InkWell(
      onTap: () => onNavigateToTab(1),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Looping & Iterasi: Optimasi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tuntas 3/3 Tantangan Algoritma',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 5.5,
                child: LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: const Color(0xFF1E293B),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        // 1. Upload Modul (PDF / DOCX)
        _buildActionCard(
          icon: Icons.description_rounded,
          iconColor: const Color(0xFF3B82F6),
          iconBg: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
          title: 'Upload Modul',
          subtitle: '(PDF / DOCX)',
          onTap: () => _showUploadModal(context),
        ),

        // 2. Simulasi AI (Active Recall)
        _buildActionCard(
          icon: Icons.psychology_rounded,
          iconColor: const Color(0xFF06B6D4),
          iconBg: const Color(0xFF0891B2).withValues(alpha: 0.25),
          title: 'Simulasi AI',
          subtitle: '(Active Recall)',
          onTap: () => onNavigateToTab(2),
        ),

        // 3. Tes Diagnostik (Adaptif)
        _buildActionCard(
          icon: Icons.alt_route_rounded,
          iconColor: const Color(0xFFA855F7),
          iconBg: const Color(0xFF7E22CE).withValues(alpha: 0.25),
          title: 'Tes Diagnostik',
          subtitle: '(Adaptif)',
          onTap: () => onNavigateToTab(1),
        ),

        // 4. Tutor Kognitif (Tanya Jawab)
        _buildActionCard(
          icon: Icons.smart_toy_rounded,
          iconColor: const Color(0xFF6366F1),
          iconBg: const Color(0xFF4338CA).withValues(alpha: 0.25),
          title: 'Tutor Kognitif',
          subtitle: '(Tanya Jawab)',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tutor AI: "Halo! Ada materi kuliah algoritma yang ingin kamu tanyakan?"'),
                duration: Duration(seconds: 3),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const UploadModuleModal(),
    );
  }
}

// ============================================================================
// 4B. MODAL UPLOAD MODUL PERKULIAHAN (INTERAKTIF & BEBAS OVERFLOW)
// ============================================================================
class UploadModuleModal extends StatefulWidget {
  const UploadModuleModal({super.key});

  @override
  State<UploadModuleModal> createState() => _UploadModuleModalState();
}

class _UploadModuleModalState extends State<UploadModuleModal> {
  String? _selectedFileName;
  String? _selectedFileSize;
  bool _isProcessing = false;

  void _simulatePickFile() {
    setState(() {
      _selectedFileName = 'Modul_Struktur_Data_2026.pdf';
      _selectedFileSize = '2.4 MB';
    });
  }

  void _removeFile() {
    setState(() {
      _selectedFileName = null;
      _selectedFileSize = null;
    });
  }

  void _processModuleWithAi() {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Harap pilih file dokumen modul PDF/DOCX terlebih dahulu.'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulasi loading AI analisis dokumen selama 2 detik
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Modul berhasil diekstrak ke grafik kurikulum adaptif!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF131B2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            top: 14,
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Bar Atas
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upload Modul Perkuliahan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                    onPressed: _isProcessing ? null : () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Ekstrak materi kuliah secara otomatis ke dalam grafik kurikulum adaptif.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 18),

              // Kotak Area Pemilihan File (Interaktif dengan InkWell)
              if (_selectedFileName == null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isProcessing ? null : _simulatePickFile,
                    borderRadius: BorderRadius.circular(16),
                    splashColor: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    highlightColor: const Color(0xFF38BDF8).withValues(alpha: 0.08),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cloud_upload_outlined,
                              color: Color(0xFF38BDF8),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Pilih File PDF atau DOCX',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Klik di sini untuk simulasi pemilihan dokumen modul',
                            style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Maksimal ukuran 25MB • Kurikulum SV UNS',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                // Tampilan File yang Berhasil Terpilih
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Color(0xFF10B981),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF10B981),
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'File Terpilih',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _selectedFileName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$_selectedFileSize • Siap diekstrak',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isProcessing)
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 20),
                          tooltip: 'Hapus file',
                          onPressed: _removeFile,
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Tombol Utama: "Proses Modul dengan AI"
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processModuleWithAi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: const Color(0xFF0B0F17),
                    disabledBackgroundColor: const Color(0xFF1E293B),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Menganalisis Dokumen AI...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.auto_awesome, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Proses Modul dengan AI',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 5. TAB ROADMAP (ALUR KURIKULUM BERTINGKAT & MODAL VIDEO PEMBELAJARAN)
// ============================================================================
class RoadmapTab extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const RoadmapTab({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Roadmap
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF131B2E), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Semester 1 • Wajib',
                        style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      '3/5 Modul Tuntas',
                      style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Algoritma & Pemrograman',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jalur belajar adaptif terstruktur dari logika dasar hingga analisis kompleksitas Big-O.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Alur Kurikulum Kognitif',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),

          // Daftar Node Alur Vertikal Bertingkat
          _buildRoadmapNode(
            context: context,
            stepNumber: '1',
            title: 'Sintaks Dasar, Variabel & I/O',
            description: 'Tipe data primitif, alokasi memori stack vs heap, dan stream buffer input/output.',
            status: 'Selesai',
            statusColor: const Color(0xFF10B981),
            xpReward: '+100 XP',
            isCurrent: false,
            isLocked: false,
            isLast: false,
          ),
          _buildRoadmapNode(
            context: context,
            stepNumber: '2',
            title: 'Struktur Percabangan (If-Else & Switch)',
            description: 'Evaluasi boolean algebra, tabel kebenaran logika kondisional, dan jump tables.',
            status: 'Selesai',
            statusColor: const Color(0xFF10B981),
            xpReward: '+150 XP',
            isCurrent: false,
            isLocked: false,
            isLast: false,
          ),
          _buildRoadmapNode(
            context: context,
            stepNumber: '3',
            title: 'Looping & Iterasi (For vs While)',
            description: 'Mekanisme loop counters, invariant perulangan, dan optimasi early termination.',
            status: 'Sedang Belajar',
            statusColor: const Color(0xFF38BDF8),
            xpReward: '+180 XP',
            isCurrent: true,
            isLocked: false,
            isLast: false,
            showActions: true,
          ),
          _buildRoadmapNode(
            context: context,
            stepNumber: '4',
            title: 'Fungsi, Prosedur & Rekursi',
            description: 'Call stack frames, parameter passing, base case, dan stack overflow hazard.',
            status: 'Terkunci',
            statusColor: const Color(0xFF64748B),
            xpReward: '+250 XP',
            isCurrent: false,
            isLocked: true,
            isLast: false,
          ),
          _buildRoadmapNode(
            context: context,
            stepNumber: '5',
            title: 'Kompleksitas Waktu & Big-O Notation',
            description: 'Analisis asymptotic runtime O(1), O(log n), O(n), hingga O(n²) tradeoffs.',
            status: 'Terkunci',
            statusColor: const Color(0xFF64748B),
            xpReward: '+300 XP',
            isCurrent: false,
            isLocked: true,
            isLast: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRoadmapNode({
    required BuildContext context,
    required String stepNumber,
    required String title,
    required String description,
    required String status,
    required Color statusColor,
    required String xpReward,
    required bool isCurrent,
    required bool isLocked,
    required bool isLast,
    bool showActions = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Indikator Vertikal & Garis
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFF38BDF8)
                        : (isLocked ? const Color(0xFF1E293B) : const Color(0xFF10B981)),
                    shape: BoxShape.circle,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isLocked
                        ? const Icon(Icons.lock_rounded, color: Color(0xFF64748B), size: 14)
                        : (isCurrent
                            ? Text(stepNumber,
                                style: const TextStyle(
                                    color: Color(0xFF0B0F17), fontWeight: FontWeight.bold, fontSize: 13))
                            : const Icon(Icons.check_rounded, color: Colors.white, size: 16)),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isLocked ? const Color(0xFF1E293B) : const Color(0xFF334155),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Kartu Konten Modul
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0xFF131F37) : const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCurrent ? const Color(0xFF38BDF8) : const Color(0xFF1E293B),
                    width: isCurrent ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          xpReward,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: isLocked ? const Color(0xFF64748B) : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.4),
                    ),

                    if (showActions) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Tombol Putar Video Kuliah
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showVideoModal(context, title);
                                },
                                icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
                                label: const Text('Tonton Video', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF38BDF8),
                                  foregroundColor: const Color(0xFF0B0F17),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Tombol Kuis Evaluasi
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: OutlinedButton.icon(
                                onPressed: () => onNavigateToTab(2),
                                icon: const Icon(Icons.quiz_rounded, size: 16),
                                label: const Text('Kuis Evaluasi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Color(0xFF334155)),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoModal(BuildContext context, String moduleTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VideoLecturePlayerModal(moduleTitle: moduleTitle),
    );
  }
}

// ============================================================================
// 6. TAB KUIS AI / ACTIVE RECALL (RESPON INSTAN <50ms & PENJELASAN AI)
// ============================================================================
class ActiveRecallTab extends StatefulWidget {
  const ActiveRecallTab({super.key});

  @override
  State<ActiveRecallTab> createState() => _ActiveRecallTabState();
}

class _ActiveRecallTabState extends State<ActiveRecallTab> {
  int _questionIndex = 0;
  int? _selectedOption;
  bool _hasAnswered = false;
  int _scoreXp = 0;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'Manakah perbedaan mendasar antara perulangan "for" dan "while"?',
      'options': [
        'For hanya untuk tipe integer, while hanya untuk boolean.',
        'For digunakan saat jumlah iterasi pasti, while saat batas iterasi bergantung kondisi dinamis.',
        'While mengeksekusi instruksi lebih cepat dibanding for di CPU.',
        'For tidak mendukung klausa break.',
      ],
      'correct': 1,
      'explanation': 'For loop ideal untuk putaran terhitung (counted loop). Sedangkan While loop mengevaluasi syarat boolean dinamis di setiap awal iterasi hingga kondisi menjadi false.',
    },
    {
      'question': 'Apa yang terjadi jika fungsi rekursif tidak memiliki "Base Case"?',
      'options': [
        'Program otomatis mengonversi kode menjadi for loop.',
        'Nilai kembalian fungsi menjadi 0.',
        'Terjadi Stack Overflow karena frame fungsi menumpuk tanpa henti di memori.',
        'Kompilasi langsung memunculkan syntax error.',
      ],
      'correct': 2,
      'explanation': 'Base Case adalah syarat mutlak penghenti rekursi. Tanpa Base Case, Call Stack akan kehabisan ruang memori dan memicu crash Stack Overflow.',
    },
  ];

  void _selectOption(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedOption = index;
      _hasAnswered = true;
      if (index == _quizQuestions[_questionIndex]['correct']) {
        _scoreXp += 30;
      }
    });
  }

  void _nextQuestion() {
    if (_questionIndex < _quizQuestions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedOption = null;
        _hasAnswered = false;
      });
    } else {
      // Selesai kuis
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Sesi Kuis Selesai! Kamu mendapatkan +$_scoreXp XP!'),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() {
        _questionIndex = 0;
        _selectedOption = null;
        _hasAnswered = false;
        _scoreXp = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _quizQuestions[_questionIndex];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Kuis & XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${_questionIndex + 1} dari ${_quizQuestions.length}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+$_scoreXp XP',
                      style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Kotak Pertanyaan
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Evaluasi Kognitif Adaptif',
                    style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  q['question'],
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4 Opsi Jawaban (Respon Warna Langsung <50ms)
          ...List.generate((q['options'] as List).length, (index) {
            final optionText = q['options'][index];
            final isSelected = _selectedOption == index;
            final isCorrect = q['correct'] == index;

            Color bgColor = const Color(0xFF131B2E);
            Color borderColor = const Color(0xFF1E293B);
            Color textColor = Colors.white;

            if (_hasAnswered) {
              if (isCorrect) {
                bgColor = const Color(0xFF10B981).withValues(alpha: 0.2);
                borderColor = const Color(0xFF10B981);
                textColor = const Color(0xFF34D399);
              } else if (isSelected && !isCorrect) {
                bgColor = const Color(0xFFEF4444).withValues(alpha: 0.2);
                borderColor = const Color(0xFFEF4444);
                textColor = const Color(0xFFF87171);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                onTap: () => _selectOption(index),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: borderColor),
                        ),
                        child: Center(
                          child: Text(
                            ['A', 'B', 'C', 'D'][index],
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(color: textColor, fontSize: 12, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Kotak Penjelasan Rasional AI
          if (_hasAnswered) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA855F7).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Color(0xFFA855F7), size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Penjelasan Rasional AI',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q['explanation'],
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Soal Berikutnya
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  _questionIndex == _quizQuestions.length - 1 ? 'Selesaikan Kuis' : 'Pertanyaan Berikutnya',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF0B0F17),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// 7. TAB AKUN & PROFIL MAHASISWA (LENGKAP DENGAN LOGOUT KEMBALI KE LOGIN)
// ============================================================================
class AccountTab extends StatelessWidget {
  final String userName;
  final String userNim;
  final String userRole;
  final VoidCallback onLogout;

  const AccountTab({
    super.key,
    required this.userName,
    required this.userNim,
    required this.userRole,
    required this.onLogout,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'AF';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Avatar & Inisial
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getInitials(userName),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            userName,
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'NIM: $userNim • $userRole D3 TI SV UNS',
            style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),

          // Statistik Belajar 3 Kotak
          Row(
            children: [
              _buildStatBox('7 Hari', 'Streak Api', Icons.local_fire_department_rounded, const Color(0xFFFF7A00)),
              const SizedBox(width: 10),
              _buildStatBox('2,850', 'Total XP', Icons.bolt_rounded, const Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              _buildStatBox('#3', 'Peringkat', Icons.emoji_events_rounded, const Color(0xFF38BDF8)),
            ],
          ),
          const SizedBox(height: 20),

          // Menu Opsi Profil
          _buildMenuTile(
            icon: Icons.military_tech_rounded,
            title: 'Koleksi Lencana Prestasi',
            subtitle: '3 dari 6 Lencana Terbuka',
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.history_rounded,
            title: 'Riwayat Kuis Kognitif',
            subtitle: 'Akurasi Rata-rata 85%',
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.school_outlined,
            title: 'Kurikulum Program Studi',
            subtitle: 'Teknik Informatika SV UNS',
            onTap: () {},
          ),
          _buildMenuTile(
            icon: Icons.logout_rounded,
            title: 'Keluar Akun',
            subtitle: 'Kembali ke halaman autentikasi',
            isDestructive: true,
            onTap: onLogout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(
          icon,
          color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF38BDF8),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? const Color(0xFFEF4444) : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 12),
      ),
    );
  }
}

// ============================================================================
// 8. MODAL PEMUTAR VIDEO DENGAN TIMER REAL-TIME (DIPUTAR DARI AWAL - AKHIR)
// ============================================================================
class VideoLecturePlayerModal extends StatefulWidget {
  final String moduleTitle;

  const VideoLecturePlayerModal({super.key, required this.moduleTitle});

  @override
  State<VideoLecturePlayerModal> createState() => _VideoLecturePlayerModalState();
}

class _VideoLecturePlayerModalState extends State<VideoLecturePlayerModal> {
  Timer? _timer;
  bool _isPlaying = true;
  int _currentSeconds = 0;
  final int _totalSeconds = 630; // 10 menit 30 detik (630 detik)

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying) return;
      if (_currentSeconds < _totalSeconds) {
        setState(() {
          _currentSeconds++;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
        timer.cancel();
      }
    });
  }

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentSeconds / _totalSeconds).clamp(0.0, 1.0);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0B0F17),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Video Kuliah Penunjang',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Player Surface dengan Timer Berjalan
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.smart_display_rounded,
                        color: _isPlaying ? const Color(0xFF38BDF8) : Colors.white30,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isPlaying ? 'Memutar Materi Kuliah...' : 'Jeda (Paused)',
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                // Controls Bar Bawah
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.black.withValues(alpha: 0.8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3.0,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                            activeTrackColor: const Color(0xFF38BDF8),
                            thumbColor: const Color(0xFF38BDF8),
                          ),
                          child: Slider(
                            value: progress,
                            onChanged: (val) {
                              setState(() {
                                _currentSeconds = (val * _totalSeconds).round();
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_formatTime(_currentSeconds)} / ${_formatTime(_totalSeconds)}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      _currentSeconds = 0;
                                      _isPlaying = true;
                                    });
                                    _startTimer();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: const Color(0xFF38BDF8),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPlaying = !_isPlaying;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ringkasan Transkrip Video
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.moduleTitle,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Instruktur: Dr. Aris Sudrajat • Dosen Komputasi',
                    style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Poin Penting Kuliah:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '1. For Loop optimal untuk traversing array dengan batas indeks terukur pasti O(n).\n'
                    '2. While Loop mengevaluasi kondisi dinamis sebelum memasuki blok kode.\n'
                    '3. Gunakan kata kunci break untuk menghentikan iterasi seawal mungkin demi efisiensi siklus CPU.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
