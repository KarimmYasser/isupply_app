import 'package:get/get.dart';
import 'package:isupply_app/core/config.dart';

import '../models/category.dart';
import '../models/product.dart';

class HomeRemoteDataSource extends GetConnect {
  Future<List<Product>> getProducts() async {
    // TODO:
    return [];
  }

  Future<List<Product>> getProductsByGroupId(int groupId) async {
    // TODO:
    return [];
  }

  Future<List<Category>> getProductsCategories() async {
    // TODO:
    return [];
  }
}
