enum NodeStatus {
  completed,
  inProgress,
  locked;

  bool get isCompleted => this == NodeStatus.completed;
  bool get isInProgress => this == NodeStatus.inProgress;
  bool get isLocked => this == NodeStatus.locked;

  String get label {
    switch (this) {
      case NodeStatus.completed:
        return 'Selesai';
      case NodeStatus.inProgress:
        return 'Sedang Berjalan';
      case NodeStatus.locked:
        return 'Terkunci';
    }
  }
}

class NodeTopic {
  final String id;
  final String title;
  final String? prerequisiteId;
  final NodeStatus status;
  final int xpReward;
  final String description;
  final int estimatedMinutes;
  final String difficulty;

  // Fitur Video Pembelajaran & Materi Ala Coursera
  final String videoTitle;
  final String videoAuthor;
  final String videoDuration;
  final String youtubeVideoId;
  final List<String> keyTakeaways;
  final String codeSnippet;
  final String codeLanguage;
  final String transcriptSummary;

  const NodeTopic({
    required this.id,
    required this.title,
    this.prerequisiteId,
    required this.status,
    required this.xpReward,
    required this.description,
    this.estimatedMinutes = 15,
    this.difficulty = 'Dasar',
    this.videoTitle = 'Kuliah Kognitif: Konsep & Implementasi',
    this.videoAuthor = 'Dr. Aris Sudrajat • Dosen Komputasi',
    this.videoDuration = '10:30',
    this.youtubeVideoId = 'dQw4w9WgXcQ',
    this.keyTakeaways = const [],
    this.codeSnippet = '',
    this.codeLanguage = 'Dart',
    this.transcriptSummary = '',
  });

  NodeTopic copyWith({
    String? id,
    String? title,
    String? prerequisiteId,
    NodeStatus? status,
    int? xpReward,
    String? description,
    int? estimatedMinutes,
    String? difficulty,
    String? videoTitle,
    String? videoAuthor,
    String? videoDuration,
    String? youtubeVideoId,
    List<String>? keyTakeaways,
    String? codeSnippet,
    String? codeLanguage,
    String? transcriptSummary,
  }) {
    return NodeTopic(
      id: id ?? this.id,
      title: title ?? this.title,
      prerequisiteId: prerequisiteId ?? this.prerequisiteId,
      status: status ?? this.status,
      xpReward: xpReward ?? this.xpReward,
      description: description ?? this.description,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      difficulty: difficulty ?? this.difficulty,
      videoTitle: videoTitle ?? this.videoTitle,
      videoAuthor: videoAuthor ?? this.videoAuthor,
      videoDuration: videoDuration ?? this.videoDuration,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      keyTakeaways: keyTakeaways ?? this.keyTakeaways,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      codeLanguage: codeLanguage ?? this.codeLanguage,
      transcriptSummary: transcriptSummary ?? this.transcriptSummary,
    );
  }
}

