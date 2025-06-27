import 'package:flutter/foundation.dart';
import 'package:isupply_app/core/connection_controller.dart';
import 'package:isupply_app/features/invoice/data/data_sources/local_store_invoice.dart';
import 'package:isupply_app/features/invoice/data/data_sources/remote_store_invoice.dart';

import '../models/invoice.dart';

class InvoiceRepository {
  static Future<void> store(Invoice invoice) async {
    try {
      if (ConnectionController.to.isConnected.value) {
        RemoteStoreInvoice.store(invoice);
      } else {
        LocalStoreInvoice.store(invoice);
      }
    } catch (e) {
      LocalStoreInvoice.store(invoice);
      if (kDebugMode) {
        print('Error storing invoice: $e');
      }
    }
  }

  static Future<void> storeUnsynced() async {
    try {
      if (ConnectionController.to.isConnected.value) {
        final unsyncedInvoices = LocalStoreInvoice.load();
        bool success = false;
        if (unsyncedInvoices.isNotEmpty) {
          success = await RemoteStoreInvoice.storeUnsynced(unsyncedInvoices);
        }
        if(success){
          LocalStoreInvoice.clear();
        }
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error storing unsynced invoices: $e');
      }
    }
  }

  static Future<List<Invoice>> load() async {
    try {
      if (ConnectionController.to.isConnected.value) {
        return RemoteStoreInvoice.load();
      } else {
        return LocalStoreInvoice.load();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading invoices: $e');
      }
      return LocalStoreInvoice.load();
    }
  }

  static Future<void> delete(String invoiceID) async {
    LocalStoreInvoice.delete(invoiceID);
  }

  static Future<void> clear() async {
    LocalStoreInvoice.clear();
  }
}
