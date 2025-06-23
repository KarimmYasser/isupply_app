import '../models/invoice.dart';

abstract class InvoiceLoader {
  Future<List<Invoice>> load();

  Future<Invoice> delete(Invoice invoice);
}
