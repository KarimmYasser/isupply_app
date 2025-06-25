import 'package:hive/hive.dart';

import '../../../home/data/models/product.dart';
part 'invoice_item.g.dart';

@HiveType(typeId: 1)
class InvoiceItem {
  InvoiceItem({
    required this.product,
    required this.quantity,
    this.sellingPrice,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    final Product product = Product.fromJson(json['product']);
    final int quantity = json['quantity'];
    return InvoiceItem(product: product, quantity: quantity);
  }

  @HiveField(0)
  Product product;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  double? sellingPrice;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product.toJson();
    data['quantity'] = quantity;
    if (sellingPrice != null) {
      data['sellingPrice'] = sellingPrice;
    }
    return data;
  }
}
