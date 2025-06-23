import '../models/invoice.dart';

abstract class StoreInvoice {
  Future<Invoice> store(Invoice invoice);
}
