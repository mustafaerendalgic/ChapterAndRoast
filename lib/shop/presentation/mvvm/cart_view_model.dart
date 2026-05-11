import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/menu/domain/entity/product.dart';
import 'package:gdg_campus_coffee/shop/domain/entity/cart_item.dart';
import 'package:gdg_campus_coffee/oracle/data/service/oracle_service.dart';

class CartViewModel extends ChangeNotifier {
  // Singleton pattern for easy access across the app
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal() {
    _initializeMockData();
  }

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal; // Shipping is complimentary

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<void> checkout() async {
    if (_items.isEmpty) return;
    
    try {
      // Reward the user with a fortune right (with timeout to prevent hanging)
      await OracleService().incrementRights().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw 'Timeout',
      );
    } catch (e) {
      // If network fails, we proceed with checkout but log the issue
      debugPrint('⚠️ [CART] Failed to grant fortune credit: $e');
    }
    
    _items.clear();
    notifyListeners();
  }

  void _initializeMockData() {
    // Starting with empty cart as requested
  }

  void updateQuantity(CartItem item, int delta) {
    final index = _items.indexOf(item);
    if (index != -1) {
      _items[index].quantity = (_items[index].quantity + delta).clamp(1, 99);
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((i) => i.product.name == product.name);
    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }
}
