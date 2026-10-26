import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardItem {
  final String id;
  final String question;
  final String answer;
  final String category;

  const FlashcardItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });
}

final activeRecallFlashcardsProvider = Provider<List<FlashcardItem>>((ref) {
  return const [
    FlashcardItem(
      id: 'card-1',
      question: 'What is the vanishing gradient problem and how does ReLU mitigate it?',
      answer: 'Vanishing gradient occurs when gradients shrink exponentially during backpropagation in deep networks. ReLU has a constant derivative of 1 for positive inputs, preventing gradient attenuation.',
      category: 'Deep Learning',
    ),
    FlashcardItem(
      id: 'card-2',
      question: 'Explain the difference between Self-Attention and Cross-Attention in Transformers.',
      answer: 'Self-attention calculates attention weights between tokens of the same sequence (Q, K, V from same source). Cross-attention calculates queries (Q) from decoder while keys (K) and values (V) originate from encoder representations.',
      category: 'NLP & Transformers',
    ),
  ];
});
