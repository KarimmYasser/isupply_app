import 'package:flutter/foundation.dart';
import 'package:isupply_app/core/config.dart';
import '../models/invoice.dart';

class RemoteStoreInvoice {
  static Future<bool> store(Invoice invoice) async {
    final response = await _uploadInvoiceToDatabase(invoice);
    return response['status'] == 200;
  }

  static Future<bool> storeUnsynced(List<Invoice> invoices) async {
    final response = await _uploadInvoicesInOneRequest(invoices);
    return response['status'] == 200;
  }

  static Future<List<Invoice>> load() async {
    final response = await supabase.from('invoices').select('*');
    if (kDebugMode) {
      print(response.length);
    }
    return response.map((map) => Invoice.fromJson(map)).toList();
  }

  static Future<Map<String, dynamic>> _uploadInvoiceToDatabase(Invoice invoice) {
    return _uploadInvoicesInOneRequest([invoice]);
  }

  static Future<Map<String, dynamic>> _uploadInvoicesInOneRequest(
    List<Invoice> invoices,
  ) async {
    try {
      final invoicesJson =
          invoices
              .map(
                (invoice) => {
                  'invoice_data': {
                    'id': invoice.id,
                    'mobile_no': invoice.mobileNo,
                    'date': invoice.date,
                    'status': 'Done',
                    'time': invoice.time,
                    'total_paid': invoice.totalPaid,
                  },
                  'invoice_products_data':
                      invoice.items
                          .map(
                            (item) => {
                              'invoice_id': invoice.id,
                              'product_id': int.parse(item.product.id),
                              'quantity': item.quantity,
                              'selling_price': item.sellingPrice,
                            },
                          )
                          .toList(),
                },
              )
              .toList();

      final result = await supabase.rpc(
        'insert_invoices_with_products',
        params: {'invoices_data': invoicesJson},
      );
      return {'status': 200, 'data': result, 'error': null};
    } catch (e) {
      return {'status': 500, 'data': null, 'error': e.toString()};
    }
  }
}
