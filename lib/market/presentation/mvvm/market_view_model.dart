import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/market/domain/use_case/get_catalog_products_use_case.dart';
import 'package:gdg_campus_coffee/market/domain/entity/catalog_product.dart';

class MarketViewModel extends ChangeNotifier {
  final _getCatalogProductsUseCase = GetCatalogProductsUseCase();

  bool loading = false;
  List<CatalogProduct> catalogProducts = [];

  MarketViewModel() {
    fetchCatalogProducts();
  }

  Future<void> fetchCatalogProducts() async {
    loading = true;
    notifyListeners();

    try {
      catalogProducts = await _getCatalogProductsUseCase();
    } catch (e) {
      catalogProducts = [];
    }

    loading = false;
    notifyListeners();
  }
}
