import 'dart:async';
import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NexedApp());
}

class NexedApp extends StatelessWidget {
  const NexedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'NexedAI Mobile',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: const MobileFrameWrapper(),
        );
      },
    );
  }
}

// ============================================================================
// 1. MOBILE FRAME WRAPPER (PENGATUR AUTENTIKASI & FRAME PONSEL WEB/DESKTOP)
// ============================================================================
class MobileFrameWrapper extends StatefulWidget {
  const MobileFrameWrapper({super.key});

  @override
  State<MobileFrameWrapper> createState() => _MobileFrameWrapperState();
}

class _MobileFrameWrapperState extends State<MobileFrameWrapper> {
  bool _isLoggedIn = false;
  bool _isRegistering = false;

  String _userName = 'Muhammad Hariz';
  String _userNim = 'V3922001';
  String _userRole = 'Mahasiswa';

  int _currentIndex = 0;

  void _onLogin(String email, String password, [String? roleOverride]) {
    setState(() {
      _isLoggedIn = true;
      _userNim = email;
      if (roleOverride != null) {
        _userRole = roleOverride;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selamat datang di NexedAI, $_userName!'),
        backgroundColor: AppColors.successGreen,
        duration: const Duration(seconds: 2),
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
        content: Text(
          'Akun $role berhasil didaftarkan! Selamat belajar, $name.',
        ),
        backgroundColor: AppColors.successGreen,
        duration: const Duration(seconds: 2),
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
        content: Text('Anda telah keluar dari sesi akun.'),
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
    final isDark = AppColors.isDark(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isMobileScreen = screenWidth <= 480;

        Widget innerContent;

        if (!_isLoggedIn) {
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
          innerContent = Scaffold(
            backgroundColor: AppColors.bg(isDark),
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  if (!isMobileScreen)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 4),
                        width: 72,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderColor(isDark),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  // Top Ultra-Clean SaaS Header Bar (Sticky di semua tab)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: _buildGlobalSaasHeader(isDark),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: [
                        DashboardTab(
                          userName: _userName,
                          userRole: _userRole,
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
            bottomNavigationBar: _buildFloatingPillNavigationBar(isDark),
          );
        }

        if (isMobileScreen) {
          return innerContent;
        }

        final frameHeight = screenHeight > 920
            ? 860.0
            : (screenHeight - 32.0).clamp(580.0, 860.0);

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF05080F)
              : const Color(0xFFF1F5F9),
          body: Center(
            child: Container(
              width: 420,
              height: frameHeight,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.bg(isDark),
                borderRadius: BorderRadius.circular(38),
                border: Border.all(
                  color: AppColors.borderColor(isDark),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(isDark ? 0.55 : 0.08),
                    blurRadius: 36,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: innerContent,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Header AppBar Global Bergaya Web NexedAI (Logo + Pill Kampus + Tombol Toggle Tema + Notifikasi)
  Widget _buildGlobalSaasHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.borderColor(isDark),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NexedLogoMark(size: 30),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15.5,
                      color: AppColors.textPrimary(isDark),
                      letterSpacing: -0.4,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Nexed',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: 'AI',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.borderColor(isDark),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'D3 TI SV UNS',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NexedThemeToggleButton(),
              const SizedBox(width: 6),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notifikasi: Target praktikum minggu ini telah diperbarui.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.borderColor(isDark),
                        width: 1.0,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textPrimary(isDark),
                          size: 18,
                        ),
                        Positioned(
                          right: 9,
                          top: 9,
                          child: Container(
                            width: 6.5,
                            height: 6.5,
                            decoration: const BoxDecoration(
                              color: AppColors.electricSky,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Floating Pill Navigation Bar Modern
  Widget _buildFloatingPillNavigationBar(bool isDark) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: AppColors.surface(isDark).withOpacity(0.96),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.borderColor(isDark),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                isDark: isDark,
                index: 0,
                icon: Icons.grid_view_rounded,
                label: 'Beranda',
              ),
              _buildNavItem(
                isDark: isDark,
                index: 1,
                icon: Icons.account_tree_rounded,
                label: 'Peta Belajar',
              ),
              _buildNavItem(
                isDark: isDark,
                index: 2,
                icon: Icons.quiz_rounded,
                label: 'Evaluasi AI',
              ),
              _buildNavItem(
                isDark: isDark,
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required bool isDark,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = _currentIndex == index;
    final activeBg = AppColors.buttonPrimary(isDark);
    final activeFg = AppColors.buttonText(isDark);
    final inactiveFg = AppColors.textMutedColor(isDark);

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeFg : inactiveFg,
              size: 18,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: activeFg,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. HALAMAN LOGIN (IDENTIK WEB NEXEDAI: 1-KLIK ROLE PRESETS + MINIMALIST SAAS)
// ============================================================================
class LoginScreen extends StatefulWidget {
  final Function(String email, String password, [String? roleOverride]) onLogin;
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
  final _emailController = TextEditingController(text: 'mahasiswa@nexed.ai');
  final _passwordController = TextEditingController(text: 'demo12345');
  bool _isPasswordVisible = false;
  String _selectedQuickRole = 'Mahasiswa';
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleQuickDemo(String demoEmail, String role) {
    setState(() {
      _selectedQuickRole = role;
      _emailController.text = demoEmail;
      _passwordController.text = 'demo12345';
      _errorMessage = null;
    });
    widget.onLogin(demoEmail, 'demo12345', role);
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _errorMessage = 'Harap isi Email/NIM dan Kata Sandi terlebih dahulu.';
      });
      return;
    }

    setState(() => _errorMessage = null);
    widget.onLogin(email, pass, _selectedQuickRole);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar Login dengan Brand & Theme Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const NexedLogoMark(size: 30),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary(isDark),
                            letterSpacing: -0.4,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Nexed',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: 'AI',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const NexedThemeToggleButton(),
                ],
              ),
              const SizedBox(height: 22),

              // Main Auth Bento Card (Identik src/views/Login.tsx)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.borderColor(isDark),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg(isDark),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.borderColor(isDark),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'ADAPTIVE LEARNING • COGNITIVE AI',
                          style: TextStyle(
                            color: AppColors.textSecondary(isDark),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Masuk ke platform pembelajaran adaptif NEXED AI D3 TI SV UNS',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 12,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // 1-Click Role Login Presets (Persis Web Login.tsx)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bg(isDark),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.borderColor(isDark),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PILIH CEPAT ROLE:',
                                style: TextStyle(
                                  color: AppColors.textSecondary(isDark),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface(isDark),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: AppColors.borderColor(isDark),
                                  ),
                                ),
                                child: Text(
                                  '1-Klik Masuk',
                                  style: TextStyle(
                                    color: AppColors.textPrimary(isDark),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickRoleButton(
                                  isDark: isDark,
                                  role: 'Mahasiswa',
                                  email: 'mahasiswa@nexed.ai',
                                  icon: Icons.school_outlined,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildQuickRoleButton(
                                  isDark: isDark,
                                  role: 'Dosen',
                                  email: 'dosen@nexed.ai',
                                  icon: Icons.menu_book_rounded,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildQuickRoleButton(
                                  isDark: isDark,
                                  role: 'Admin',
                                  email: 'admin@nexed.ai',
                                  icon: Icons.verified_user_outlined,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: AppColors.error.withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    Text(
                      'EMAIL AKADEMIK ATAU NIM',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 13.5,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: AppColors.textSecondary(isDark),
                          size: 18,
                        ),
                        hintText: 'mahasiswa@nexed.ai',
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'KATA SANDI',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 13.5,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.textSecondary(isDark),
                          size: 18,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMutedColor(isDark),
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        hintText: 'Masukkan kata sandi',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Hitam Solid (Light) / Putih Solid (Dark)
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary(isDark),
                          foregroundColor: AppColors.buttonText(isDark),
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Masuk ke Portal',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.buttonText(isDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Belum memiliki akun praktikan? ',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 12.5,
                      ),
                    ),
                    InkWell(
                      onTap: widget.onNavigateToRegister,
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: AppColors.textPrimary(isDark),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickRoleButton({
    required bool isDark,
    required String role,
    required String email,
    required IconData icon,
  }) {
    final isSelected = _selectedQuickRole == role;
    final bg = isSelected
        ? AppColors.buttonPrimary(isDark)
        : AppColors.surface(isDark);
    final fg = isSelected
        ? AppColors.buttonText(isDark)
        : AppColors.textPrimary(isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleQuickDemo(email, role),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.buttonPrimary(isDark)
                  : AppColors.borderColor(isDark),
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  color: fg,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
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
// 3. HALAMAN REGISTER (ULTRA-CLEAN MINIMALIST SAAS)
// ============================================================================
class RegisterScreen extends StatefulWidget {
  final Function(String name, String email, String password, String role)
      onRegister;
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final String _selectedRole = 'Mahasiswa';
  bool _isPasswordVisible = false;
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
        _errorMessage = 'Semua kolom wajib diisi untuk membuat akun baru.';
      });
      return;
    }

    setState(() => _errorMessage = null);
    widget.onRegister(name, email, pass, _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onNavigateToLogin,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg(isDark),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.borderColor(isDark),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_rounded,
                              size: 15,
                              color: AppColors.textPrimary(isDark),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                color: AppColors.textPrimary(isDark),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const NexedThemeToggleButton(),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.borderColor(isDark)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Registrasi Akun Akademik',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bergabung dengan ekosistem pembelajaran adaptif D3 TI SV UNS.',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Text(
                      'NAMA LENGKAP',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 13.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Muhammad Hariz',
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'EMAIL ATAU NIM',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 13.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: V3922001',
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'KATA SANDI',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 13.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Minimal 6 karakter',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary(isDark),
                          foregroundColor: AppColors.buttonText(isDark),
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Mulai Belajar Sekarang',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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
// 4. TAB BERANDA / DASHBOARD (100% IDENTIK DENGAN STUDENTDASHBOARD.TSX WEB)
// ============================================================================
class DashboardTab extends StatelessWidget {
  final String userName;
  final String userRole;
  final Function(int) onNavigateToTab;

  const DashboardTab({
    super.key,
    this.userName = 'Muhammad Hariz',
    this.userRole = 'Mahasiswa',
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CARD 1: HERO WELCOME BENTO CARD (Identik StudentDashboard.tsx)
          _buildHeroWelcomeCard(context, isDark),
          const SizedBox(height: 14),

          // CARD 2: GAMIFICATION XP & STREAK BENTO CARD
          _buildXpAndStreakBento(context, isDark),
          const SizedBox(height: 14),

          // CARD 3: ACTIVE LEARNING TRACKER (MODUL AKTIF)
          _buildActiveModuleBento(context, isDark),
          const SizedBox(height: 22),

          // SECTION HEADER: AKSI CEPAT AI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aksi Cepat AI',
                style: TextStyle(
                  color: AppColors.textPrimary(isDark),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(isDark),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderColor(isDark)),
                ),
                child: Text(
                  'Bento Grid 2x2',
                  style: TextStyle(
                    color: AppColors.textSecondary(isDark),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // CARD 4: 2X2 BENTO GRID AKSI CEPAT AI
          _buildQuickActionsBentoGrid(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeroWelcomeCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor(isDark), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildPillTag(isDark, 'Level 3 • Praktikan Terampil'),
              _buildPillTag(isDark, 'Semester 4 • TI SV UNS'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Selamat Datang, $userName',
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Studio Praktikum Algoritma & Pemrograman',
            style: TextStyle(
              color: AppColors.textPrimary(isDark),
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pantau capaian praktikum mingguan, eksplorasi modul terstruktur, dan jalankan simulasi penguatan logika komputasi.',
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.borderSubtle(isDark), height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.track_changes_rounded,
                      size: 15,
                      color: AppColors.violetAi,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '3 dari 5 Modul Tuntas',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary(isDark),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onNavigateToTab(1),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary(isDark),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Buka Silabus Modul',
                          style: TextStyle(
                            color: AppColors.buttonText(isDark),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.buttonText(isDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillTag(bool isDark, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.pillBg(isDark),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderColor(isDark), width: 1.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimary(isDark),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildXpAndStreakBento(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor(isDark), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL PENGALAMAN',
                style: TextStyle(
                  color: AppColors.textSecondary(isDark),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(isDark),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderColor(isDark)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.amberBadge,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12 Hari Streak',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '350 XP',
                style: TextStyle(
                  color: AppColors.textPrimary(isDark),
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ 500 XP Target Level 10 • Master',
                style: TextStyle(
                  color: AppColors.textSecondary(isDark),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.70,
              minHeight: 7,
              backgroundColor: AppColors.pillBg(isDark),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.buttonPrimary(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveModuleBento(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigateToTab(1),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderColor(isDark), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PRIORITAS MATERI AKTIF',
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.successGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: AppColors.successGreen.withOpacity(0.35),
                      ),
                    ),
                    child: const Text(
                      'Tuntas 3/4 Bab',
                      style: TextStyle(
                        color: AppColors.successGreen,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Looping & Iterasi: Optimasi Tantangan Algoritma',
                style: TextStyle(
                  color: AppColors.textPrimary(isDark),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Akurasi logika nested loop berada di 64%. Coba latihan pengulangan terpandu sebelum responsi praktikum.',
                style: TextStyle(
                  color: AppColors.textSecondary(isDark),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(isDark),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderColor(isDark)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mulai Penguatan Topik',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsBentoGrid(BuildContext context, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        _buildBentoCard(
          isDark: isDark,
          icon: Icons.upload_file_rounded,
          accentColor: AppColors.electricSky,
          tag: 'RAG Engine',
          title: 'Upload Modul',
          subtitle: 'PDF / DOCX RAG Extraction',
          onTap: () => _showUploadModal(context),
        ),
        _buildBentoCard(
          isDark: isDark,
          icon: Icons.psychology_rounded,
          accentColor: AppColors.violetAi,
          tag: 'Simulasi',
          title: 'Evaluasi AI',
          subtitle: 'Active Recall Quiz',
          onTap: () => onNavigateToTab(2),
        ),
        _buildBentoCard(
          isDark: isDark,
          icon: Icons.alt_route_rounded,
          accentColor: AppColors.electricSky,
          tag: 'Kurikulum',
          title: 'Peta Belajar',
          subtitle: 'Dynamic AI Roadmap',
          onTap: () => onNavigateToTab(1),
        ),
        _buildBentoCard(
          isDark: isDark,
          icon: Icons.smart_toy_rounded,
          accentColor: AppColors.successGreen,
          tag: '24/7 Tutor',
          title: 'Asisten AI',
          subtitle: 'Tanya AI Kognitif',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Asisten AI Kognitif: "Halo! Silakan pilih bab pada Peta Belajar atau Evaluasi untuk berdiskusi."',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required bool isDark,
    required IconData icon,
    required Color accentColor,
    required String tag,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.borderColor(isDark),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor(isDark)),
                    ),
                    child: Icon(icon, color: accentColor, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary(isDark),
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.north_east_rounded,
                        size: 14,
                        color: AppColors.textMutedColor(isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
// 4B. MODAL UPLOAD MODUL PERKULIAHAN (DUAL THEME MINIMALIST SAAS)
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
          content: Text(
            'Harap pilih file dokumen modul PDF/DOCX terlebih dahulu.',
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Modul berhasil diekstrak ke grafik kurikulum adaptif!',
          ),
          backgroundColor: AppColors.successGreen,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(color: AppColors.borderColor(isDark), width: 1.0),
        ),
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
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor(isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Modul Perkuliahan',
                    style: TextStyle(
                      color: AppColors.textPrimary(isDark),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary(isDark),
                      size: 20,
                    ),
                    onPressed:
                        _isProcessing ? null : () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Ekstrak materi kuliah secara otomatis ke dalam grafik kurikulum adaptif.',
                style: TextStyle(
                  color: AppColors.textSecondary(isDark),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 18),
              if (_selectedFileName == null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isProcessing ? null : _simulatePickFile,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 26,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pillBg(isDark),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.borderColor(isDark),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            color: AppColors.textPrimary(isDark),
                            size: 32,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Pilih File PDF atau DOCX',
                            style: TextStyle(
                              color: AppColors.textPrimary(isDark),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Klik untuk simulasi unggah dokumen silabus SV UNS',
                            style: TextStyle(
                              color: AppColors.textSecondary(isDark),
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg(isDark),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.successGreen),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppColors.successGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedFileName!,
                              style: TextStyle(
                                color: AppColors.textPrimary(isDark),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              '$_selectedFileSize • Siap diekstrak',
                              style: TextStyle(
                                color: AppColors.textSecondary(isDark),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isProcessing)
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.error,
                            size: 18,
                          ),
                          onPressed: _removeFile,
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processModuleWithAi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary(isDark),
                    foregroundColor: AppColors.buttonText(isDark),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    _isProcessing
                        ? 'Menganalisis Dokumen AI...'
                        : 'Proses Modul dengan AI',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
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
// 5. TAB ROADMAP (ALUR KURIKULUM BERTINGKAT ULTRA-CLEAN SAAS)
// ============================================================================
class RoadmapTab extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const RoadmapTab({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor(isDark)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pillBg(isDark),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.borderColor(isDark),
                        ),
                      ),
                      child: Text(
                        'Semester 1 • Wajib',
                        style: TextStyle(
                          color: AppColors.textPrimary(isDark),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '3/5 Modul Tuntas',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Algoritma & Pemrograman',
                  style: TextStyle(
                    color: AppColors.textPrimary(isDark),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jalur belajar adaptif terstruktur dari logika dasar hingga analisis kompleksitas Big-O.',
                  style: TextStyle(
                    color: AppColors.textSecondary(isDark),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Peta Kurikulum Kognitif',
            style: TextStyle(
              color: AppColors.textPrimary(isDark),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _buildRoadmapNode(
            context: context,
            isDark: isDark,
            stepNumber: '1',
            title: 'Sintaks Dasar, Variabel & I/O',
            description:
                'Tipe data primitif, alokasi memori stack vs heap, dan stream buffer input/output.',
            status: 'Selesai',
            statusColor: AppColors.successGreen,
            xpReward: '+100 XP',
            isCurrent: false,
            isLocked: false,
            isLast: false,
          ),
          _buildRoadmapNode(
            context: context,
            isDark: isDark,
            stepNumber: '2',
            title: 'Struktur Percabangan (If-Else & Switch)',
            description:
                'Evaluasi boolean algebra, tabel kebenaran logika kondisional, dan jump tables.',
            status: 'Selesai',
            statusColor: AppColors.successGreen,
            xpReward: '+150 XP',
            isCurrent: false,
            isLocked: false,
            isLast: false,
          ),
          _buildRoadmapNode(
            context: context,
            isDark: isDark,
            stepNumber: '3',
            title: 'Looping & Iterasi (For vs While)',
            description:
                'Mekanisme loop counters, invariant perulangan, dan optimasi early termination.',
            status: 'Sedang Belajar',
            statusColor: AppColors.electricSky,
            xpReward: '+180 XP',
            isCurrent: true,
            isLocked: false,
            isLast: false,
            showActions: true,
          ),
          _buildRoadmapNode(
            context: context,
            isDark: isDark,
            stepNumber: '4',
            title: 'Fungsi, Prosedur & Rekursi',
            description:
                'Call stack frames, parameter passing, base case, dan stack overflow hazard.',
            status: 'Terkunci',
            statusColor: AppColors.textMutedColor(isDark),
            xpReward: '+250 XP',
            isCurrent: false,
            isLocked: true,
            isLast: false,
          ),
          _buildRoadmapNode(
            context: context,
            isDark: isDark,
            stepNumber: '5',
            title: 'Kompleksitas Waktu & Big-O Notation',
            description:
                'Analisis asymptotic runtime O(1), O(log n), O(n), hingga O(n²) tradeoffs.',
            status: 'Terkunci',
            statusColor: AppColors.textMutedColor(isDark),
            xpReward: '+300 XP',
            isCurrent: false,
            isLocked: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapNode({
    required BuildContext context,
    required bool isDark,
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
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.buttonPrimary(isDark)
                        : (isLocked
                            ? AppColors.pillBg(isDark)
                            : AppColors.successGreen),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderColor(isDark)),
                  ),
                  child: Center(
                    child: isLocked
                        ? Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.textMutedColor(isDark),
                            size: 14,
                          )
                        : (isCurrent
                            ? Text(
                                stepNumber,
                                style: TextStyle(
                                  color: AppColors.buttonText(isDark),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              )
                            : const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 15,
                              )),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: AppColors.borderColor(isDark),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.textPrimary(isDark)
                        : AppColors.borderColor(isDark),
                    width: isCurrent ? 1.4 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pillBg(isDark),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          xpReward,
                          style: TextStyle(
                            color: AppColors.textSecondary(isDark),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: isLocked
                            ? AppColors.textMutedColor(isDark)
                            : AppColors.textPrimary(isDark),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),
                    if (showActions) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showVideoModal(context, title),
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Materi Video',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.buttonPrimary(isDark),
                                  foregroundColor: AppColors.buttonText(isDark),
                                  padding: EdgeInsets.zero,
                                  shape: const StadiumBorder(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: OutlinedButton.icon(
                                onPressed: () => onNavigateToTab(2),
                                icon: const Icon(Icons.quiz_outlined, size: 15),
                                label: const Text(
                                  'Latihan Kuis',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: const StadiumBorder(),
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
// 6. TAB KUIS AI / ACTIVE RECALL (DUAL THEME MINIMALIST SAAS)
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
      'question':
          'Manakah perbedaan mendasar antara perulangan "for" dan "while"?',
      'options': [
        'For hanya untuk tipe integer, while hanya untuk boolean.',
        'For digunakan saat jumlah iterasi pasti, while saat batas iterasi bergantung kondisi dinamis.',
        'While mengeksekusi instruksi lebih cepat dibanding for di CPU.',
        'For tidak mendukung klausa break.',
      ],
      'correct': 1,
      'explanation':
          'For loop ideal untuk putaran terhitung (counted loop). Sedangkan While loop mengevaluasi syarat boolean dinamis di setiap awal iterasi hingga kondisi menjadi false.',
    },
    {
      'question':
          'Apa yang terjadi jika fungsi rekursif tidak memiliki "Base Case"?',
      'options': [
        'Program otomatis mengonversi kode menjadi for loop.',
        'Nilai kembalian fungsi menjadi 0.',
        'Terjadi Stack Overflow karena frame fungsi menumpuk tanpa henti di memori.',
        'Kompilasi langsung memunculkan syntax error.',
      ],
      'correct': 2,
      'explanation':
          'Base Case adalah syarat mutlak penghenti rekursi. Tanpa Base Case, Call Stack akan kehabisan ruang memori dan memicu crash Stack Overflow.',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sesi Evaluasi Selesai! Kamu mengumpulkan +$_scoreXp XP!',
          ),
          backgroundColor: AppColors.successGreen,
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
    final isDark = AppColors.isDark(context);
    final q = _quizQuestions[_questionIndex];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 110.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(isDark),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderColor(isDark)),
                ),
                child: Text(
                  'Pertanyaan ${_questionIndex + 1} / ${_quizQuestions.length}',
                  style: TextStyle(
                    color: AppColors.textPrimary(isDark),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(isDark),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderColor(isDark)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.amberBadge,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+$_scoreXp XP',
                      style: TextStyle(
                        color: AppColors.textPrimary(isDark),
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor(isDark)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EVALUASI KOGNITIF ADAPTIF',
                  style: TextStyle(
                    color: AppColors.textSecondary(isDark),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  q['question'],
                  style: TextStyle(
                    color: AppColors.textPrimary(isDark),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate((q['options'] as List).length, (index) {
            final optionText = q['options'][index];
            final isSelected = _selectedOption == index;
            final isCorrect = q['correct'] == index;

            Color bgColor = AppColors.surface(isDark);
            Color borderColor = AppColors.borderColor(isDark);
            Color textColor = AppColors.textPrimary(isDark);

            if (_hasAnswered) {
              if (isCorrect) {
                // ignore: deprecated_member_use
                bgColor = AppColors.successGreen.withOpacity(0.12);
                borderColor = AppColors.successGreen;
              } else if (isSelected && !isCorrect) {
                // ignore: deprecated_member_use
                bgColor = AppColors.error.withOpacity(0.12);
                borderColor = AppColors.error;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectOption(index),
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.pillBg(isDark),
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor),
                          ),
                          child: Center(
                            child: Text(
                              ['A', 'B', 'C', 'D'][index],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.5,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          if (_hasAnswered) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface(isDark),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderColor(isDark)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.violetAi,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Rasional Kognitif AI',
                        style: TextStyle(
                          color: AppColors.textPrimary(isDark),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q['explanation'],
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary(isDark),
                  foregroundColor: AppColors.buttonText(isDark),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  _questionIndex == _quizQuestions.length - 1
                      ? 'Selesaikan Evaluasi'
                      : 'Pertanyaan Berikutnya',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
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
// 7. TAB AKUN & PROFIL MAHASISWA (DUAL THEME MINIMALIST SAAS)
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
    if (parts.isEmpty) return 'MH';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 110.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor(isDark)),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimary(isDark),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(userName),
                      style: TextStyle(
                        color: AppColors.buttonText(isDark),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: TextStyle(
                    color: AppColors.textPrimary(isDark),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg(isDark),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.borderColor(isDark)),
                  ),
                  child: Text(
                    '$userNim • $userRole D3 TI SV UNS',
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatBox(
                      isDark,
                      '12 Hari',
                      'Streak',
                      Icons.local_fire_department_rounded,
                      AppColors.amberBadge,
                    ),
                    const SizedBox(width: 8),
                    _buildStatBox(
                      isDark,
                      '350 XP',
                      'Total XP',
                      Icons.bolt_rounded,
                      AppColors.electricSky,
                    ),
                    const SizedBox(width: 8),
                    _buildStatBox(
                      isDark,
                      '#3',
                      'Peringkat',
                      Icons.emoji_events_rounded,
                      AppColors.violetAi,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildMenuTile(
            isDark: isDark,
            icon: Icons.dark_mode_outlined,
            title: isDark
                ? 'Tema Aplikasi: Dark Mode'
                : 'Tema Aplikasi: Light Mode (Web Default)',
            subtitle: 'Ketuk untuk beralih antara Light Mode & Dark Mode',
            onTap: AppTheme.toggleTheme,
          ),
          _buildMenuTile(
            isDark: isDark,
            icon: Icons.military_tech_rounded,
            title: 'Koleksi Lencana Prestasi',
            subtitle: 'Algo Master • Gold Tier Terbuka',
            onTap: () {},
          ),
          _buildMenuTile(
            isDark: isDark,
            icon: Icons.history_rounded,
            title: 'Riwayat Log Telemetri',
            subtitle: 'Akurasi Rata-rata 85%',
            onTap: () {},
          ),
          _buildMenuTile(
            isDark: isDark,
            icon: Icons.logout_rounded,
            title: 'Keluar Akun',
            subtitle: 'Kembali ke halaman autentikasi',
            isDestructive: true,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    bool isDark,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.pillBg(isDark),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor(isDark)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary(isDark),
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary(isDark),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor(isDark)),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onTap: onTap,
          dense: true,
          leading: Icon(
            icon,
            color:
                isDestructive ? AppColors.error : AppColors.textPrimary(isDark),
            size: 20,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive
                  ? AppColors.error
                  : AppColors.textPrimary(isDark),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: 10.5,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textMutedColor(isDark),
            size: 12,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 8. MODAL PEMUTAR VIDEO KULIAH (DUAL THEME MINIMALIST SAAS)
// ============================================================================
class VideoLecturePlayerModal extends StatefulWidget {
  final String moduleTitle;

  const VideoLecturePlayerModal({super.key, required this.moduleTitle});

  @override
  State<VideoLecturePlayerModal> createState() =>
      _VideoLecturePlayerModalState();
}

class _VideoLecturePlayerModalState extends State<VideoLecturePlayerModal> {
  Timer? _timer;
  bool _isPlaying = true;
  int _currentSeconds = 0;
  final int _totalSeconds = 630;

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
    final isDark = AppColors.isDark(context);
    final progress = (_currentSeconds / _totalSeconds).clamp(0.0, 1.0);

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(color: AppColors.borderColor(isDark), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor(isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video Kuliah Penunjang',
                  style: TextStyle(
                    color: AppColors.textPrimary(isDark),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary(isDark),
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            height: 185,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor(isDark)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.smart_display_rounded,
                        color: _isPlaying ? Colors.white : Colors.white54,
                        size: 44,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isPlaying
                            ? 'Memutar Materi Kuliah...'
                            : 'Jeda (Paused)',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_formatTime(_currentSeconds)} / ${_formatTime(_totalSeconds)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: progress,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                            onChanged: (val) {
                              setState(() {
                                _currentSeconds =
                                    (val * _totalSeconds).round();
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.moduleTitle,
                    style: TextStyle(
                      color: AppColors.textPrimary(isDark),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Instruktur: Dr. Aris Sudrajat • Dosen Komputasi SV UNS',
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ringkasan Materi:',
                    style: TextStyle(
                      color: AppColors.textPrimary(isDark),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '1. For Loop optimal untuk traversing array dengan batas indeks terukur pasti O(n).\n'
                    '2. While Loop mengevaluasi kondisi dinamis sebelum memasuki blok kode.\n'
                    '3. Gunakan klausa break untuk menghentikan iterasi lebih awal demi efisiensi siklus CPU.',
                    style: TextStyle(
                      color: AppColors.textSecondary(isDark),
                      fontSize: 12,
                      height: 1.5,
                    ),
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
