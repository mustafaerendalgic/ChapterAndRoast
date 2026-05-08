import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getProducts();
}
