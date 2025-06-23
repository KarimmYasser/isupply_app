import '../../../home/data/models/product.dart';

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

  Product product;
  int quantity;
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
