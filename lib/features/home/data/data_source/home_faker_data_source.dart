import '../../../../core/config.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeFakerDataSource {
  static Future<List<Product>> getProducts() async {
    List<Product> list = [];

    for (int i = 0; i < 100; i++) {
      list.add(
        Product(
          name: faker.commerce.productName(),
          price: faker.datatype.number(max: 200).toDouble(),
          id: faker.commerce.productName(),
          imageUrl: faker.image.loremPicsum.image(),
          groupId: faker.datatype.number(max: 2),
          stock:
              faker.datatype.number(max: 100, min: 0) < 80
                  ? faker.datatype.number(max: 100)
                  : 0,
          category: Category(
            id: faker.datatype.number(max: 2, min: 1),
            name: faker.commerce.department(),
          ),
          salePrice:
              faker.datatype.boolean()
                  ? faker.datatype.number(max: 200).toDouble()
                  : null,
        ),
      );
    }
    return list;
  }

  static Future<List<Product>> getProductsByGroupId(int groupId) async {
    List<Product> list = [];

    for (int i = 0; i < 100; i++) {
      list.add(
        Product(
          name: faker.commerce.productName(),
          price: faker.datatype.number(max: 200).toDouble(),
          id: faker.commerce.productName(),
          imageUrl: faker.image.loremPicsum.image(),
          groupId: groupId,
          category: Category(id: groupId, name: faker.commerce.department()),
          stock: faker.datatype.number(max: 200),
        ),
      );
    }
    return list;
  }
}
