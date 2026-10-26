import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/node_topic.dart';

export 'models/node_topic.dart';

class SyllabusData {
  final String id;
  final String title;
  final String description;
  final String semester;
  final List<NodeTopic> topics;

  const SyllabusData({
    required this.id,
    required this.title,
    required this.description,
    required this.semester,
    required this.topics,
  });

  int get completedCount => topics.where((t) => t.status.isCompleted).length;
  int get totalCount => topics.length;
  double get progressPercentage => totalCount == 0 ? 0 : completedCount / totalCount;
  int get totalXpEarned => topics
      .where((t) => t.status.isCompleted)
      .fold(0, (sum, t) => sum + t.xpReward);
}

final activeSyllabusProvider = Provider<SyllabusData>((ref) {
  return const SyllabusData(
    id: 'syl-algo-pemrograman',
    title: 'Algoritma & Pemrograman',
    description: 'Kurikulum pondasi pemikiran komputasional, logika percabangan, iterasi adaptif, hingga optimasi memori.',
    semester: 'Semester 1 • Mata Kuliah Wajib',
    topics: [
      NodeTopic(
        id: 'algo-01',
        title: 'Pengantar Algoritma & Flowchart',
        prerequisiteId: null,
        status: NodeStatus.completed,
        xpReward: 100,
        estimatedMinutes: 10,
        difficulty: 'Pemula',
        videoTitle: 'Visualisasi Alur Logika & Diagram Alir Standar IEEE',
        videoAuthor: 'Dr. Aris Sudrajat • Dosen Algoritma UI',
        videoDuration: '08:45',
        youtubeVideoId: 'kUMe1FH4CHE',
        description: 'Memahami prinsip komputasi prosedural, perancangan diagram alir logika (flowchart), dan pseudo-code standar IEEE.',
        transcriptSummary: 'Video ini membahas dasar pemikiran algoritmik dari sudut pandang mesin komputasi. Anda akan diajak memahami bagaimana memecah masalah besar menjadi urutan instruksi deterministik yang tidak ambigu.',
        keyTakeaways: [
          'Algoritma harus bersifat finite (memiliki akhir berhenti).',
          'Simbol belah ketupat pada flowchart mewakili keputusan kondisional bercabang.',
          'Pseudo-code mempermudah penerjemahan logika ke berbagai bahasa pemrograman.',
        ],
        codeSnippet: '// Pseudo-code mencari bilangan genap\nALGORITMA CekGenap(n: Integer)\n  JIKA n MOD 2 == 0 MAKA\n    OUTPUT "Genap"\n  LAINNYA\n    OUTPUT "Ganjil"\nAKHIR',
        codeLanguage: 'Pseudo-Code',
      ),
      NodeTopic(
        id: 'algo-02',
        title: 'Tipe Data, Variabel & I/O',
        prerequisiteId: 'algo-01',
        status: NodeStatus.completed,
        xpReward: 120,
        estimatedMinutes: 15,
        difficulty: 'Pemula',
        videoTitle: 'Arsitektur Memori: Stack vs Heap & Buffer I/O',
        videoAuthor: 'Nexed Computer Science Labs',
        videoDuration: '11:20',
        youtubeVideoId: '_uQrJ0TkZlc',
        description: 'Alokasi memori stack vs heap untuk tipe primitif (integer, float, char), scoping variabel, dan stream buffer input/output.',
        transcriptSummary: 'Penjelasan mendalam bagaimana CPU mengalokasikan byte untuk tipe data primitif secara instan di Stack, serta perbedaannya dengan objek referensial di Heap memory.',
        keyTakeaways: [
          'Tipe data primitif (int, double, bool) disimpan langsung di Call Stack.',
          'Variabel memiliki lifecycle dan scope lokal di dalam blok kurung kurawal.',
          'Buffer input/output mencegah lag saat membaca data masal (bulk data).',
        ],
        codeSnippet: 'void main() {\n  int age = 20; // 64-bit integer di stack\n  double gpa = 3.85;\n  String studentName = "Nexed Student";\n  print("Halo \$studentName, IPK: \$gpa");\n}',
        codeLanguage: 'Dart',
      ),
      NodeTopic(
        id: 'algo-03',
        title: 'Struktur Kontrol Percabangan (If-Else)',
        prerequisiteId: 'algo-02',
        status: NodeStatus.completed,
        xpReward: 150,
        estimatedMinutes: 20,
        difficulty: 'Pemula',
        videoTitle: 'Logika Boolean & Optimasi Percabangan Kompleks',
        videoAuthor: 'Prof. Budi Santoso • Teknik Informatika',
        videoDuration: '13:10',
        youtubeVideoId: '8jLOx1hD3_o',
        description: 'Evaluasi boolean algebra, tabel kebenaran logika kondisional, ternary operator, dan switch-case jump tables.',
        transcriptSummary: 'Mempelajari cara CPU mengevaluasi operator logika short-circuiting (&& dan ||), serta kapan harus memilih switch-case dibanding percabangan if-else bersarang.',
        keyTakeaways: [
          'Short-circuit evaluation: jika kondisi pertama pada AND sudah false, sisa ekspresi dilewati.',
          'Gunakan guard clauses untuk mereduksi indentation tangga if-else yang dalam.',
          'Switch-case pada banyak compiler dioptimalkan menjadi Jump Table dengan kompleksitas O(1).',
        ],
        codeSnippet: 'String getGrade(double score) {\n  if (score >= 85) return "A";\n  if (score >= 70) return "B";\n  if (score >= 55) return "C";\n  return "D";\n}',
        codeLanguage: 'Dart',
      ),
      NodeTopic(
        id: 'algo-04',
        title: 'Looping & Iterasi (For vs While)',
        prerequisiteId: 'algo-03',
        status: NodeStatus.inProgress,
        xpReward: 180,
        estimatedMinutes: 25,
        difficulty: 'Menengah',
        videoTitle: 'Deep Dive: Loop Invariant & Membedah For vs While',
        videoAuthor: 'Dr. Aris Sudrajat • Dosen Algoritma UI',
        videoDuration: '14:50',
        youtubeVideoId: 'f5OD9CKrZEw',
        description: 'Mekanisme loop counters, invariant perulangan, infinite loop hazards, dan teknik optimasi early termination (break/continue).',
        transcriptSummary: 'Kuliah interaktif ini membedah kapan sebuah masalah membutuhkan For loop (iterasi terhitung) dan kapan harus menggunakan While loop (kondisi dinamis). Lengkap dengan simulasi memori dan eksekusi instruksi register.',
        keyTakeaways: [
          'For loop ideal untuk array/list dengan panjang elemen yang pasti.',
          'While loop mengevaluasi syarat di awal, sedangkan Do-While menjamin minimal 1 kali dieksekusi.',
          'Gunakan break untuk early termination dan menghemat siklus CPU yang tidak perlu.',
        ],
        codeSnippet: '// For Loop vs While Loop\nfor (int i = 0; i < 5; i++) {\n  print("Iterasi ke-\$i");\n}\n\nint attempts = 0;\nwhile (!isConnected && attempts < 3) {\n  tryReconnect();\n  attempts++;\n}',
        codeLanguage: 'Dart',
      ),
      NodeTopic(
        id: 'algo-05',
        title: 'Array & Manipulasi String',
        prerequisiteId: 'algo-04',
        status: NodeStatus.locked,
        xpReward: 200,
        estimatedMinutes: 30,
        difficulty: 'Menengah',
        videoTitle: 'Memori Kontigu Array & Rahasia String Immutability',
        videoAuthor: 'Nexed Cognitive Engineering',
        videoDuration: '15:15',
        youtubeVideoId: '7mK2hA2v26A',
        description: 'Representasi matriks contiguous memory, index offset formula, string immutable semantics, dan string buffer pooling.',
        transcriptSummary: 'Penjelasan mengapa array memiliki kecepatan akses O(1) karena lokasi fisik memorinya berurutan. Diikuti bedah efisiensi StringBuffer pada pengolahan teks panjang.',
        keyTakeaways: [
          'Alamat memori elemen ke-i = Alamat Awal + (i * ukuran tipe data).',
          'String bersifat immutable; modifikasi menghasilkan alokasi objek baru di memori.',
          'StringBuffer mencegah lonjakan garbage collection pada loop teks masif.',
        ],
        codeSnippet: 'List<int> numbers = [10, 20, 30, 40, 50];\n// Akses instan O(1)\nint third = numbers[2]; // 30\n\nStringBuffer buffer = StringBuffer();\nfor (var n in numbers) buffer.write("\$n ");',
        codeLanguage: 'Dart',
      ),
      NodeTopic(
        id: 'algo-06',
        title: 'Fungsi, Prosedur & Rekursi',
        prerequisiteId: 'algo-05',
        status: NodeStatus.locked,
        xpReward: 250,
        estimatedMinutes: 35,
        difficulty: 'Lanjut',
        videoTitle: 'Call Stack Frames & Rahasia Base Case Rekursi',
        videoAuthor: 'Dr. Aris Sudrajat • Dosen Algoritma UI',
        videoDuration: '17:30',
        youtubeVideoId: 'm4n2_f48XyM',
        description: 'Call stack frames, parameter passing (by value vs by reference), base case termination, dan stack overflow protection.',
        transcriptSummary: 'Visualisasi Call Stack step-by-step saat fungsi memanggil dirinya sendiri. Membedah bahaya Stack Overflow jika tidak ada kondisi batas pemberhentian (Base Case).',
        keyTakeaways: [
          'Setiap pemanggilan fungsi mengalokasikan satu Stack Frame baru.',
          'Rekursi wajib memiliki minimal satu Base Case penghenti.',
          'Tail-Call Optimization (TCO) dapat mereduksi kompleksitas memori stack dari O(n) menjadi O(1).',
        ],
        codeSnippet: 'int factorial(int n) {\n  // Base Case mutlak\n  if (n <= 1) return 1;\n  // Recursive step\n  return n * factorial(n - 1);\n}',
        codeLanguage: 'Dart',
      ),
      NodeTopic(
        id: 'algo-07',
        title: 'Kompleksitas Waktu & Big-O Notation',
        prerequisiteId: 'algo-06',
        status: NodeStatus.locked,
        xpReward: 300,
        estimatedMinutes: 40,
        difficulty: 'Lanjut',
        videoTitle: 'Mastering Big-O: Analisis Asymptotic Waktu & Ruang',
        videoAuthor: 'Nexed Algorithm Lab',
        videoDuration: '18:45',
        youtubeVideoId: 'v4cd1O4zkGw',
        description: 'Analisis asymptotic run-time O(1), O(log n), O(n), hingga O(n^2), space complexity tradeoffs, dan benchmarking algoritma.',
        transcriptSummary: 'Mempelajari cara mengukur efisiensi kode tanpa terpengaruh spesifikasi hardware. Membedah kurva pertumbuhan dari waktu konstan hingga eksponensial.',
        keyTakeaways: [
          'Big-O menggambarkan skenario terburuk (worst-case performance).',
          'O(log n) seperti Binary Search sangat unggul pada data miliaran baris.',
          'Hindari nested loops bertingkat 3 atau lebih O(n³) pada dataset dinamis.',
        ],
        codeSnippet: '// O(log n) Binary Search\nint binarySearch(List<int> arr, int target) {\n  int low = 0, high = arr.length - 1;\n  while (low <= high) {\n    int mid = (low + high) ~/ 2;\n    if (arr[mid] == target) return mid;\n    if (arr[mid] < target) low = mid + 1;\n    else high = mid - 1;\n  }\n  return -1;\n}',
        codeLanguage: 'Dart',
      ),
    ],
  );
});

// Backward compatibility provider
final nodeTopicsProvider = Provider<List<NodeTopic>>((ref) {
  return ref.watch(activeSyllabusProvider).topics;
});

class RoadmapNode {
  final String id;
  final String title;
  final String description;
  final double progress;
  final bool isLocked;
  final bool isCompleted;

  const RoadmapNode({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.isLocked,
    required this.isCompleted,
  });
}

final roadmapNodesProvider = Provider<List<RoadmapNode>>((ref) {
  final topics = ref.watch(nodeTopicsProvider);
  return topics.map((t) {
    return RoadmapNode(
      id: t.id,
      title: t.title,
      description: t.description,
      progress: t.status.isCompleted ? 1.0 : (t.status.isInProgress ? 0.65 : 0.0),
      isLocked: t.status.isLocked,
      isCompleted: t.status.isCompleted,
    );
  }).toList();
});
