import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gdg_campus_coffee/market/data/model/catalog_product_model.dart';
import 'package:gdg_campus_coffee/market/domain/entity/catalog_product.dart';
import 'package:gdg_campus_coffee/market/domain/repository/i_market_repository.dart';

class MarketRepository implements IMarketRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CatalogProduct>> getCatalogProducts() async {
    try {
      final snapshot = await _firestore
          .collection('market_items')
          .get()
          .timeout(const Duration(seconds: 8));
          
      final models = snapshot.docs.map((doc) => CatalogProductModel.fromJson(doc.data())).toList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching market items: $e');
      return [];
    }
  }
}
