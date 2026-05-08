import 'package:gdg_campus_coffee/market/data/model/catalog_product_model.dart';
import 'package:gdg_campus_coffee/market/domain/entity/catalog_product.dart';
import 'package:gdg_campus_coffee/market/domain/repository/i_market_repository.dart';

class MarketRepository implements IMarketRepository {
  @override
  Future<List<CatalogProduct>> getCatalogProducts() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    final models = [
      CatalogProductModel(name: 'Termos'),
      CatalogProductModel(name: 'Kupa'),
      CatalogProductModel(name: 'Çanta'),
    ];

    return models.map((model) => model.toEntity()).toList();
  }
}
