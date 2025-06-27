import 'package:flutter/foundation.dart' show kDebugMode;

import '../../../../core/config.dart';
import '../models/product.dart';

class HomeLocalDataSource {
  static Future<List<Product>> getProducts() async {
    if (kDebugMode) {
      print('Loaded from Local Storage ${productsBox.length} items');
    }
    return productsBox.values.toList();
  }

  static Future<void> insertProducts(List<Product> products) async {
    await productsBox.clear();
    for (final product in products) {
      await productsBox.put(product.id, product);
    }
  }

  static Future<List<Product>> getProductsByGroupId(int groupId) async {
    return productsBox.values
        .where((Product product) => product.groupId == groupId)
        .toList();
  }

  // static Future<List<Product>> getProducts() async {
  //   final raw = await rootBundle.loadString('assets/medicines.csv');
  //   final csv = CsvToListConverter().convert(raw, eol: '\n');
  //   final box = Hive.box<Product>('products');

  //   final headers = csv.first;
  //   final rows = csv.skip(1);

  //   final List<Product> products = [];
  //   int i = 0;
  //   for (final row in rows) {
  //     if (i == 48) break;
  //     final name =
  //         row[headers.indexOf('Medicine Name')]?.toString() ?? 'Unnamed';
  //     final imageUrl = row[headers.indexOf('Image URL')]?.toString() ?? '';
  //     var price = faker.datatype.float(min: 5, max: 1000).roundToDouble();

  //     final product = Product(
  //       id: faker.internet.ip(),
  //       name: name,
  //       price: price,
  //       imageUrl: imageUrl,
  //       stock:
  //           faker.datatype.number(max: 100) < 80
  //               ? faker.datatype.number(min: 5, max: 100)
  //               : 0,
  //       groupId: faker.datatype.number(min: 1, max: 2),
  //       category: Category(
  //         id: faker.datatype.number(min: 1),
  //         name: faker.commerce.department(),
  //       ),
  //       salePrice:
  //           faker.datatype.number(max: 100) > 20
  //               ? faker.datatype.float(min: 1, max: price - 1).roundToDouble()
  //               : null,
  //       taxRate: null,
  //       taxedPrice: null,
  //       taxedSalePrice: null,
  //     );

  //     products.add(product);
  //     await box.add(product);
  //     i++;
  //   }
  //   return products;
  // }
}
