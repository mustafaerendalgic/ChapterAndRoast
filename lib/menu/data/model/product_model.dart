import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';

class ProductModel {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? image;
  final bool? isFeatured;
  final String? badge;
  final String? category;
  final String? quote;
  final String? subTitle;
  final String? provenanceBody;
  final List<String>? flavorNotes;
  final String? origin;
  final String? roastLevel;
  final String? process;
  final String? elevation;
  final String? ritualGenre;
  final String? ritualVessel;
  final bool? isHot;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.isFeatured,
    this.badge,
    this.category,
    this.quote,
    this.subTitle,
    this.provenanceBody,
    this.flavorNotes,
    this.origin,
    this.roastLevel,
    this.process,
    this.elevation,
    this.ritualGenre,
    this.ritualVessel,
    this.isHot,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    return ProductModel(
      id: docId ?? json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      image: json['image'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      badge: json['badge'] as String?,
      category: json['category'] as String?,
      quote: json['quote'] as String?,
      subTitle: json['subTitle'] as String?,
      provenanceBody: json['provenanceBody'] as String?,
      flavorNotes: (json['flavorNotes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      origin: json['origin'] as String?,
      roastLevel: json['roastLevel'] as String?,
      process: json['process'] as String?,
      elevation: json['elevation'] as String?,
      ritualGenre: json['ritualGenre'] as String?,
      ritualVessel: json['ritualVessel'] as String?,
      isHot: json['isHot'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'isFeatured': isFeatured ?? false,
      'badge': badge,
      'category': category,
      'quote': quote,
      'subTitle': subTitle,
      'provenanceBody': provenanceBody,
      'flavorNotes': flavorNotes,
      'origin': origin,
      'roastLevel': roastLevel,
      'process': process,
      'elevation': elevation,
      'ritualGenre': ritualGenre,
      'ritualVessel': ritualVessel,
      'isHot': isHot ?? true,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      image: image,
      isFeatured: isFeatured ?? false,
      badge: badge,
      category: category,
      quote: quote,
      subTitle: subTitle,
      provenanceBody: provenanceBody,
      flavorNotes: flavorNotes,
      origin: origin,
      roastLevel: roastLevel,
      process: process,
      elevation: elevation,
      ritualGenre: ritualGenre,
      ritualVessel: ritualVessel,
      isHot: isHot ?? true,
    );
  }
}
