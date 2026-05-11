import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/menu/domain/use_case/get_products_use_case.dart';

class MenuViewModel extends ChangeNotifier {
  final _getProductsUseCase = GetProductsUseCase();

  bool loading = false;
  List<Product> featuredProducts = [];
  List<Product> archiveProducts = [];

  MenuViewModel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    loading = true;
    notifyListeners();

    try {
      final allProducts = await _getProductsUseCase();
      featuredProducts = allProducts.where((p) => p.isFeatured).toList();
      archiveProducts = allProducts.where((p) => !p.isFeatured).toList();
    } catch (e) {
      featuredProducts = [];
      archiveProducts = [];
    }

    loading = false;
    notifyListeners();
  }
}
