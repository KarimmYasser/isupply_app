import 'package:get/get.dart';
import 'package:isupply_app/core/config.dart';

import '../models/category.dart';
import '../models/product.dart';

class HomeRemoteDataSource extends GetConnect {
  static Future<List<Product>> getProducts() async {
    final response = await supabase.from('products').select('*').limit(10000);
    print(response.length);
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
