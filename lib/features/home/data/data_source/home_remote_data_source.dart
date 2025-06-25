import 'package:get/get.dart';

import '../models/category.dart';
import '../models/product.dart';

class HomeRemoteDataSource extends GetConnect {
  static Future<List<Product>> getProducts() async {
    // TODO:
    return [];
  }

  static Future<List<Product>> getProductsByGroupId(int groupId) async {
    // TODO:
    return [];
  }

  static Future<List<Category>> getProductsCategories() async {
    // TODO:
    return [];
  }
}
