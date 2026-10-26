import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/confetti_widget.dart';
import '../../../roadmap/data/roadmap_repository.dart';
import '../../../roadmap/presentation/widgets/course_video_modal.dart';
import '../providers/quiz_provider.dart';

class ActiveRecallScreen extends ConsumerWidget {
  const ActiveRecallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/dashboard'),
        ),
        title: const Text(
          'Active Recall Session',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                const Icon(Icons.bolt_rounded, color: AppColors.xpGold, size: 16),
                const SizedBox(width: 4),
                Text(
                  '+${quizState.earnedXp} XP',
                  style: const TextStyle(
                    color: AppColors.xpGold,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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
            child: quizState.isCompleted
                ? _buildResultScreen(context, ref, quizState, quizNotifier)
                : _buildQuizQuestionBody(context, ref, quizState, quizNotifier),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: BottomNavigationBar(
              currentIndex: 2,
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

  // ==========================================
  // 1. TAMPILAN SOAL KUIS AKTIF
  // ==========================================
  Widget _buildQuizQuestionBody(
    BuildContext context,
    WidgetRef ref,
    QuizState state,
    QuizNotifier notifier,
  ) {
    final question = state.currentQuestion;
    final isCriticalTime = state.remainingSeconds <= 5 && !state.hasAnswered;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bar Countdown Timer & Indikator Soal
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isCriticalTime
                    ? AppColors.error.withValues(alpha: 0.6)
                    : AppColors.border,
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soal ${state.currentIndex + 1} dari ${state.totalQuestions}',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: isCriticalTime ? AppColors.error : AppColors.accentCyan,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${state.remainingSeconds}s Tersisa',
                          style: TextStyle(
                            color: isCriticalTime ? AppColors.error : AppColors.accentCyan,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  lineHeight: 7.0,
                  percent: state.timerProgress,
                  backgroundColor: AppColors.surfaceCardMuted,
                  progressColor: isCriticalTime ? AppColors.error : AppColors.accentCyan,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                  animation: false,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 250.ms),
          const SizedBox(height: 20),

          // Kotak Pertanyaan Kontras Tinggi
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        question.topic,
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '+${question.xpReward} XP',
                      style: const TextStyle(
                        color: AppColors.xpGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  question.questionText,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 20),

          // 4 Pilihan Jawaban Interaktif (<50ms feedback)
          ...List.generate(question.options.length, (index) {
            final optionText = question.options[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildOptionButton(
                index: index,
                optionText: optionText,
                state: state,
                onTap: () => notifier.selectOption(index),
              ),
            );
          }),

          // Kotak Penjelasan Rasional AI (Tampil setelah dijawab)
          if (state.hasAnswered) ...[
            const SizedBox(height: 12),
            _buildExplanationCard(context, ref, question, state),
            const SizedBox(height: 24),

            // Tombol "Pertanyaan Berikutnya"
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => notifier.nextQuestion(),
                icon: Icon(
                  state.currentIndex == state.totalQuestions - 1
                      ? Icons.emoji_events_rounded
                      : Icons.arrow_forward_rounded,
                  size: 20,
                ),
                label: Text(
                  state.currentIndex == state.totalQuestions - 1
                      ? 'Lihat Hasil Kuis'
                      : 'Pertanyaan Berikutnya',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
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
            ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.15, end: 0),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  /// Tombol Opsi Jawaban dengan Feedback Warna Langsung
  Widget _buildOptionButton({
    required int index,
    required String optionText,
    required QuizState state,
    required VoidCallback onTap,
  }) {
    final hasAnswered = state.hasAnswered;
    final isSelected = state.selectedOptionIndex == index;
    final isCorrect = state.currentQuestion.correctIndex == index;

    Color backgroundColor = AppColors.surfaceCard;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textWhite;
    Widget trailingIcon = const SizedBox.shrink();

    if (hasAnswered) {
      if (isCorrect) {
        // Jawaban Benar: Hijau Seketika
        backgroundColor = const Color(0xFF10B981).withValues(alpha: 0.18);
        borderColor = const Color(0xFF10B981);
        textColor = const Color(0xFF34D399);
        trailingIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20);
      } else if (isSelected && !isCorrect) {
        // Jawaban Salah yang Dipilih: Merah
        backgroundColor = const Color(0xFFEF4444).withValues(alpha: 0.18);
        borderColor = const Color(0xFFEF4444);
        textColor = const Color(0xFFF87171);
        trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20);
      } else {
        // Pilihan lain yang tidak dipilih
        backgroundColor = AppColors.surfaceCardMuted;
        borderColor = AppColors.border.withValues(alpha: 0.4);
        textColor = AppColors.textSubtle;
      }
    }

    final optionLabels = ['A', 'B', 'C', 'D'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasAnswered ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isSelected || (hasAnswered && isCorrect) ? 2.0 : 1.0),
            boxShadow: [
              if (hasAnswered && isCorrect)
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge Pilihan (A, B, C, D)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCardMuted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Text(
                    optionLabels[index],
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Teks Opsi Jawaban
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: isSelected || (hasAnswered && isCorrect)
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              trailingIcon,
            ],
          ),
        ),
      ),
    );
  }

  /// Kotak Penjelasan Rasional Kognitif AI
  Widget _buildExplanationCard(
    BuildContext context,
    WidgetRef ref,
    QuizQuestion question,
    QuizState state,
  ) {
    final isCorrect = question.isCorrect(state.selectedOptionIndex ?? -1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF10B981).withValues(alpha: 0.4)
              : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Color(0xFFA855F7),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Penjelasan Rasional AI',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                      : AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCorrect ? 'Jawaban Tepat!' : 'Perlu Diingat',
                  style: TextStyle(
                    color: isCorrect ? const Color(0xFF10B981) : AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.explanation,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),

          // Tombol Bantuan Video YouTube / Coursera jika mahasiswa belum paham
          InkWell(
            onTap: () {
              final syllabus = ref.read(activeSyllabusProvider);
              final matchedTopic = syllabus.topics.firstWhere(
                (t) =>
                    t.title.toLowerCase().contains(question.topic.toLowerCase()) ||
                    t.id == 'algo-04',
                orElse: () => syllabus.topics[3],
              );
              CourseVideoModal.show(context, matchedTopic);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Butuh Penjelasan Visual? Tonton Video',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Simulasi konsep interaktif & rangkuman AI',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.accentCyan,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.1, end: 0);
  }

  // ==========================================
  // 2. LAYAR HASIL KUIS (RESULT VIEW)
  // ==========================================
  Widget _buildResultScreen(
    BuildContext context,
    WidgetRef ref,
    QuizState state,
    QuizNotifier notifier,
  ) {
    final accuracy = state.accuracyPercentage;
    final isPassing = accuracy >= 60;

    return ConfettiOverlay(
      isPlaying: isPassing,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lingkaran Akurasi Kognitif
              CircularPercentIndicator(
                radius: 65.0,
              lineWidth: 12.0,
              animation: true,
              percent: state.accuracyRate,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$accuracy%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 26.0,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const Text(
                    'Akurasi',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSubtle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: isPassing ? AppColors.accentCyan : AppColors.xpGold,
              backgroundColor: AppColors.surfaceCardMuted,
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),

            // Judul Evaluasi
            Text(
              isPassing ? 'Sesi Kognitif Selesai! 🎉' : 'Perlu Pengulangan Konsep 💡',
              style: const TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.4,
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),

            Text(
              'Anda menjawab benar ${state.correctCount} dari ${state.totalQuestions} soal (${state.wrongCount} salah).',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 28),

            // Badge Reward XP dengan Animasi Fade / Scale
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: AppColors.xpGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.xpGold.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primaryNavy,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '+${state.earnedXp} XP Didapatkan!',
                    style: const TextStyle(
                      color: AppColors.primaryNavy,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(delay: 400.ms, duration: 400.ms, curve: Curves.easeOutBack)
                .fadeIn(),
            const SizedBox(height: 36),

            // Tombol Aksi: Kembali ke Roadmap & Leaderboard & Ulangi Kuis
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/roadmap'),
                icon: const Icon(Icons.route_rounded, size: 20),
                label: const Text(
                  'Kembali ke Roadmap',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
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
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/leaderboard'),
                icon: const Icon(Icons.emoji_events_rounded, color: AppColors.xpGold, size: 18),
                label: const Text(
                  'Lihat Peringkat di Leaderboard',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.xpGold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.xpGold,
                  side: BorderSide(color: AppColors.xpGold.withValues(alpha: 0.6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 550.ms),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => notifier.resetQuiz(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'Ulangi Kuis Aktif',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentCyan,
                  side: const BorderSide(color: AppColors.accentCyan),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    ),
  );
}
}
