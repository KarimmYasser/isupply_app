import 'package:isupply_app/core/connection_controller.dart';

import '../data_source/home_local_data_source.dart';
import '../data_source/home_remote_data_source.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeRepository {
  static Future<List<Product>> getProducts() async {
    if (ConnectionController.to.isConnected.value) {
      try {
        final List<Product> products = await HomeRemoteDataSource.getProducts();
        HomeLocalDataSource.insertProducts(products);
        return products;
      } catch (e) {
        final List<Product> products = await HomeLocalDataSource.getProducts();
        return products;
      }
    } else {
      final List<Product> products = await HomeLocalDataSource.getProducts();
      return products;
    }
  }

  static Future<List<Product>> getProductsByGroupId(int groupId) async {
    final List<Product> products =
        await HomeRemoteDataSource.getProductsByGroupId(groupId);
    if (products.isNotEmpty) {
      HomeLocalDataSource.insertProducts(products);
      return products;
    } else {
      final List<Product> products =
          await HomeLocalDataSource.getProductsByGroupId(groupId);
      return products;
    }
  }

  static Future<List<Category>> getProductsCategories() async {
    return [];
  }
}
