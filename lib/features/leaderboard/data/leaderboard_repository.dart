import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import 'models/leaderboard_entry.dart';
import 'models/student_badge.dart';

export 'models/leaderboard_entry.dart';
export 'models/student_badge.dart';

class LeaderboardData {
  final List<LeaderboardEntry> weeklyRankings;
  final List<LeaderboardEntry> allTimeRankings;
  final List<StudentBadge> badges;

  const LeaderboardData({
    required this.weeklyRankings,
    required this.allTimeRankings,
    required this.badges,
  });

  LeaderboardEntry get currentUserWeekly =>
      weeklyRankings.firstWhere((e) => e.isCurrentUser);

  int get unlockedBadgeCount => badges.where((b) => b.isUnlocked).length;
}

final leaderboardRepositoryProvider = Provider<LeaderboardData>((ref) {
  return const LeaderboardData(
    weeklyRankings: [
      LeaderboardEntry(
        rank: 1,
        name: 'Fadhil Pratama',
        initials: 'FP',
        programStudy: 'Teknik Informatika • Sem 3',
        totalXp: 3840,
        streakDays: 14,
        rankChange: 1,
      ),
      LeaderboardEntry(
        rank: 2,
        name: 'Siti Rahmawati',
        initials: 'SR',
        programStudy: 'Sistem Informasi • Sem 3',
        totalXp: 3420,
        streakDays: 9,
        rankChange: -1,
      ),
      LeaderboardEntry(
        rank: 3,
        name: 'Ahmad Fauzi', // Current active user!
        initials: 'AF',
        programStudy: 'Teknik Informatika • Sem 3',
        totalXp: 2850,
        streakDays: 7,
        isCurrentUser: true,
        rankChange: 2,
      ),
      LeaderboardEntry(
        rank: 4,
        name: 'Budi Santoso',
        initials: 'BS',
        programStudy: 'Ilmu Komputer • Sem 3',
        totalXp: 2610,
        streakDays: 5,
        rankChange: 0,
      ),
      LeaderboardEntry(
        rank: 5,
        name: 'Nadia Putri',
        initials: 'NP',
        programStudy: 'Teknik Informatika • Sem 3',
        totalXp: 2450,
        streakDays: 6,
        rankChange: 3,
      ),
      LeaderboardEntry(
        rank: 6,
        name: 'Rian Saputra',
        initials: 'RS',
        programStudy: 'Sistem Informasi • Sem 3',
        totalXp: 2180,
        streakDays: 4,
        rankChange: -2,
      ),
      LeaderboardEntry(
        rank: 7,
        name: 'Clara Anindya',
        initials: 'CA',
        programStudy: 'Teknologi Informasi • Sem 3',
        totalXp: 1950,
        streakDays: 3,
        rankChange: 1,
      ),
    ],
    allTimeRankings: [
      LeaderboardEntry(
        rank: 1,
        name: 'Fadhil Pratama',
        initials: 'FP',
        programStudy: 'Teknik Informatika • Sem 3',
        totalXp: 18450,
        streakDays: 14,
      ),
      LeaderboardEntry(
        rank: 2,
        name: 'Ahmad Fauzi',
        initials: 'AF',
        programStudy: 'Teknik Informatika • Sem 3',
        totalXp: 16820,
        streakDays: 7,
        isCurrentUser: true,
      ),
      LeaderboardEntry(
        rank: 3,
        name: 'Siti Rahmawati',
        initials: 'SR',
        programStudy: 'Sistem Informasi • Sem 3',
        totalXp: 15900,
        streakDays: 9,
      ),
      LeaderboardEntry(
        rank: 4,
        name: 'Nadia Putri',
        initials: 'NP',
        programStudy: 'Teknik Informatika • Sem 3',
        totalXp: 13200,
        streakDays: 6,
      ),
    ],
    badges: [
      StudentBadge(
        id: 'b-streak-7',
        title: 'Api Belajar 7 Hari',
        description: 'Menjaga streak belajar harian konsisten selama 7 hari berturut-turut.',
        icon: Icons.local_fire_department_rounded,
        accentColor: Color(0xFFFF7A00),
        isUnlocked: true,
        unlockedDate: 'Kemarin',
        xpReward: 150,
        progress: 1.0,
      ),
      StudentBadge(
        id: 'b-perfect-quiz',
        title: 'Akurasi Sempurna',
        description: 'Menjawab benar 100% soal pada satu sesi kuis Active Recall.',
        icon: Icons.emoji_events_rounded,
        accentColor: AppColors.xpGold,
        isUnlocked: true,
        unlockedDate: '3 hari lalu',
        xpReward: 200,
        progress: 1.0,
      ),
      StudentBadge(
        id: 'b-algo-master',
        title: 'Ksatria Algoritma',
        description: 'Menyelesaikan modul pengantar logika dasar dan percabangan.',
        icon: Icons.military_tech_rounded,
        accentColor: AppColors.accentCyan,
        isUnlocked: true,
        unlockedDate: '5 hari lalu',
        xpReward: 250,
        progress: 1.0,
      ),
      StudentBadge(
        id: 'b-deep-focus',
        title: 'Kognitif Tangkas',
        description: 'Menjawab 5 pertanyaan kuis kilat masing-masing di bawah 10 detik.',
        icon: Icons.bolt_rounded,
        accentColor: Color(0xFFA855F7),
        isUnlocked: true,
        unlockedDate: '1 minggu lalu',
        xpReward: 180,
        progress: 1.0,
      ),
      StudentBadge(
        id: 'b-recursion-guru',
        title: 'Pakar Rekursi & Big-O',
        description: 'Tuntaskan materi fungsi rekursi, stack frames, dan optimasi Big-O.',
        icon: Icons.account_tree_rounded,
        accentColor: Color(0xFF10B981),
        isUnlocked: false,
        xpReward: 350,
        progress: 0.65, // 65% menuju terbuka
      ),
      StudentBadge(
        id: 'b-night-owl',
        title: 'Penjelajah Malam',
        description: 'Menyelesaikan sesi belajar aktif setelah jam 22:00 WIB.',
        icon: Icons.nightlight_round,
        accentColor: Color(0xFF6366F1),
        isUnlocked: false,
        xpReward: 120,
        progress: 0.40,
      ),
    ],
  );
});
