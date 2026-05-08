import 'package:gdg_campus_coffee/market/domain/entity/catalog_product.dart';

abstract class IMarketRepository {
  Future<List<CatalogProduct>> getCatalogProducts();
}
