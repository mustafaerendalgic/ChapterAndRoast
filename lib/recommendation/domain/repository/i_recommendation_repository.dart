import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';

abstract class IRecommendationRepository {
  Future<List<Recommendation>> getRecommendations();
  Future<String> getAiRecommendation(String prompt, List<Product> products);
  Future<void> saveRecommendation(Recommendation recommendation);
}
