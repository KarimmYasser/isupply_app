import 'package:faker_dart/faker_dart.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isupply_app/features/home/data/models/category.dart';

import '../features/home/data/models/product.dart';
import '../features/home/presentation/controllers/home_controller.dart';

const int customersCacheTimeIntervalInHours = 48;
final Faker faker = Faker.instance;
late Box<Product> productsBox;

Future<void> init() async {
  await Hive.initFlutter();
  Get.put(HomeController());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ProductAdapter());
  productsBox = await Hive.openBox<Product>('products');
  productsBox.clear();
}
