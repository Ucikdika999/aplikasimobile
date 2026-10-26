import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/leaderboard_repository.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  int _selectedTabIndex = 0; // 0 = Mingguan, 1 = Lencana Prestasi

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(leaderboardRepositoryProvider);
    final rankings = data.weeklyRankings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Leaderboard & Prestasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              'Peringkat Kognitif Angkatan TI • Sem 3',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.accentCyan,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.xpGold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.military_tech_rounded, color: AppColors.xpGold, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${data.unlockedBadgeCount}/${data.badges.length} Lencana',
                  style: const TextStyle(
                    color: AppColors.xpGold,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Segmented Tab Selector (Peringkat Mingguan vs Lencana)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSegmentButton(
                            title: 'Peringkat Mingguan',
                            icon: Icons.leaderboard_rounded,
                            isSelected: _selectedTabIndex == 0,
                            onTap: () => setState(() => _selectedTabIndex = 0),
                          ),
                        ),
                        Expanded(
                          child: _buildSegmentButton(
                            title: 'Lencana Prestasi',
                            icon: Icons.military_tech_rounded,
                            isSelected: _selectedTabIndex == 1,
                            onTap: () => setState(() => _selectedTabIndex = 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Tab View Body
                Expanded(
                  child: _selectedTabIndex == 0
                      ? _buildLeaderboardView(rankings)
                      : _buildBadgesGridView(data.badges),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/dashboard');
                    break;
                  case 1:
                    context.go('/roadmap');
                    break;
                  case 2:
                    context.go('/active-recall');
                    break;
                  case 3:
                    context.go('/ai-tutor');
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.route_outlined),
                  activeIcon: Icon(Icons.route),
                  label: 'Roadmap',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.psychology_outlined),
                  activeIcon: Icon(Icons.psychology),
                  label: 'Recall',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy_outlined),
                  activeIcon: Icon(Icons.smart_toy),
                  label: 'AI Tutor',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.accentCyan : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.accentCyan : AppColors.textMuted,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. TAMPILAN TAB 1: PODIUM & LIST PERINGKAT
  // ==========================================
  Widget _buildLeaderboardView(List<LeaderboardEntry> rankings) {
    if (rankings.length < 3) return const SizedBox.shrink();

    final first = rankings[0];
    final second = rankings[1];
    final third = rankings[2];
    final remaining = rankings.sublist(3);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // ==========================================
          // TOP 3 PODIUM (2nd, 1st, 3rd)
          // ==========================================
          Container(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Juara 2 (Perak)
                _buildPodiumColumn(
                  entry: second,
                  podiumRank: 2,
                  podiumHeight: 90,
                  medalColor: const Color(0xFF94A3B8), // Silver
                  crownIcon: Icons.workspace_premium_rounded,
                ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms),

                // Juara 1 (Emas - Center Terbesar)
                _buildPodiumColumn(
                  entry: first,
                  podiumRank: 1,
                  podiumHeight: 115,
                  medalColor: AppColors.xpGold, // Gold
                  crownIcon: Icons.emoji_events_rounded,
                  isWinner: true,
                ).animate().slideY(begin: 0.3, end: 0, duration: 500.ms),

                // Juara 3 (Perunggu - User Aktif)
                _buildPodiumColumn(
                  entry: third,
                  podiumRank: 3,
                  podiumHeight: 75,
                  medalColor: const Color(0xFFCD7F32), // Bronze
                  crownIcon: Icons.military_tech_rounded,
                ).animate().slideY(begin: 0.2, end: 0, duration: 450.ms),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Header List Peringkat
          Row(
            children: const [
              Text(
                'Peringkat Mahasiswa Lainnya',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                'Akumulasi XP Mingguan',
                style: TextStyle(color: AppColors.textSubtle, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List Rows (Rank 4, 5, 6...)
          ...remaining.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildRankListRow(entry),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required LeaderboardEntry entry,
    required int podiumRank,
    required double podiumHeight,
    required Color medalColor,
    required IconData crownIcon,
    bool isWinner = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown / Medal Icon
        Icon(crownIcon, color: medalColor, size: isWinner ? 24 : 20),
        const SizedBox(height: 4),

        // Avatar Initial with glowing border
        Container(
          width: isWinner ? 54 : 46,
          height: isWinner ? 54 : 46,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            shape: BoxShape.circle,
            border: Border.all(color: medalColor, width: isWinner ? 2.5 : 1.8),
            boxShadow: [
              BoxShadow(
                color: medalColor.withValues(alpha: isWinner ? 0.4 : 0.2),
                blurRadius: isWinner ? 14 : 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              entry.initials,
              style: TextStyle(
                color: entry.isCurrentUser ? AppColors.accentCyan : AppColors.textWhite,
                fontWeight: FontWeight.w800,
                fontSize: isWinner ? 16 : 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Name & Current User Indicator
        SizedBox(
          width: 85,
          child: Column(
            children: [
              Text(
                entry.name.split(' ')[0],
                style: TextStyle(
                  color: entry.isCurrentUser ? AppColors.accentCyan : AppColors.textWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (entry.isCurrentUser)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Anda',
                    style: TextStyle(
                      color: AppColors.accentCyan,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Podium Pillar Block
        Container(
          width: 78,
          height: podiumHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                medalColor.withValues(alpha: 0.25),
                medalColor.withValues(alpha: 0.08),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: medalColor.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#$podiumRank',
                style: TextStyle(
                  color: medalColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${entry.totalXp} XP',
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF7A00),
                    size: 11,
                  ),
                  Text(
                    '${entry.streakDays}h',
                    style: const TextStyle(
                      color: Color(0xFFFF7A00),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankListRow(LeaderboardEntry entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.accentCyan.withValues(alpha: 0.12)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: entry.isCurrentUser
              ? AppColors.accentCyan.withValues(alpha: 0.5)
              : AppColors.border,
          width: entry.isCurrentUser ? 1.4 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 28,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                color: entry.isCurrentUser ? AppColors.accentCyan : AppColors.textSubtle,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),

          // Avatar initials
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceCardMuted,
              shape: BoxShape.circle,
              border: Border.all(
                color: entry.isCurrentUser ? AppColors.accentCyan : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                entry.initials,
                style: TextStyle(
                  color: entry.isCurrentUser ? AppColors.accentCyan : AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and prodi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.name,
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: entry.isCurrentUser ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (entry.isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Anda',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  entry.programStudy,
                  style: const TextStyle(color: AppColors.textSubtle, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Streak flame
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF7A00),
                size: 15,
              ),
              const SizedBox(width: 2),
              Text(
                '${entry.streakDays}d',
                style: const TextStyle(
                  color: Color(0xFFFF7A00),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Total XP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceCardMuted,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.xpGold.withValues(alpha: 0.3)),
            ),
            child: Text(
              '${entry.totalXp} XP',
              style: const TextStyle(
                color: AppColors.xpGold,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. TAMPILAN TAB 2: GALERI LENCANA PRESTASI
  // ==========================================
  Widget _buildBadgesGridView(List<StudentBadge> badges) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        final isUnlocked = badge.isUnlocked;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnlocked ? AppColors.surfaceCard : AppColors.surfaceCard.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isUnlocked
                  ? badge.accentColor.withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.3),
              width: 1.2,
            ),
            boxShadow: [
              if (isUnlocked)
                BoxShadow(
                  color: badge.accentColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge Icon Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? badge.accentColor.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked
                        ? badge.accentColor
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isUnlocked ? badge.icon : Icons.lock_outline_rounded,
                  color: isUnlocked ? badge.accentColor : AppColors.textSubtle,
                  size: 24,
                ),
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                badge.title,
                style: TextStyle(
                  color: isUnlocked ? AppColors.textWhite : AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Text(
                badge.description,
                style: const TextStyle(
                  color: AppColors.textSubtle,
                  fontSize: 10,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),

              // Progress bar if locked, or date tag if unlocked
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badge.accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, color: badge.accentColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '+${badge.xpReward} XP',
                        style: TextStyle(
                          color: badge.accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    LinearPercentIndicator(
                      lineHeight: 4.0,
                      percent: badge.progress,
                      backgroundColor: AppColors.surfaceCardMuted,
                      progressColor: badge.accentColor.withValues(alpha: 0.6),
                      barRadius: const Radius.circular(2),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(badge.progress * 100).toInt()}% Selesai',
                      style: const TextStyle(color: AppColors.textSubtle, fontSize: 9),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
