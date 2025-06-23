import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cart/presentation/controllers/carts_controller.dart';
import '../../data/models/customer.dart';
import '../widgets/common/add_customer_widget.dart';

class CustomerController extends GetxController {
  RxList<Customer> listCustomer = <Customer>[].obs;
  var isCustomerLoading = false.obs;
  var errorValidateMessage = "".obs;
  var searching = false.obs;

  Customer customer = Customer(mobileNo: "choose customer");

  @override
  void onReady() {
    super.onReady();
    getCustomers();
  }

  void showDialogAddCustomer() {
    Get.defaultDialog(
      titlePadding: EdgeInsets.symmetric(horizontal: 110, vertical: 10),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: 'اضافة عميل جديد',
      titleStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.white,
      barrierDismissible: true,
      radius: 5,
      content: AddCustomerWidget(
        onAddCustomer: addCustomer,
        validateInput: validateInput,
        errorValidateMessage: errorValidateMessage,
        isCustomerLoading: isCustomerLoading,
      ),
    );
    update();
  }

  String? validateInput(String? value, String error) {
    if (value == null || value.isEmpty) {
      return error;
    }
    return "";
  }

  Future<void> addCustomer(
    String mobile,
    String name,
    String ID,
    String email,
  ) async {
    isCustomerLoading.value = true;
    var customer = Customer(mobileNo: mobile, name: name, Id: ID, email: email);

    try {
      listCustomer.add(customer);
      CartsController().setSelectedCustomer(customer);
      isCustomerLoading.value = false;
      Get.back();
      Get.snackbar(
        "تم",
        "تم حفظ العميل الجديد",
        backgroundColor: Color.fromARGB(255, 15, 38, 87),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        titleText: Text(
          "تم",
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          "تم حفظ العميل الجديد بنجاح",
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    } catch (error) {
      isCustomerLoading.value = false;
      Get.snackbar(
        "خطأ",
        "$error",
        backgroundColor: const Color(0xffec383d).withOpacity(0.5),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getCustomers() async {
    try {
      // final LocalStoreCustomer customerStore = getIt<RemoteCustomer>();
      // listCustomer.value = await customerStore.load();
      update();
    } catch (e) {
      print("error getCustomers $e");
    }
  }
}
