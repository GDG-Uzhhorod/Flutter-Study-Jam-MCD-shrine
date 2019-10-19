import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_mcd/model/product.dart';
import 'package:flutter_app_mcd/model/products_repository.dart';

enum Status { Load, Done }

class ProductProvider with ChangeNotifier {
  Status _status = Status.Load;
  List<Product> _products;

  get status => _status;

  get products => _products;

  void loadProductsList() async {
    Timer(Duration(seconds: 2), () {
      _products = ProductsRepository.loadProducts(Category.all);

      _status = Status.Done;
      notifyListeners();
    });
  }
}
