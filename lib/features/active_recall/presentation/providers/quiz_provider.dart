import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quiz_question.dart';

export '../../data/models/quiz_question.dart';

class QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedOptionIndex;
  final bool hasAnswered;
  final int correctCount;
  final int wrongCount;
  final int earnedXp;
  final bool isCompleted;
  final int remainingSeconds;
  final int maxSeconds;

  const QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.hasAnswered = false,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.earnedXp = 0,
    this.isCompleted = false,
    this.remainingSeconds = 25,
    this.maxSeconds = 25,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  double get accuracyRate =>
      totalQuestions == 0 ? 0.0 : (correctCount / totalQuestions);
  int get accuracyPercentage => (accuracyRate * 100).toInt();
  double get timerProgress => (remainingSeconds / maxSeconds).clamp(0.0, 1.0);

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedOptionIndex,
    bool? hasAnswered,
    int? correctCount,
    int? wrongCount,
    int? earnedXp,
    bool? isCompleted,
    int? remainingSeconds,
    int? maxSeconds,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      earnedXp: earnedXp ?? this.earnedXp,
      isCompleted: isCompleted ?? this.isCompleted,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      maxSeconds: maxSeconds ?? this.maxSeconds,
    );
  }
}

class QuizNotifier extends Notifier<QuizState> {
  Timer? _countdownTimer;

  static const List<QuizQuestion> defaultQuestions = [
    QuizQuestion(
      id: 'q-01',
      questionText:
          'Manakah pernyataan yang paling tepat mengenai perbedaan mendasar antara perulangan "for" dan "while"?',
      options: [
        'For hanya bisa untuk tipe integer, while hanya untuk boolean.',
        'For umumnya dipakai saat jumlah iterasi sudah diketahui pasti, sedangkan while saat batas perulangan bergantung kondisi dinamis.',
        'While mengeksekusi lebih cepat daripada for di tingkat CPU register.',
        'For tidak mendukung klausa break, sedangkan while mendukung.',
      ],
      correctIndex: 1,
      explanation:
          'For loop dirancang untuk counted loops (jumlah putaran terukur jelas). Sedangkan While loop mengevaluasi kondisi secara dinamis di setiap awal iterasi hingga kondisi berubah menjadi false.',
      xpReward: 30,
    ),
    QuizQuestion(
      id: 'q-02',
      questionText:
          'Apa yang akan terjadi jika sebuah fungsi rekursif tidak mendefinisikan "Base Case"?',
      options: [
        'Program langsung memunculkan peringatan syntax error saat dikompilasi.',
        'Nilai kembalian fungsi otomatis menjadi null atau bernilai 0.',
        'Terjadi Stack Overflow karena pemanggilan frame fungsi menumpuk tanpa henti di memori call stack.',
        'Perulangan otomatis beralih menjadi iterasi for loop.',
      ],
      correctIndex: 2,
      explanation:
          'Base Case adalah syarat mutlak penghenti rekursi. Tanpa Base Case, fungsi akan terus memanggil dirinya sendiri sampai kapasitas Call Stack habis dan memicu crash Stack Overflow.',
      xpReward: 30,
    ),
    QuizQuestion(
      id: 'q-03',
      questionText:
          'Berapa kompleksitas waktu (Big-O) untuk mengakses elemen pada Array menggunakan indeks langsung (contoh: arr[4])?',
      options: [
        'O(1) - Akses waktu konstan via formula pointer offset memori.',
        'O(n) - Komputer harus memeriksa satu per satu elemen dari indeks 0.',
        'O(log n) - Menggunakan teknik binary search internal.',
        'O(n²) - Jika ukuran array melebihi 1000 elemen.',
      ],
      correctIndex: 0,
      explanation:
          'Array dialokasikan secara bersebelahan (contiguous) di memori fisik. Alamat elemen dihitung instan dengan rumus: [Base Address + (Indeks × Ukuran Elemen)], menghasilkan kompleksitas O(1).',
      xpReward: 30,
    ),
    QuizQuestion(
      id: 'q-04',
      questionText:
          'Apa fungsi utama dari kata kunci "break" di dalam sebuah perulangan bersarang (nested loop)?',
      options: [
        'Menghentikan seluruh proses eksekusi aplikasi secara permanen.',
        'Menghentikan satu level perulangan terdalam tempat break tersebut dipanggil.',
        'Melewati satu iterasi saat ini dan langsung meloncat ke iterasi berikutnya.',
        'Mengembalikan nilai output fungsi ke pemanggil utama.',
      ],
      correctIndex: 1,
      explanation:
          'Kata kunci "break" menghentikan eksekusi perulangan terdekat (innermost loop). Untuk melompati satu putaran iterasi tanpa keluar dari loop, gunakan kata kunci "continue".',
      xpReward: 30,
    ),
    QuizQuestion(
      id: 'q-05',
      questionText:
          'Dalam analisis efisiensi algoritma, manakah laju pertumbuhan waktu yang paling optimal untuk input data berukuran besar?',
      options: [
        'O(n²) - Quadratic Time Complexity',
        'O(2ⁿ) - Exponential Time Complexity',
        'O(n) - Linear Time Complexity',
        'O(log n) - Logarithmic Time Complexity',
      ],
      correctIndex: 3,
      explanation:
          'O(log n) membagi ruang pencarian menjadi setengah di setiap langkahnya (seperti binary search). Laju pertumbuhannya jauh lebih lambat dan sangat efisien untuk dataset masif dibanding O(n), O(n²), dan O(2ⁿ).',
      xpReward: 30,
    ),
  ];

  @override
  QuizState build() {
    ref.onDispose(() {
      _countdownTimer?.cancel();
    });
    _startTimer();
    return const QuizState(questions: defaultQuestions);
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.hasAnswered || state.isCompleted) {
        timer.cancel();
        return;
      }
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        // Waktu habis! Otomatis tandai salah dan tampilkan pembahasan
        timer.cancel();
        _timeOutAnswer();
      }
    });
  }

  void _timeOutAnswer() {
    if (state.hasAnswered || state.isCompleted) return;
    state = state.copyWith(
      selectedOptionIndex: -1, // waktu habis
      hasAnswered: true,
      wrongCount: state.wrongCount + 1,
      remainingSeconds: 0,
    );
  }

  /// Memilih opsi jawaban (langsung merubah warna tombol seketika <50ms)
  void selectOption(int optionIndex) {
    if (state.hasAnswered || state.isCompleted) return;
    _countdownTimer?.cancel();

    final isCorrect = state.currentQuestion.isCorrect(optionIndex);
    final earned = isCorrect ? state.currentQuestion.xpReward : 0;

    state = state.copyWith(
      selectedOptionIndex: optionIndex,
      hasAnswered: true,
      correctCount: isCorrect ? state.correctCount + 1 : state.correctCount,
      wrongCount: isCorrect ? state.wrongCount : state.wrongCount + 1,
      earnedXp: state.earnedXp + earned,
    );
  }

  /// Pindah ke pertanyaan berikutnya atau selesaikan kuis
  void nextQuestion() {
    if (state.currentIndex < state.totalQuestions - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedOptionIndex: null,
        hasAnswered: false,
        remainingSeconds: 25,
      );
      _startTimer();
    } else {
      _countdownTimer?.cancel();
      state = state.copyWith(isCompleted: true);
    }
  }

  /// Reset kuis untuk mengulang dari awal
  void resetQuiz() {
    _countdownTimer?.cancel();
    state = const QuizState(questions: defaultQuestions);
    _startTimer();
  }
}

final quizProvider = NotifierProvider<QuizNotifier, QuizState>(
  QuizNotifier.new,
);
