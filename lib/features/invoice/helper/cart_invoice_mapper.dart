import '../../cart/data/models/cart.dart';
import '../../cart/data/models/cart_item.dart';
import '../data/models/invoice.dart';
import '../data/models/invoice_item.dart';

mixin CartInvoiceMapper {
  static Invoice? createInvoiceFrom({required Cart cart}) {
    if (cart.cartItems.isNotEmpty) {
      final Invoice invoice = Invoice(
        clientId: cart.keyCart,
        customer: cart.customer,
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
      );
      return invoice;
    } else {
      return null;
    }
  }
}
