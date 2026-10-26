import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const TutorChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}

class TutorChatNotifier extends Notifier<List<TutorChatMessage>> {
  @override
  List<TutorChatMessage> build() {
    return [
      TutorChatMessage(
        id: 'init-1',
        message:
            'Halo! Saya Tutor Kognitif AI dari Nexed AI. 🤖\n\n'
            'Tanyakan konsep pemrograman yang ingin Anda pahami, minta penjelasan analogi sederhana, atau diskusikan kode yang membingungkan. Mari kita pelajari bersama secara bertahap!',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final userMsg = TutorChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = [...state, userMsg];

    // Simulasi respon AI Sokrates dalam Bahasa Indonesia
    Future.delayed(const Duration(milliseconds: 700), () {
      final reply = _generateIndonesianResponse(text.toLowerCase());
      final aiMsg = TutorChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        message: reply,
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = [...state, aiMsg];
    });
  }

  String _generateIndonesianResponse(String query) {
    if (query.contains('algoritma') || query.contains('pemrograman')) {
      return 'Tentu! Algoritma pemrograman pada dasarnya adalah urutan langkah-langkah logis dan terstruktur yang disusun untuk menyelesaikan suatu masalah komputasi secara sistematis.\n\n'
          '💡 Analogi Sederhana:\n'
          'Bayangkan resep membuat nasi goreng. Anda memiliki masukan (nasi, bumbu), proses langkah demi langkah yang tidak boleh terbalik (panaskan wajan -> tumis bumbu -> masukkan nasi), dan hasil akhir (nasi goreng siap saji).\n\n'
          'Dalam pemrograman, komputer membutuhkan instruksi yang sangat spesifik dan runtut seperti itu. Apakah Anda ingin melihat contoh logika percabangan (if-else) atau perulangan (loop)?';
    } else if (query.contains('loop') || query.contains('perulangan') || query.contains('while') || query.contains('for')) {
      return 'Perulangan (Looping) digunakan untuk mengeksekusi blok kode berulang kali tanpa harus menulis ulang kode tersebut.\n\n'
          '• For Loop: Cocok digunakan saat jumlah perulangan sudah kita ketahui pasti (misal: jalankan 10 kali).\n'
          '• While Loop: Digunakan saat perulangan bergantung pada suatu kondisi yang belum tentu kapan berhentinya (misal: ulangi selama baterai > 20%).\n\n'
          '❓ Tantangan Kognitif: Menurut Anda, apa yang akan terjadi jika kondisi pada while loop selalu bernilai benar (True) dan tidak pernah berhenti?';
    } else if (query.contains('array') || query.contains('list') || query.contains('struktur data')) {
      return 'Array adalah struktur data linear yang menyimpan kumpulan data bertipe sama dalam deretan memori yang berdekatan.\n\n'
          'Kelebihan utama Array adalah pencarian data sangat cepat melalui index (O(1)). Namun, ukurannya umumnya tetap sejak awal dialokasikan.\n\n'
          'Ingin saya berikan contoh perbedaannya dengan Linked List?';
    } else if (query.contains('fungsi') || query.contains('rekursi') || query.contains('function')) {
      return 'Fungsi adalah sub-program modular yang membungkus logika tertentu agar dapat digunakan kembali (reusable) di berbagai tempat.\n\n'
          'Sedangkan Rekursi adalah teknik di mana suatu fungsi memanggil dirinya sendiri untuk memecah masalah besar menjadi masalah kecil, sampai mencapai kondisi berhenti (*base case*).\n\n'
          'Apakah Anda ingin melihat contoh rekursi pada perhitungan faktorial?';
    } else {
      return 'Pertanyaan yang sangat menarik mengenai "$query"!\n\n'
          'Sebagai Tutor Kognitif Anda, mari kita pelajari konsep ini secara sistematis. Bagian mana yang paling ingin Anda dalami terlebih dahulu: definisinya, contoh kode penerapannya, atau analogi kasus di dunia nyata?';
    }
  }
}

final tutorChatProvider =
    NotifierProvider<TutorChatNotifier, List<TutorChatMessage>>(
  TutorChatNotifier.new,
);
