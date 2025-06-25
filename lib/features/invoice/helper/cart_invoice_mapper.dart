import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../cart/data/models/cart.dart';
import '../../cart/data/models/cart_item.dart';
import '../data/models/invoice.dart';
import '../data/models/invoice_item.dart';

mixin CartInvoiceMapper {
  static Invoice? createInvoiceFrom({required Cart cart}) {
    if (cart.cartItems.isNotEmpty) {
      final String invoiceId = const Uuid().v4();
      final Invoice invoice = Invoice(
        id: invoiceId,
        mobileNo: cart.customer?.mobileNo ?? 'Unknown',
        items:
            cart.cartItems
                .map<InvoiceItem>(
                  (CartItem cartItem) => InvoiceItem(
                    product: cartItem.product,
                    quantity: cartItem.quantity,
                    sellingPrice: cartItem.sellingPrice,
                  ),
                )
                .toList(),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        status: 'Pending',
        time: DateFormat('HH:mm:ss').format(DateTime.now()),
        totalPaid: 0.0,
      );
      return invoice;
    } else {
      return null;
    }
  }
}
