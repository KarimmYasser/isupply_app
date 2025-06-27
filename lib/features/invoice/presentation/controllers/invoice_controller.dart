import 'dart:async';

import 'package:get/get.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/models/invoice.dart';

class InvoiceController extends GetxController {
  var listInvoice = <Invoice>[].obs;
  var newListInvoice = <Invoice>[].obs;
  var searching = false.obs;
  RxBool loadingInvoice = false.obs;
  Timer? _debounceTimer;
  static InvoiceController get to => Get.find<InvoiceController>();

  @override
  void onReady() {
    super.onReady();
    getInvoice();
  }

  onSearch(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        newListInvoice.value = listInvoice;
        update();
        return;
      }
      newListInvoice.value =
          listInvoice
              .where(
                (string) =>
                    string.id.toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
      update();
    });
  }

  Future getInvoice() async {
    loadingInvoice.value = true;
    listInvoice.value = await InvoiceRepository.load();
    newListInvoice.value = listInvoice;
    update();
    loadingInvoice.value = false;
  }
}
