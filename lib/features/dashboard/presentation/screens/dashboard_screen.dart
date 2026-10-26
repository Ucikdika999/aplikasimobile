import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
      backgroundColor: const Color(0xFF090E1A), // Dark backdrop for web
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1424),
              border: Border.symmetric(
                vertical: BorderSide(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  width: 1.0,
                ),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==========================================
                  // 1. TOP BAR: NEXED AI LOGO + D3 TI SV UNS + NOTIFIKASI
                  // ==========================================
                  _buildTopBar(context, ref),
                  const SizedBox(height: 20),

                  // ==========================================
                  // 2. KARTU LEVEL & XP (LEVEL 10 • MASTER)
                  // ==========================================
                  _buildLevelCard(context),
                  const SizedBox(height: 14),

                  // ==========================================
                  // 3. KARTU MODUL AKTIF (LOOPING & ITERASI)
                  // ==========================================
                  _buildActiveModuleCard(context),
                  const SizedBox(height: 24),

                  // ==========================================
                  // 4. JUDUL SEKSI "AKSI CEPAT AI"
                  // ==========================================
                  const Text(
                    'Aksi Cepat AI',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ==========================================
                  // 5. 2x2 GRID AKSI CEPAT AI
                  // ==========================================
                  _buildQuickActionsGrid(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      // ==========================================
      // 6. BOTTOM NAVIGATION BAR (BERANDA, ROADMAP, KUIS AI, AKUN)
      // ==========================================
      bottomNavigationBar: Container(
        color: const Color(0xFF090E1A),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: _buildBottomNav(context, ref, userName, profile),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDERS
  // ==========================================

  /// 1. Top Bar dengan Logo NexedAI & Badge Jurusan
  Widget _buildTopBar(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Logo Mark "N" Futuristik
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Teks Brand NexedAI
            const Text(
              'NexedAI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(width: 10),

            // Badge Program Studi: D3 TI SV UNS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0369A1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.6),
                  width: 1.0,
                ),
              ),
              child: const Text(
                'D3 TI SV UNS',
                style: TextStyle(
                  color: Color(0xFF38BDF8),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),

        // Ikon Notifikasi Bell dengan Dot Merah
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white70,
                size: 24,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifikasi: 1 Modul Kognitif baru tersedia di Roadmap!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0D1424), width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2. Kartu Level & Progres XP (Level 10 • Master)
  Widget _buildLevelCard(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/leaderboard'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.2),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Level 10 • Master',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '350 / 500 XP',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearPercentIndicator(
              lineHeight: 5.5,
              percent: 0.70, // 350 / 500 = 70%
              backgroundColor: const Color(0xFF1E293B),
              progressColor: const Color(0xFF38BDF8),
              barRadius: const Radius.circular(3),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 3. Kartu Modul Aktif (Looping & Iterasi: Optimasi)
  Widget _buildActiveModuleCard(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/roadmap'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
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
            const SizedBox(height: 12),
            LinearPercentIndicator(
              lineHeight: 5.5,
              percent: 1.0, // 3/3 tuntas
              backgroundColor: const Color(0xFF1E293B),
              progressColor: const Color(0xFF0284C7),
              barRadius: const Radius.circular(3),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 4. 2x2 Grid Aksi Cepat AI
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
          iconColor: const Color(0xFF3B82F6), // Bright Blue
          iconBg: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
          title: 'Upload Modul',
          subtitle: '(PDF / DOCX)',
          onTap: () => _showUploadModal(context),
        ),

        // 2. Simulasi AI (Active Recall)
        _buildActionCard(
          icon: Icons.psychology_rounded,
          iconColor: const Color(0xFF06B6D4), // Cyan Glow
          iconBg: const Color(0xFF0891B2).withValues(alpha: 0.25),
          title: 'Simulasi AI',
          subtitle: '(Active Recall)',
          onTap: () => context.go('/active-recall'),
        ),

        // 3. Tes Diagnostik (Adaptif)
        _buildActionCard(
          icon: Icons.alt_route_rounded,
          iconColor: const Color(0xFFA855F7), // Purple/Magenta
          iconBg: const Color(0xFF7E22CE).withValues(alpha: 0.25),
          title: 'Tes Diagnostik',
          subtitle: '(Adaptif)',
          onTap: () => context.go('/roadmap'),
        ),

        // 4. Tutor Kognitif (Tanya Jawab)
        _buildActionCard(
          icon: Icons.smart_toy_rounded,
          iconColor: const Color(0xFF6366F1), // Indigo
          iconBg: const Color(0xFF4338CA).withValues(alpha: 0.25),
          title: 'Tutor Kognitif',
          subtitle: '(Tanya Jawab)',
          onTap: () => context.go('/ai-tutor'),
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
          color: const Color(0xFF131D31),
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

  /// 5. Modal Upload Modul PDF / DOCX
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
                color: Color(0xFF131D31),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
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
                      'AI akan membaca file dokumen Anda dan mengubahnya menjadi kuis kognitif otomatis.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                    const SizedBox(height: 20),

                    // Kotak Drop Zone / File Picker
                    if (selectedFileName == null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isProcessing
                              ? null
                              : () {
                                  setModalState(() {
                                    selectedFileName = 'Modul_Struktur_Data_2026.pdf';
                                    selectedFileSize = '2.4 MB';
                                  });
                                },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.cloud_upload_outlined, color: Color(0xFF38BDF8), size: 38),
                                SizedBox(height: 10),
                                Text(
                                  'Pilih Dokumen Silabus / Materi Kuliah',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Format didukung: PDF, DOCX (Maks. 25MB)',
                                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
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
                                      Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 15),
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
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 20),
                                onPressed: () {
                                  setModalState(() {
                                    selectedFileName = null;
                                    selectedFileSize = null;
                                  });
                                },
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
                                      content: Text('⚠️ Harap pilih file dokumen modul PDF/DOCX terlebih dahulu.'),
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
                                      content: Text('Modul berhasil diekstrak ke grafik kurikulum adaptif!'),
                                      backgroundColor: Color(0xFF10B981),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: const Color(0xFF0B0F17),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isProcessing
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Menganalisis Dokumen AI...', style: TextStyle(color: Colors.white)),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.auto_awesome, size: 18),
                                  SizedBox(width: 8),
                                  Text('Proses Modul dengan AI', style: TextStyle(fontWeight: FontWeight.w700)),
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

  /// 6. Bottom Navigation Bar Persis Gambar (Beranda, Roadmap, Kuis AI, Akun)
  Widget _buildBottomNav(
    BuildContext context,
    WidgetRef ref,
    String userName,
    StudentProfileData profile,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D1424),
        border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1.0)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Beranda (Aktif - dengan garis cyan di atas)
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Beranda',
                isActive: true,
                onTap: () {},
              ),

              // 2. Roadmap
              _buildNavItem(
                icon: Icons.map_outlined,
                label: 'Roadmap',
                isActive: false,
                onTap: () => context.go('/roadmap'),
              ),

              // 3. Kuis AI
              _buildNavItem(
                icon: Icons.article_outlined,
                label: 'Kuis AI',
                isActive: false,
                onTap: () => context.go('/active-recall'),
              ),

              // 4. Akun
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Akun',
                isActive: false,
                onTap: () => _showAccountModal(context, ref, userName, profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indikator aktif di atas ikon seperti di screenshot
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

  /// Modal Akun & Profil Mahasiswa
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
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF131D31),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border(top: BorderSide(color: Color(0xFF1E293B), width: 1.5)),
          ),
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
                backgroundColor: const Color(0xFF0284C7),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'D3 TI SV UNS • Semester 3',
                style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.emoji_events_rounded, color: AppColors.xpGold),
                title: const Text('Leaderboard Angkatan', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  context.go('/leaderboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                title: const Text('Keluar Akun', style: TextStyle(color: Color(0xFFEF4444))),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(authNotifierProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
