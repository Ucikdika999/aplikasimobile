import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentProfileData {
  final String name;
  final String initials;
  final String programStudy;
  final int streakDays;
  final int level;
  final String levelTitle;
  final int currentLevelXp;
  final int nextLevelXp;

  const StudentProfileData({
    required this.name,
    required this.initials,
    required this.programStudy,
    required this.streakDays,
    required this.level,
    required this.levelTitle,
    required this.currentLevelXp,
    required this.nextLevelXp,
  });

  double get levelProgress => (currentLevelXp / nextLevelXp).clamp(0.0, 1.0);
}

class ActiveModuleData {
  final String id;
  final String title;
  final String topic;
  final String difficulty;
  final double progress;
  final int remainingMinutes;

  const ActiveModuleData({
    required this.id,
    required this.title,
    required this.topic,
    required this.difficulty,
    required this.progress,
    required this.remainingMinutes,
  });

  int get progressPercentage => (progress * 100).toInt();
}

class RecommendedModuleData {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final int xpReward;
  final int estimatedMinutes;
  final int aiMatchScore;
  final String reason;

  const RecommendedModuleData({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.xpReward,
    required this.estimatedMinutes,
    required this.aiMatchScore,
    required this.reason,
  });
}

class StudentDashboardState {
  final StudentProfileData profile;
  final ActiveModuleData activeModule;
  final List<RecommendedModuleData> recommendations;

  const StudentDashboardState({
    required this.profile,
    required this.activeModule,
    required this.recommendations,
  });
}

final studentDashboardProvider = Provider<StudentDashboardState>((ref) {
  return const StudentDashboardState(
    profile: StudentProfileData(
      name: 'Alex Pratama',
      initials: 'AP',
      programStudy: 'D3 Teknik Informatika',
      streakDays: 14,
      level: 10,
      levelTitle: 'Master',
      currentLevelXp: 2450,
      nextLevelXp: 3000,
    ),
    activeModule: ActiveModuleData(
      id: 'active-mod-101',
      title: 'Looping & Iterasi (For vs While)',
      topic: 'Optimasi Kompleksitas O(n) & Early Break',
      difficulty: 'Pemula',
      progress: 0.67,
      remainingMinutes: 12,
    ),
    recommendations: [
      RecommendedModuleData(
        id: 'rec-01',
        title: 'Binary Search Tree Traversal',
        category: 'Struktur Data Lanjut',
        difficulty: 'Menengah',
        xpReward: 120,
        estimatedMinutes: 15,
        aiMatchScore: 96,
        reason: 'Penguatan konsep rekursif & pointer memori',
      ),
      RecommendedModuleData(
        id: 'rec-02',
        title: 'Dynamic Programming: Memoization',
        category: 'Desain Algoritma',
        difficulty: 'Lanjut',
        xpReward: 180,
        estimatedMinutes: 25,
        aiMatchScore: 91,
        reason: 'Optimal untuk persiapan ujian algoritma tengah semester',
      ),
      RecommendedModuleData(
        id: 'rec-03',
        title: 'Graph Representation: Adjacency List',
        category: 'Matematika Diskrit',
        difficulty: 'Menengah',
        xpReward: 140,
        estimatedMinutes: 20,
        aiMatchScore: 88,
        reason: 'Melengkapi pemahaman traversal graf BFS & DFS',
      ),
    ],
  );
});

// Backward compatibility stats provider
class DashboardStats {
  final int streakDays;
  final int totalXp;
  final double masteryRate;
  final int activeReviewCards;

  const DashboardStats({
    required this.streakDays,
    required this.totalXp,
    required this.masteryRate,
    required this.activeReviewCards,
  });
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  return const DashboardStats(
    streakDays: 14,
    totalXp: 4850,
    masteryRate: 0.82,
    activeReviewCards: 18,
  );
});
