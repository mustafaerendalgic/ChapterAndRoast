import 'package:gdg_campus_coffee/menu/data/repository/product_repository.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';

class GetProductsUseCase {
  final _productRepository = ProductRepository();

  Future<List<Product>> call() async {
    return await _productRepository.getProducts();
  }
}
