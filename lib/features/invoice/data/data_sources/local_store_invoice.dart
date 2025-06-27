import 'package:isupply_app/core/config.dart';
import '../models/invoice.dart';

class LocalStoreInvoice {
  static Future<Invoice> store(Invoice invoice) async {
    await invoicesBox.add(invoice);
    return invoice;
  }

  static List<Invoice> load() {
    final List<Invoice> invoices = invoicesBox.values.toList();
    return invoices;
  }

  static Future<void> delete(String invoiceID) async {
    final keyToDelete = invoicesBox.keys.firstWhere(
      (key) => invoicesBox.get(key)?.id == invoiceID,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await invoicesBox.delete(keyToDelete);
    }
  }

  static Future<int> clear() async {
    return await invoicesBox.clear();
  }
}
