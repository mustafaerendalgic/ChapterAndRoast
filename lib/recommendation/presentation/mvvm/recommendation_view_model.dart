import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/menu/domain/use_case/get_products_use_case.dart';
import 'package:gdg_campus_coffee/recommendation/domain/use_case/get_ai_recommendation_use_case.dart';
import 'package:gdg_campus_coffee/recommendation/domain/use_case/get_recommendation_use_case.dart';
import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';

class RecommendationViewModel extends ChangeNotifier {
  final _getRecommendationUseCase = GetRecommendationUseCase();
  final _getAiRecommendationUseCase = GetAiRecommendationUseCase();
  final _getProductsUseCase = GetProductsUseCase();

  bool loading = false;
  List<Recommendation> recommendations = [];
  List<String> suggestions = [];
  String? aiAnswer;

  RecommendationViewModel() {
    init();
  }

  Future<void> init() async {
    loading = true;
    notifyListeners();

    await Future.wait([fetchRecommendations(), fetchSuggestions()]);

    loading = false;
    notifyListeners();
  }

  Future<void> fetchSuggestions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ai_suggestions')
          .get();
      suggestions = snapshot.docs
          .map((doc) => doc.data()['text'] as String)
          .toList();
    } catch (e) {
      suggestions = [];
    }
  }

  Future<void> fetchRecommendations() async {
    try {
      recommendations = await _getRecommendationUseCase();
    } catch (e) {
      recommendations = [];
    }
  }

  Future<void> askAi(String prompt) async {
    loading = true;
    aiAnswer = null;
    notifyListeners();

    try {
      final products = await _getProductsUseCase();

      if (products.isEmpty) {
        aiAnswer =
            "I couldn't find any coffee on the menu to recommend. Please check back later!";
      } else {
        aiAnswer = await _getAiRecommendationUseCase(prompt, products);
        await fetchRecommendations();
      }
    } catch (e) {
      aiAnswer =
          "I'm having trouble thinking right now. Please check your connection and try again!";
    }

    loading = false;
    notifyListeners();
  }
}
