import 'package:uuid/uuid.dart';

import '../../../cart/data/models/cart.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';

class CartToInvoiceConverter {
  static Invoice? createInvoiceFromCart(Cart cart) {
    try {
      final invoiceItems =
          cart.cartItems
              .map(
                (cartItem) => InvoiceItem(
                  product: cartItem.product,
                  quantity: cartItem.quantity,
                  sellingPrice: cartItem.getPrice!,
                ),
              )
              .toList();
      final invoiceId = const Uuid().v4().hashCode;

      final invoice = Invoice(
        id: invoiceId.toString(),
        mobileNo: cart.customer?.mobileNo ?? "N/A",
        items: invoiceItems,
        date: DateTime.now().toString().split(' ')[0],
        status: "Pending",
        time: DateTime.now().toString().split(' ')[1].substring(0, 8),
        totalPaid: _calculateTotal(invoiceItems),
      );

      return invoice;
    } catch (e) {
      return null;
    }
  }

  static double _calculateTotal(List<InvoiceItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.sellingPrice * item.quantity;
    }
    return total;
  }
}
