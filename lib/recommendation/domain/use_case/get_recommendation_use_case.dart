import 'package:gdg_campus_coffee/recommendation/data/repository/recommendation_repository.dart';
import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';

class GetRecommendationUseCase {
  final _recommendationRepository = RecommendationRepository();

  Future<List<Recommendation>> call() async {
    return await _recommendationRepository.getRecommendations();
  }
}
