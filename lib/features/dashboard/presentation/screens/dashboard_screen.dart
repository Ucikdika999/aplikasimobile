import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/dashboard_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = AppColors.isDark(context);
    final dashboardData = ref.watch(studentDashboardProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    final profile = dashboardData.profile;
    final userName = user?.name.isNotEmpty == true ? user!.name : profile.name;

    return Scaffold(
      backgroundColor: AppColors.bg(isDark),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // 1. HEADER APP BAR ULTRA-CLEAN SAAS + THEME TOGGLE
                  // ==========================================
                  _buildSaasAppBar(context, ref, isDark, userName, profile),
                  const SizedBox(height: 20),

                  // ==========================================
                  // 2. HERO WELCOME BENTO CARD (IDENTIK WEB NEXEDAI)
                  // ==========================================
                  _buildHeroWelcomeBento(context, isDark, userName),
                  const SizedBox(height: 14),

                  // ==========================================
                  // 3. GAMIFICATION PROGRESS & STREAK BENTO CARD
                  // ==========================================
                  _buildGamificationBentoCard(context, isDark),
                  const SizedBox(height: 14),

                  // ==========================================
                  // 4. ACTIVE LEARNING TRACKER (MODUL AKTIF)
                  // ==========================================
                  _buildActiveModuleBentoCard(context, isDark),
                  const SizedBox(height: 24),

                  // ==========================================
                  // 5. BENTO GRID 2x2 "AKSI CEPAT AI"
                  // ==========================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aksi Cepat AI',
                        style: TextStyle(
                          color: AppColors.textPrimary(isDark),
                          fontSize: 16,
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
                          border: Border.all(
                            color: AppColors.borderColor(isDark),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          'Cognitive AI Hub',
                          style: TextStyle(
                            color: AppColors.textSecondary(isDark),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBentoQuickActionsGrid(context, isDark),
                ],
              ),
            ),
          ),
        ),
      ),

      // ==========================================
      // 6. MODERN FLOATING PILL BOTTOM NAVIGATION BAR
      // ==========================================
      bottomNavigationBar: SafeArea(
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _buildFloatingBottomNav(
              context,
              ref,
              isDark,
              userName,
              profile,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HEADER APP BAR ULTRA-CLEAN SAAS + THEME TOGGLE
  // ==========================================
  Widget _buildSaasAppBar(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    String userName,
    StudentProfileData profile,
  ) {
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
          // Brand Logo + Pill Kampus
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
                      horizontal: 9,
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
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Toggle Tema Instan + Notifikasi + Avatar
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
                          'Notifikasi: 1 Modul Kognitif baru tersedia di Peta Belajar!',
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
                          top: 8,
                          right: 9,
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
              const SizedBox(width: 6),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      _showAccountModal(context, ref, isDark, userName, profile),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary(isDark),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                        style: TextStyle(
                          color: AppColors.buttonText(isDark),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
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

  // ==========================================
  // 2. HERO WELCOME BENTO CARD (IDENTIK WEB NEXEDAI)
  // ==========================================
  Widget _buildHeroWelcomeBento(
    BuildContext context,
    bool isDark,
    String userName,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildPillBadge(
                isDark: isDark,
                label: 'PORTAL AKADEMIK MAHASISWA',
                icon: Icons.verified_outlined,
              ),
              _buildPillBadge(
                isDark: isDark,
                label: 'Semester 4 • TI SV UNS',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Selamat Datang, $userName',
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Studio Praktikum Algoritma & Pemrograman',
            style: TextStyle(
              color: AppColors.textPrimary(isDark),
              fontSize: 20,
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
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.go('/roadmap'),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimary(isDark),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Buka Silabus Modul',
                            style: TextStyle(
                              color: AppColors.buttonText(isDark),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.buttonText(isDark),
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/leaderboard'),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.borderColor(isDark),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: AppColors.textPrimary(isDark),
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Log Telemetri',
                          style: TextStyle(
                            color: AppColors.textPrimary(isDark),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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

  Widget _buildPillBadge({
    required bool isDark,
    required String label,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.pillBg(isDark),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.borderColor(isDark),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: AppColors.textPrimary(isDark),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary(isDark),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. GAMIFICATION PROGRESS & STREAK BENTO CARD
  // ==========================================
  Widget _buildGamificationBentoCard(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/leaderboard'),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg(isDark),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.borderColor(isDark),
                            width: 1.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.military_tech_rounded,
                          color: AppColors.amberBadge,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level 10 • Master',
                            style: TextStyle(
                              color: AppColors.textPrimary(isDark),
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          Text(
                            'Algo Master • Gold Tier',
                            style: TextStyle(
                              color: AppColors.textMutedColor(isDark),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.borderColor(isDark),
                        width: 1.0,
                      ),
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
                          '350 / 500 XP',
                          style: TextStyle(
                            color: AppColors.textPrimary(isDark),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.7,
                  minHeight: 7,
                  backgroundColor: AppColors.pillBg(isDark),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.buttonPrimary(isDark),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. ACTIVE LEARNING TRACKER (MODUL AKTIF)
  // ==========================================
  Widget _buildActiveModuleBentoCard(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/roadmap'),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
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
                      'MODUL AKTIF',
                      style: TextStyle(
                        color: AppColors.textSecondary(isDark),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.successGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: AppColors.successGreen.withOpacity(0.35),
                        width: 1.0,
                      ),
                    ),
                    child: const Text(
                      'Tuntas 3/4 Bab',
                      style: TextStyle(
                        color: AppColors.successGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Looping & Iterasi: Optimasi Tantangan Algoritma',
                style: TextStyle(
                  color: AppColors.textPrimary(isDark),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.5,
                  letterSpacing: -0.3,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Akurasi logika nested loop berada di 84%. Lanjutkan latihan pengulangan terpandu sebelum responsi.',
                style: TextStyle(
                  color: AppColors.textSecondary(isDark),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Divider(color: AppColors.borderSubtle(isDark), height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: AppColors.textMutedColor(isDark),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Estimasi 15 mnt tersisa',
                        style: TextStyle(
                          color: AppColors.textSecondary(isDark),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary(isDark),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: AppColors.buttonText(isDark),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.buttonText(isDark),
                          size: 14,
                        ),
                      ],
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

  // ==========================================
  // 5. BENTO GRID 2x2 "AKSI CEPAT AI"
  // ==========================================
  Widget _buildBentoQuickActionsGrid(BuildContext context, bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildBentoActionCard(
          isDark: isDark,
          icon: Icons.upload_file_rounded,
          accentColor: AppColors.electricSky,
          tag: 'RAG Engine',
          title: 'Upload Modul',
          subtitle: 'PDF / DOCX RAG Extraction',
          onTap: () => _showUploadModal(context, isDark),
        ),
        _buildBentoActionCard(
          isDark: isDark,
          icon: Icons.psychology_rounded,
          accentColor: AppColors.violetAi,
          tag: 'Simulasi',
          title: 'Evaluasi AI',
          subtitle: 'Active Recall Quiz',
          onTap: () => context.go('/active-recall'),
        ),
        _buildBentoActionCard(
          isDark: isDark,
          icon: Icons.alt_route_rounded,
          accentColor: AppColors.electricSky,
          tag: 'Kurikulum',
          title: 'Peta Belajar',
          subtitle: 'Dynamic AI Roadmap',
          onTap: () => context.go('/roadmap'),
        ),
        _buildBentoActionCard(
          isDark: isDark,
          icon: Icons.smart_toy_rounded,
          accentColor: AppColors.successGreen,
          tag: '24/7 Tutor',
          title: 'Asisten AI',
          subtitle: 'Tanya AI Kognitif',
          onTap: () => context.go('/ai-tutor'),
        ),
      ],
    );
  }

  Widget _buildBentoActionCard({
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
          padding: const EdgeInsets.all(15),
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
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg(isDark),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderColor(isDark),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: 20,
                    ),
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
                        color: AppColors.textMutedColor(isDark),
                        size: 14,
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
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

  // ==========================================
  // 6. MODERN FLOATING PILL BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildFloatingBottomNav(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    String userName,
    StudentProfileData profile,
  ) {
    return Container(
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
            _buildFloatingNavItem(
              isDark: isDark,
              icon: Icons.grid_view_rounded,
              label: 'Beranda',
              isActive: true,
              onTap: () {},
            ),
            _buildFloatingNavItem(
              isDark: isDark,
              icon: Icons.account_tree_rounded,
              label: 'Peta Belajar',
              isActive: false,
              onTap: () => context.go('/roadmap'),
            ),
            _buildFloatingNavItem(
              isDark: isDark,
              icon: Icons.quiz_rounded,
              label: 'Evaluasi',
              isActive: false,
              onTap: () => context.go('/active-recall'),
            ),
            _buildFloatingNavItem(
              isDark: isDark,
              icon: Icons.leaderboard_rounded,
              label: 'Peringkat',
              isActive: false,
              onTap: () => context.go('/leaderboard'),
            ),
            _buildFloatingNavItem(
              isDark: isDark,
              icon: Icons.person_rounded,
              label: 'Profil',
              isActive: false,
              onTap: () =>
                  _showAccountModal(context, ref, isDark, userName, profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem({
    required bool isDark,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final activeBg = AppColors.buttonPrimary(isDark);
    final activeFg = AppColors.buttonText(isDark);
    final inactiveFg = AppColors.textMutedColor(isDark);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 10,
          vertical: 7,
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
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================
  // MODAL UPLOAD MODUL PDF / DOCX RAG EXTRACTION
  // ==========================================
  void _showUploadModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        String? selectedFileName;
        String? selectedFileSize;
        bool isProcessing = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final modalIsDark = AppColors.isDark(context);
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 14,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface(modalIsDark),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.borderColor(modalIsDark),
                    width: 1.0,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderColor(modalIsDark),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Upload Modul Perkuliahan',
                      style: TextStyle(
                        color: AppColors.textPrimary(modalIsDark),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'AI akan mengekstrak dokumen (PDF/DOCX) menggunakan RAG menjadi kuis dan peta belajar adaptif.',
                      style: TextStyle(
                        color: AppColors.textSecondary(modalIsDark),
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (selectedFileName == null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isProcessing
                              ? null
                              : () {
                                  setModalState(() {
                                    selectedFileName =
                                        'Modul_Struktur_Data_2026.pdf';
                                    selectedFileSize = '2.4 MB';
                                  });
                                },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 26,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.pillBg(modalIsDark),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.borderColor(modalIsDark),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.upload_file_rounded,
                                  color: AppColors.textPrimary(modalIsDark),
                                  size: 34,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Pilih Dokumen Silabus / Materi Kuliah',
                                  style: TextStyle(
                                    color: AppColors.textPrimary(modalIsDark),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Format didukung: PDF, DOCX (Maks. 25MB)',
                                  style: TextStyle(
                                    color: AppColors.textMutedColor(modalIsDark),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.pillBg(modalIsDark),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.successGreen,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: AppColors.successGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.picture_as_pdf_rounded,
                                color: AppColors.successGreen,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedFileName!,
                                    style: TextStyle(
                                      color: AppColors.textPrimary(modalIsDark),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$selectedFileSize • Siap diekstrak',
                                    style: TextStyle(
                                      color:
                                          AppColors.textSecondary(modalIsDark),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isProcessing)
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setModalState(() {
                                      selectedFileName = null;
                                      selectedFileSize = null;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isProcessing
                            ? null
                            : () {
                                if (selectedFileName == null) {
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

                                setModalState(() {
                                  isProcessing = true;
                                });

                                Future.delayed(const Duration(seconds: 2), () {
                                  if (!context.mounted) return;
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Modul berhasil diekstrak ke Peta Belajar adaptif!',
                                      ),
                                      backgroundColor: AppColors.successGreen,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.buttonPrimary(modalIsDark),
                          foregroundColor: AppColors.buttonText(modalIsDark),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          isProcessing
                              ? 'Menganalisis Dokumen AI...'
                              : 'Proses Modul dengan AI',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // MODAL AKUN & PROFIL MAHASISWA
  // ==========================================
  void _showAccountModal(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    String userName,
    StudentProfileData profile,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final modalIsDark = AppColors.isDark(ctx);
        return Material(
          color: AppColors.surface(modalIsDark),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            side: BorderSide(
              color: AppColors.borderColor(modalIsDark),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor(modalIsDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.buttonPrimary(modalIsDark),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.buttonText(modalIsDark),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: TextStyle(
                    color: AppColors.textPrimary(modalIsDark),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg(modalIsDark),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'D3 TI SV UNS • Semester 4',
                    style: TextStyle(
                      color: AppColors.textSecondary(modalIsDark),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: const Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.amberBadge,
                    ),
                    title: Text(
                      'Leaderboard Angkatan',
                      style: TextStyle(
                        color: AppColors.textPrimary(modalIsDark),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textMutedColor(modalIsDark),
                      size: 14,
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.go('/leaderboard');
                    },
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                    ),
                    title: const Text(
                      'Keluar Akun',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(ctx);
                      await ref.read(authNotifierProvider.notifier).logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
