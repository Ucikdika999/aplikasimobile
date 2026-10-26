class LeaderboardEntry {
  final int rank;
  final String name;
  final String initials;
  final String programStudy;
  final int totalXp;
  final int streakDays;
  final bool isCurrentUser;
  final int rankChange; // positive = naik, negative = turun, 0 = tetap

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.initials,
    required this.programStudy,
    required this.totalXp,
    required this.streakDays,
    this.isCurrentUser = false,
    this.rankChange = 0,
  });
}
