import 'package:gdg_campus_coffee/branches/domain/entity/branch.dart';

class BranchModel {
  final String? name;
  final String? description;
  final double? rating;
  final String? distance;
  final List<String>? photos;
  final String? markerLabel;
  final double? latitude;
  final double? longitude;

  BranchModel({
    this.name,
    this.description,
    this.rating,
    this.distance,
    this.photos,
    this.markerLabel,
    this.latitude,
    this.longitude,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      distance: json['distance'] as String?,
      photos: (json['photos'] as List?)?.map((e) => e as String).toList(),
      markerLabel: json['markerLabel'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'rating': rating,
      'distance': distance,
      'photos': photos,
      'markerLabel': markerLabel,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Branch toEntity() {
    return Branch(
      name: name,
      description: description,
      rating: rating,
      distance: distance,
      photos: photos,
      markerLabel: markerLabel,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
