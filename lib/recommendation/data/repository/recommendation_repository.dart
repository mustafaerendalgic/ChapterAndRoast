import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gdg_campus_coffee/core/constants/secrets.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/recommendation/data/model/recommendation_model.dart';
import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';
import 'package:gdg_campus_coffee/recommendation/domain/repository/i_recommendation_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecommendationRepository implements IRecommendationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Recommendation>> getRecommendations() async {
    try {
      final snapshot = await _firestore
          .collection('recommendations')
          .orderBy('createdAt', descending: true)
          .get();
      final models = snapshot.docs.map((doc) => RecommendationModel.fromJson(doc.data())).toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      if (kDebugMode) print('Error fetching recommendations: $e');
      return [];
    }
  }

  @override
  Future<String> getAiRecommendation(String prompt, List<Product> products) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: Secrets.geminiApiKey,
      );

      final productContext = products
          .map((p) => "- ${p.name ?? 'Unknown'}: ${p.description ?? ''} (\$${p.price ?? '?'})")
          .join('\n');

      final fullPrompt = """
You are a coffee expert for GDG Campus Coffee. 
The following coffees are available in our menu:
$productContext

User Question: $prompt

Based on the menu above, give a personalized recommendation. Keep it concise and friendly. Use dollars (\$) for any price mentions.
""";

      final content = [Content.text(fullPrompt)];
      final response = await model.generateContent(content).timeout(const Duration(seconds: 15));
      
      final result = response.text ?? "I'm sorry, I couldn't generate a recommendation right now.";
      
      // Save the successful recommendation to Firestore
      await saveRecommendation(Recommendation(
        question: prompt,
        answer: result,
        createdAt: DateTime.now(),
      ));

      return result;
    } catch (e) {
      if (kDebugMode) print('Gemini API Error: $e');
      
      // Fallback logic
      final fallback = _getOfflineRecommendation(prompt, products);
      
      // Also save fallback to history so user sees something
      await saveRecommendation(Recommendation(
        question: prompt,
        answer: fallback,
        createdAt: DateTime.now(),
      ));

      return fallback;
    }
  }

  @override
  Future<void> saveRecommendation(Recommendation recommendation) async {
    try {
      final model = RecommendationModel(
        question: recommendation.question,
        answer: recommendation.answer,
        createdAt: recommendation.createdAt,
      );
      await _firestore.collection('recommendations').add(model.toJson());
    } catch (e) {
      if (kDebugMode) print('Error saving recommendation: $e');
    }
  }

  String _getOfflineRecommendation(String prompt, List<Product> products) {
    final lower = prompt.toLowerCase();
    final random = Random();

    if (lower.contains('bold') || lower.contains('strong') || lower.contains('intense') || lower.contains('wake')) {
      final espresso = products.firstWhere(
        (p) => (p.name ?? '').toLowerCase().contains('espresso'),
        orElse: () => products[random.nextInt(products.length)],
      );
      return "For something bold and intense, I'd recommend our ${espresso.name ?? 'signature blend'}! "
          "${espresso.description ?? 'A carefully crafted coffee experience'}. At just \$${espresso.price ?? '?'} it's the perfect pick-me-up. "
          "A double shot will definitely get you going — no nonsense, just pure coffee power. ☕";
    }

    if (lower.contains('sweet') || lower.contains('mild') || lower.contains('smooth') || lower.contains('light')) {
      final latte = products.firstWhere(
        (p) => (p.name ?? '').toLowerCase().contains('latte'),
        orElse: () => products[random.nextInt(products.length)],
      );
      return "If you're looking for something smooth and approachable, our ${latte.name ?? 'house latte'} is a wonderful choice! "
          "${latte.description ?? 'Smooth and comforting'}. It's gentle, creamy, and perfect for a relaxed reading session. "
          "Pair it with a good book and you're set for the afternoon. 📖";
    }

    if (lower.contains('milk') || lower.contains('creamy') || lower.contains('foam') || lower.contains('cappuccino')) {
      final cappuccino = products.firstWhere(
        (p) => (p.name ?? '').toLowerCase().contains('cappuccino'),
        orElse: () => products[random.nextInt(products.length)],
      );
      return "You'd love our ${cappuccino.name ?? 'cappuccino'}! ${cappuccino.description ?? 'Rich espresso with velvety foam'}. "
          "The velvety microfoam on top makes every sip feel luxurious. "
          "It's our barista's personal favorite. ✨";
    }

    final pick = products[random.nextInt(products.length)];
    return "Based on what you're looking for, I'd recommend trying our ${pick.name ?? 'house special'}! "
        "${pick.description ?? 'A delightful coffee experience'}. At \$${pick.price ?? '?'} it's one of our most popular choices. ☕✨";
  }
}
