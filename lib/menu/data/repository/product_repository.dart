import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gdg_campus_coffee/menu/data/model/product_model.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/menu/domain/repository/i_product_repository.dart';

class ProductRepository implements IProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .get()
          .timeout(const Duration(seconds: 8));
      
      final models = snapshot.docs.map((doc) => ProductModel.fromJson(doc.data(), doc.id)).toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching products: $e');
      return [];
    }
  }
}
