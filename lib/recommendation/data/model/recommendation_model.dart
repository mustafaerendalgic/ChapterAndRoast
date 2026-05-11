import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdg_campus_coffee/recommendation/domain/entity/recommendation.dart';

class RecommendationModel {
  final String? question;
  final String? answer;
  final DateTime? createdAt;

  RecommendationModel({this.question, this.answer, this.createdAt});

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  Recommendation toEntity() {
    return Recommendation(
      question: question,
      answer: answer,
      createdAt: createdAt,
    );
  }
}
