import 'package:hive/hive.dart';

import '../../../home/data/models/product.dart';
part 'invoice_item.g.dart';

@HiveType(typeId: 1)
class InvoiceItem {
  InvoiceItem({
    required this.product,
    required this.quantity,
    required this.sellingPrice,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    final Product product = Product.fromJson(json['product']);
    final int quantity = json['quantity'];
    final double sellingPrice = json['selling_price'];
    return InvoiceItem(
      product: product,
      quantity: quantity,
      sellingPrice: sellingPrice,
    );
  }

  @HiveField(0)
  Product product;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  double sellingPrice;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product.toJson();
    data['quantity'] = quantity;
    data['sellingPrice'] = sellingPrice;
    return data;
  }
}
