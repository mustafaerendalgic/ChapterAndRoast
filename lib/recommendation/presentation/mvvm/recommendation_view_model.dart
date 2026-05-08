import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/recommendation/domain/use_case/get_recommendation_use_case.dart';
import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';

class RecommendationViewModel extends ChangeNotifier {
  final _getRecommendationUseCase = GetRecommendationUseCase();

  bool loading = false;
  List<Recommendation> recommendations = [];

  Future<void> fetchRecommendations() async {
    loading = true;
    notifyListeners();

    recommendations = await _getRecommendationUseCase();

    loading = false;
    notifyListeners();
  }
}
