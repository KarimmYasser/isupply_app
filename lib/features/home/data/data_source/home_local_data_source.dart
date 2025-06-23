import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../../../core/config.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeLocalDataSource {
  // static Future<List<Product>> getProducts() async {
  //   return productsBox.values.toList();
  // }

  static Future<List<Product>> getProducts() async {
    final raw = await rootBundle.loadString('assets/medicines.csv');
    final csv = CsvToListConverter().convert(raw, eol: '\n');
    final box = Hive.box<Product>('products');

    final headers = csv.first;
    final rows = csv.skip(1);

    final List<Product> products = [];
    int i = 0;
    for (final row in rows) {
      if (i == 48) break;
      final name =
          row[headers.indexOf('Medicine Name')]?.toString() ?? 'Unnamed';
      final imageUrl = row[headers.indexOf('Image URL')]?.toString() ?? '';
      var price = faker.datatype.float(min: 5, max: 1000).roundToDouble();

      final product = Product(
        sku: faker.internet.ip(),
        name: name,
        price: price,
        imageUrl: imageUrl,
        stock:
            faker.datatype.number(max: 100) < 80
                ? faker.datatype.number(min: 5, max: 100)
                : 0,
        groupId: faker.datatype.number(min: 1, max: 2),
        category: Category(
          id: faker.datatype.number(min: 1),
          name: faker.commerce.department(),
        ),
        salePrice:
            faker.datatype.number(max: 100) > 20
                ? faker.datatype.float(min: 1, max: price - 1).roundToDouble()
                : null,
        taxRate: null,
        taxedPrice: null,
        taxedSalePrice: null,
      );

      products.add(product);
      await box.add(product);
      i++;
    }
    return products;
  }

  static Future<Iterable<int>> insertProducts(List<Product> products) async {
    return productsBox.addAll(products);
  }

  static Future<List<Product>> getProductsByGroupId(int groupId) async {
    return productsBox.values
        .where((Product product) => product.groupId == groupId)
        .toList();
  }
}

Future<void> loadMedicinesToHive() async {
  final box = Hive.box<Product>('products');

  if (box.isNotEmpty) return; // prevent re-import

  final raw = await rootBundle.loadString('assets/medicines.csv');
  final csv = CsvToListConverter(eol: '\n').convert(raw);

  final headers = csv.first;
  final rows = csv.skip(1);

  for (final row in rows) {
    final name = row[headers.indexOf('Medicine Name')]?.toString() ?? '';
    final imageUrl = row[headers.indexOf('Image URL')]?.toString() ?? '';
    var price = faker.datatype.float(min: 5, max: 1000);

    final product = Product(
      sku: faker.internet.ip(),
      name: name,
      price: price,
      imageUrl: imageUrl,
      stock:
          faker.datatype.number(max: 100) < 80
              ? faker.datatype.number(min: 5, max: 100)
              : 0,
      groupId: faker.datatype.number(),
      category: Category(
        id: faker.datatype.number(min: 1),
        name: faker.commerce.department(),
      ),
      salePrice:
          faker.datatype.number(max: 100) > 20
              ? faker.datatype.float(min: 1, max: price - 1)
              : null,
      taxRate: null,
      taxedPrice: null,
      taxedSalePrice: null,
    );

    await box.add(product);
  }

  print('💊 Medicines imported to Hive as Products!');
}
