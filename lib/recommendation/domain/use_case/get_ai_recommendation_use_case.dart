import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/recommendation/data/repository/recommendation_repository.dart';

class GetAiRecommendationUseCase {
  final _recommendationRepository = RecommendationRepository();

  Future<String> call(String prompt, List<Product> products) async {
    return await _recommendationRepository.getAiRecommendation(prompt, products);
  }
}
