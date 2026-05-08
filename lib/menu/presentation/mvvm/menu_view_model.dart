import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/menu/domain/use_case/get_products_use_case.dart';

class MenuViewModel extends ChangeNotifier {
  final _getProductsUseCase = GetProductsUseCase();

  bool loading = false;
  List<Product> products = [];

  Future<void> fetchProducts() async {
    loading = true;
    notifyListeners();

    products = await _getProductsUseCase();

    loading = false;
    notifyListeners();
  }
}
