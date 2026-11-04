import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/dashboard_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.watch(studentDashboardProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    final profile = dashboardData.profile;
    final userName = user?.name.isNotEmpty == true ? user!.name : profile.name;

    return Scaffold(
      backgroundColor: AppColors.background, // Deep Midnight Canvas (0xFF070B14)
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // 1. HEADER APP BAR KUSTOM
                  // ==========================================
                  _buildCustomHeader(context, ref, userName, profile),
                  const SizedBox(height: 22),

                  // ==========================================
                  // 2. GAMIFICATION PROGRESS BANNER (LEVEL & XP CARD)
                  // ==========================================
                  _buildGamificationBanner(context),
                  const SizedBox(height: 16),

                  // ==========================================
                  // 3. ACTIVE LEARNING TRACKER (MODUL SEDANG DIPELAJARI)
                  // ==========================================
                  _buildActiveLearningTracker(context),
                  const SizedBox(height: 26),

                  // ==========================================
                  // 4. BENTO GRID "AKSI CEPAT AI" (2x2 GRID LAYOUT)
                  // ==========================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Aksi Cepat AI',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder, width: 1.0),
                        ),
                        child: const Text(
                          'Bento Hub',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildBentoQuickActionsGrid(context),
                ],
              ),
            ),
          ),
        ),
      ),

      // ==========================================
      // 5. MODERN FLOATING BOTTOM NAVIGATION BAR
      // ==========================================
      bottomNavigationBar: SafeArea(
        child: Center(
          heightFactor: 1.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _buildFloatingBottomNav(context, ref, userName, profile),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HEADER APP BAR KUSTOM
  // ==========================================
  Widget _buildCustomHeader(
    BuildContext context,
    WidgetRef ref,
    String userName,
    StudentProfileData profile,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Baris kiri: Logo NexedAI dengan icon kilat bercahaya + Chip Kampus
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: AppColors.surfaceGlowBorder,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: const Color(0xFF0EA5E9).withOpacity(0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_rounded,
                    color: Color(0xFF0EA5E9),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              const Text(
                'NexedAI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(width: 8),

              // Chip Kampus: D3 TI SV UNS
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 1.0,
                    ),
                  ),
                  child: const Text(
                    'D3 TI SV UNS',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Baris kanan: Tombol Notifikasi & User Avatar melingkar dengan border Slate 800
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Notifikasi
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
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E293B),
                      width: 1.0,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFFE2E8F0),
                        size: 20,
                      ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0EA5E9),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // User Avatar melingkar dengan border Slate 800
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showAccountModal(context, ref, userName, profile),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E293B),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 2. GAMIFICATION PROGRESS BANNER (LEVEL & XP CARD)
  // ==========================================
  Widget _buildGamificationBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/leaderboard'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A), // Card Slate 900
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1E293B), // Border Slate 800
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
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: const Color(0xFFF59E0B).withOpacity(0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.military_tech_rounded,
                          color: Color(0xFFF59E0B), // Gamification Gold
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Level 10 • Master',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '350 / 500 XP',
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const LinearProgressIndicator(
                  value: 0.7,
                  minHeight: 8,
                  backgroundColor: Color(0xFF1E293B),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF0EA5E9),
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
  // 3. ACTIVE LEARNING TRACKER (MODUL SEDANG DIPELAJARI)
  // ==========================================
  Widget _buildActiveLearningTracker(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/roadmap'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label kecil huruf kapital: "MODUL AKTIF"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MODUL AKTIF',
                    style: TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  // Status chip: "Tuntas 3/4 Bab"
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: const Color(0xFF10B981).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF10B981).withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                    child: const Text(
                      'Tuntas 3/4 Bab',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Judul: "Looping & Iterasi: Optimasi Tantangan Algoritma"
              const Text(
                'Looping & Iterasi: Optimasi Tantangan Algoritma',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),

              // Tombol aksi mini: "Lanjutkan" dengan ikon Icons.arrow_forward_rounded
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estimasi 15 mnt tersisa',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 15,
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
  // 4. BENTO GRID "AKSI CEPAT AI" (2x2 GRID LAYOUT)
  // ==========================================
  Widget _buildBentoQuickActionsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        // Card 1: Upload Modul -> PDF / DOCX RAG Extraction
        _buildBentoActionCard(
          icon: Icons.upload_file_rounded,
          iconColor: const Color(0xFF0EA5E9),
          title: 'Upload Modul',
          subtitle: 'PDF / DOCX RAG Extraction',
          onTap: () => _showUploadModal(context),
        ),

        // Card 2: Evaluasi AI -> Active Recall Quiz
        _buildBentoActionCard(
          icon: Icons.psychology_rounded,
          iconColor: const Color(0xFF8B5CF6),
          title: 'Evaluasi AI',
          subtitle: 'Active Recall Quiz',
          onTap: () => context.go('/active-recall'),
        ),

        // Card 3: Peta Belajar -> Dynamic AI Roadmap
        _buildBentoActionCard(
          icon: Icons.alt_route_rounded,
          iconColor: const Color(0xFF2563EB),
          title: 'Peta Belajar',
          subtitle: 'Dynamic AI Roadmap',
          onTap: () => context.go('/roadmap'),
        ),

        // Card 4: Asisten AI -> Tanya AI Kognitif
        _buildBentoActionCard(
          icon: Icons.smart_toy_rounded,
          iconColor: const Color(0xFF10B981),
          title: 'Asisten AI',
          subtitle: 'Tanya AI Kognitif',
          onTap: () => context.go('/ai-tutor'),
        ),
      ],
    );
  }

  Widget _buildBentoActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1E293B),
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: iconColor.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: iconColor.withOpacity(0.28),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  Icon(
                    Icons.north_east_rounded,
                    color: AppColors.textSubtle,
                    size: 16,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
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
  // 5. MODERN FLOATING BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildFloatingBottomNav(
    BuildContext context,
    WidgetRef ref,
    String userName,
    StudentProfileData profile,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: const Color(0xFF0F172A).withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFloatingNavItem(
              icon: Icons.grid_view_rounded,
              label: 'Beranda',
              isActive: true,
              onTap: () {},
            ),
            _buildFloatingNavItem(
              icon: Icons.account_tree_rounded,
              label: 'Peta Belajar',
              isActive: false,
              onTap: () => context.go('/roadmap'),
            ),
            _buildFloatingNavItem(
              icon: Icons.quiz_rounded,
              label: 'Evaluasi',
              isActive: false,
              onTap: () => context.go('/active-recall'),
            ),
            _buildFloatingNavItem(
              icon: Icons.leaderboard_rounded,
              label: 'Peringkat',
              isActive: false,
              onTap: () => context.go('/leaderboard'),
            ),
            _buildFloatingNavItem(
              icon: Icons.person_rounded,
              label: 'Profil',
              isActive: false,
              onTap: () => _showAccountModal(context, ref, userName, profile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFF0EA5E9);
    const inactiveColor = Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              // ignore: deprecated_member_use
              ? activeColor.withOpacity(0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 20,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // MODAL UPLOAD MODUL PDF / DOCX RAG EXTRACTION
  // ==========================================
  void _showUploadModal(BuildContext context) {
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
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: Color(0xFF1E293B), width: 1.0),
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
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Upload Modul Perkuliahan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'AI akan mengekstrak dokumen (PDF/DOCX) menggunakan RAG menjadi kuis dan peta belajar adaptif.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
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
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF070B14),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.surfaceGlowBorder,
                                width: 1.0,
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.upload_file_rounded,
                                  color: Color(0xFF0EA5E9),
                                  size: 38,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Pilih Dokumen Silabus / Materi Kuliah',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Format didukung: PDF, DOCX (Maks. 25MB)',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
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
                          color: const Color(0xFF070B14),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF10B981).withOpacity(0.6),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: const Color(0xFF10B981).withOpacity(0.18),
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
                                  const Row(
                                    children: [
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
                                    selectedFileName!,
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
                                    '$selectedFileSize • Siap diekstrak',
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10.5,
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
                                    color: Color(0xFFEF4444),
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
                                      backgroundColor: Color(0xFFEF4444),
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
                                      backgroundColor: Color(0xFF10B981),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isProcessing
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF0EA5E9),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Menganalisis Dokumen AI...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.auto_awesome, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Proses Modul dengan AI',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
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
    String userName,
    StudentProfileData profile,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Material(
          color: const Color(0xFF0F172A),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            side: BorderSide(color: Color(0xFF1E293B), width: 1.0),
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
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF0EA5E9),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'D3 TI SV UNS • Semester 3',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  color: Colors.transparent,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.gamificationGold,
                    ),
                    title: const Text(
                      'Leaderboard Angkatan',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white54,
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFEF4444),
                    ),
                    title: const Text(
                      'Keluar Akun',
                      style: TextStyle(color: Color(0xFFEF4444)),
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
