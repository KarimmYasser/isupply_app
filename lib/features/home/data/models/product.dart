import 'package:hive/hive.dart';

import 'category.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product {
  Product({
    required this.sku,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.groupId,
    this.taxRate,
    this.taxedPrice,
    this.category,
    this.salePrice,
    this.taxedSalePrice,
  });

  @HiveField(0)
  String sku;
  @HiveField(1)
  String name;
  @HiveField(2)
  double price;
  @HiveField(3)
  String imageUrl;
  @HiveField(4)
  int stock;
  @HiveField(5)
  int? groupId;
  @HiveField(6)
  double? taxRate;
  @HiveField(7)
  double? taxedPrice;
  @HiveField(8)
  Category? category;
  @HiveField(9)
  double? salePrice;
  @HiveField(10)
  double? taxedSalePrice;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    sku: json['id'].toString(),
    name: json["name"],
    imageUrl: json["image_url"],
    stock: json["stock"] as int,
    groupId: json["groupId"] ?? 0,
    category:
        json["product_category"] == null
            ? null
            : Category.fromJson(json["product_category"]),
    price: json["price"] == null ? 0 : json["price"].toDouble(),
    salePrice: json["sale_price"] == null ? 0 : json["sale_price"].toDouble(),
    taxRate: json["tax_rate"]?.toDouble(),
    taxedPrice: json["taxed_price"]?.toDouble(),
    taxedSalePrice:
        json["taxed_sale_price"] == null
            ? 0
            : json["taxed_sale_price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "sku": sku,
    "name": name,
    "price": price,
    "imageUrl": imageUrl,
    "tax_rate": taxRate,
    "taxed_price": taxedPrice,
    if (category != null) "product_category": category!.toJson(),
    "sale_price": salePrice,
    "stock": stock,
    "taxed_sale_price": taxedSalePrice,
  };
}
