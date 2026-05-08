import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';

abstract class IRecommendationRepository {
  Future<List<Recommendation>> getRecommendations();
}
