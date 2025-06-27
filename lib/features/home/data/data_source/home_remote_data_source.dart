import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:isupply_app/core/config.dart';

import '../models/category.dart';
import '../models/product.dart';

class HomeRemoteDataSource extends GetConnect {
  static Future<List<Product>> getProducts() async {
    final response = await supabase.from('products').select('*');
    if (kDebugMode) {
      print('Loaded from Remote Storage ${response.length} items');
    }
    return response.map((map) => Product.fromJson(map)).toList();
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
