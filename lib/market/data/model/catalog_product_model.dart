import 'package:gdg_campus_coffee/market/domain/entity/catalog_product.dart';

class CatalogProductModel {
  final String? name;
  final String? description;
  final double? price;
  final String? image;
  final String? category;

  CatalogProductModel({
    this.name,
    this.description,
    this.price,
    this.image,
    this.category,
  });

  factory CatalogProductModel.fromJson(Map<String, dynamic> json) {
    return CatalogProductModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      image: json['image'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
    };
  }

  CatalogProduct toEntity() {
    return CatalogProduct(
      name: name,
      description: description,
      price: price,
      image: image,
      category: category,
    );
  }
}
