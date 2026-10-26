import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/node_topic.dart';

class CourseVideoModal extends StatefulWidget {
  final NodeTopic topic;

  const CourseVideoModal({
    super.key,
    required this.topic,
  });

  static void show(BuildContext context, NodeTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CourseVideoModal(topic: topic),
    );
  }

  @override
  State<CourseVideoModal> createState() => _CourseVideoModalState();
}

class _CourseVideoModalState extends State<CourseVideoModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _playbackTimer;

  bool _isPlaying = true;
  int _currentSeconds = 0;
  late int _totalSeconds;
  double _playbackSpeed = 1.0;
  final List<double> _speeds = [1.0, 1.25, 1.5, 2.0];
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _totalSeconds = _parseDurationToSeconds(widget.topic.videoDuration);
    _startTimer();
  }

  int _parseDurationToSeconds(String durationStr) {
    final parts = durationStr.trim().split(':');
    if (parts.length == 2) {
      final mins = int.tryParse(parts[0]) ?? 10;
      final secs = int.tryParse(parts[1]) ?? 0;
      return (mins * 60) + secs;
    }
    return 600; // default 10 mins
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    final minsStr = mins.toString().padLeft(2, '0');
    final secsStr = remainingSecs.toString().padLeft(2, '0');
    return '$minsStr:$secsStr';
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    // Gunakan interval 1 detik disesuaikan kecepatan
    final intervalMs = (1000 / _playbackSpeed).round();
    _playbackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!_isPlaying) return;

      if (_currentSeconds < _totalSeconds) {
        setState(() {
          _currentSeconds++;
        });
      } else {
        setState(() {
          _isPlaying = false;
          _hasFinished = true;
        });
        timer.cancel();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying && _hasFinished) {
        _currentSeconds = 0;
        _hasFinished = false;
      }
    });
    if (_isPlaying) {
      _startTimer();
    } else {
      _playbackTimer?.cancel();
    }
  }

  void _seekTo(int seconds) {
    setState(() {
      _currentSeconds = seconds.clamp(0, _totalSeconds);
      _hasFinished = _currentSeconds >= _totalSeconds;
    });
  }

  void _restartFromBeginning() {
    setState(() {
      _currentSeconds = 0;
      _hasFinished = false;
      _isPlaying = true;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;
    final progress = _totalSeconds == 0 ? 0.0 : (_currentSeconds / _totalSeconds).clamp(0.0, 1.0);

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      child: Column(
        children: [
          // Drag handle pill
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.smart_display_rounded,
                        color: Color(0xFFEF4444),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Video Penunjang Kuliah',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSubtle),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ==========================================
          // 1. PEMUTAR VIDEO DENGAN TIMER BERJALAN AKTIF
          // ==========================================
          _buildVideoPlayerSurface(topic, progress),
          const SizedBox(height: 12),

          // Tab Bar Navigasi (Ringkasan & Diskusi AI)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.5)),
              ),
              labelColor: AppColors.accentCyan,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(
                  icon: Icon(Icons.menu_book_rounded, size: 16),
                  text: 'Ringkasan Materi',
                ),
                Tab(
                  icon: Icon(Icons.smart_toy_outlined, size: 16),
                  text: 'Tanya AI Tutor',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tab View Body
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCourseSummaryTab(topic),
                _buildAiDiscussionTab(topic),
              ],
            ),
          ),

          // ==========================================
          // 3. ACTION FOOTER: MULAI KUIS DIAGNOSTIK
          // ==========================================
          _buildActionFooter(context, topic),
        ],
      ),
    );
  }

  /// 1. Tampilan Player Video Interaktif dengan Timer Aktif
  Widget _buildVideoPlayerSurface(NodeTopic topic, double progress) {
    final currentTimeStr = _formatTime(_currentSeconds);
    final totalTimeStr = _formatTime(_totalSeconds);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 205,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isPlaying
              ? AppColors.accentCyan.withValues(alpha: 0.5)
              : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Background Canvas Simulasi Visual Kuliah
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E293B),
                    const Color(0xFF0A0F1D).withValues(alpha: 0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(12, (index) {
                        final waveHeight = _isPlaying
                            ? (16 + ((index * 7 + _currentSeconds * 5) % 36)).toDouble()
                            : 12.0;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 4,
                          height: waveHeight,
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(
                              alpha: _isPlaying ? 0.7 : 0.25,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isPlaying
                          ? 'Sedang Memutar Kuliah Kognitif...'
                          : (_hasFinished ? 'Video Selesai Ditonton 🎉' : 'Jeda (Paused)'),
                      style: TextStyle(
                        color: _isPlaying ? AppColors.accentCyan : AppColors.textSubtle,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Video Title & Badge YouTube
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      topic.videoTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 4),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
                        SizedBox(width: 3),
                        Text(
                          'YouTube HD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Center Controls: Rewind 10s, Play/Pause, Forward 10s, Restart
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Putar dari Awal
                  IconButton(
                    tooltip: 'Putar dari Awal (00:00)',
                    icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70, size: 24),
                    onPressed: _restartFromBeginning,
                  ),
                  const SizedBox(width: 6),

                  // Mundur 10 detik
                  IconButton(
                    tooltip: 'Mundur 10 Detik',
                    icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                    onPressed: () => _seekTo(_currentSeconds - 10),
                  ),
                  const SizedBox(width: 10),

                  // Tombol Play / Pause Utama
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentCyan.withValues(alpha: 0.5),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: AppColors.primaryNavy,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Maju 10 detik
                  IconButton(
                    tooltip: 'Maju 10 Detik',
                    icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                    onPressed: () => _seekTo(_currentSeconds + 10),
                  ),
                ],
              ),
            ),

            // Bottom Controls Bar (Scrubber & Waktu Berjalan)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Slider scrubber yang bisa digeser kapan saja
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        activeTrackColor: AppColors.accentCyan,
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
                        thumbColor: AppColors.accentCyan,
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (val) {
                          _seekTo((val * _totalSeconds).round());
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Waktu berjalan aktual (00:00 -> selesai)
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isPlaying ? const Color(0xFF10B981) : Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$currentTimeStr / $totalTimeStr',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Tombol Kecepatan Putar
                            PopupMenuButton<double>(
                              initialValue: _playbackSpeed,
                              onSelected: (speed) {
                                setState(() {
                                  _playbackSpeed = speed;
                                });
                                if (_isPlaying) _startTimer();
                              },
                              color: AppColors.surfaceCard,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${_playbackSpeed}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              itemBuilder: (ctx) => _speeds.map((s) {
                                return PopupMenuItem(
                                  value: s,
                                  child: Text(
                                    '${s}x',
                                    style: TextStyle(
                                      color: s == _playbackSpeed ? AppColors.accentCyan : AppColors.textWhite,
                                      fontWeight: s == _playbackSpeed ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(width: 10),

                            // Salin Tautan YouTube
                            GestureDetector(
                              onTap: () {
                                final ytUrl = 'https://www.youtube.com/watch?v=${topic.youtubeVideoId}';
                                Clipboard.setData(ClipboardData(text: ytUrl));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tautan YouTube disalin: $ytUrl'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.open_in_new_rounded,
                                color: Colors.white70,
                                size: 18,
                              ),
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
    );
  }

  /// 2. Tab Ringkasan Materi Ala Coursera
  Widget _buildCourseSummaryTab(NodeTopic topic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dosen & Pembuat Konten
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.school_rounded, color: AppColors.primaryNavy, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        topic.videoAuthor,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: AppColors.accentCyan, size: 14),
                    ],
                  ),
                  const Text(
                    'Materi Terverifikasi Kurikulum Komputasi',
                    style: TextStyle(color: AppColors.textSubtle, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ringkasan Transkrip Video
          if (topic.transcriptSummary.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: Color(0xFFA855F7), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Ringkasan AI dari Video',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topic.transcriptSummary,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Poin-poin Konsep Kunci (Key Takeaways)
          if (topic.keyTakeaways.isNotEmpty) ...[
            const Text(
              'Poin Kunci Konsep (Key Takeaways)',
              style: TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            ...topic.keyTakeaways.map((takeaway) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accentCyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        takeaway,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Contoh Potongan Kode Implementasi
          if (topic.codeSnippet.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Implementasi Kode (${topic.codeLanguage})',
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: topic.codeSnippet));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode berhasil disalin ke clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.copy_rounded, color: AppColors.accentCyan, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Salin',
                        style: TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0B132B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SelectableText(
                topic.codeSnippet,
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  /// 3. Tab Diskusi & Bantuan AI Tutor
  Widget _buildAiDiscussionTab(NodeTopic topic) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFA855F7).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: Color(0xFFA855F7),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Belum Paham Video Ini?',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tanyakan bagian yang membingungkan ke AI Tutor kognitif.',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Pertanyaan Populer Terkait Materi Ini:',
            style: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),

          _buildQuestionChip(
            'Bisakah jelaskan dengan analogi kehidupan nyata?',
            () {
              Navigator.pop(context);
              context.go('/ai-tutor');
            },
          ),
          const SizedBox(height: 8),
          _buildQuestionChip(
            'Kapan saya harus memakai struktur ini dalam proyek nyata?',
            () {
              Navigator.pop(context);
              context.go('/ai-tutor');
            },
          ),
          const SizedBox(height: 8),
          _buildQuestionChip(
            'Mengapa terjadi error jika kondisinya tidak terpenuhi?',
            () {
              Navigator.pop(context);
              context.go('/ai-tutor');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionChip(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.accentCyan, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: AppColors.textWhite, fontSize: 13),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSubtle, size: 12),
          ],
        ),
      ),
    );
  }

  /// 4. Tombol Aksi di Bawah: Mulai Kuis Diagnostik Topik Ini
  Widget _buildActionFooter(BuildContext context, NodeTopic topic) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            context.go('/active-recall');
          },
          icon: const Icon(Icons.quiz_rounded, size: 18),
          label: Text(
            'Selesai Menonton • Mulai Kuis (+${topic.xpReward} XP)',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentCyan,
            foregroundColor: AppColors.primaryNavy,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
