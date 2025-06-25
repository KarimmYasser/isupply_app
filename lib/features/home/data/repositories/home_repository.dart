import 'package:isupply_app/features/home/presentation/controllers/home_controller.dart';

import '../data_source/home_faker_data_source.dart';
import '../data_source/home_local_data_source.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeRepository {
  Future<List<Product>> getProducts() async {
    final List<Product> products = await HomeLocalDataSource.getProducts();
    if (products.isNotEmpty) {
      return products;
    } else {
      // final List<Product> products = await remoteDataSource.getProducts();
      HomeLocalDataSource.insertProducts(products);
      return products;
    }
  }

  Future<List<Product>> getProductsByGroupId(int groupId) async {
    final List<Product> products =
        await HomeLocalDataSource.getProductsByGroupId(groupId);
    if (products.isNotEmpty) {
      return products;
    } else {
      // final List<Product> products = await remoteDataSource.getProductsByGroupId(groupId);
      HomeLocalDataSource.insertProducts(products);
      return products;
    }
  }

  Future<List<Category>> getProductsCategories() async {
    return [];
  }
}
