import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:isupply_app/features/home/presentation/controllers/home_controller.dart';
import 'package:isupply_app/features/invoice/data/helper/cart_invoice_mapper.dart';
import '../../../customer/data/models/customer.dart';
import '../../../home/data/models/product.dart';
import '../../../invoice/data/repositories/invoice_repository.dart';
import '../../data/models/cart.dart';
import '../../data/models/cart_item.dart';

class CartsController extends GetxController {
  RxList<Cart> listCarts =
      <Cart>[
        Cart(keyCart: 1, cartItems: []),
        Cart(keyCart: 2, cartItems: []),
      ].obs;

  var selectedCart = 0.obs;
  var isPayLoading = false.obs;
  final cartFocusNode = FocusNode();

  double get invoiceTotal {
    final Cart selectedCard = listCarts[selectedCart.value];
    if (selectedCard.cartItems.isEmpty) {
      return 0.0;
    }
    return selectedCard.cartItems
        .map((e) => e.getPrice! * e.quantity)
        .reduce((value, element) => value + element);
  }

  void addCart() {
    listCarts.add(Cart(keyCart: listCarts.length, cartItems: []));
    update();
  }

  void removeCart() {
    if (listCarts.length == 1) {
      clearDataOfCart();
      update();
      return;
    }
    listCarts.removeAt(selectedCart.value);
    selectedCart.value = selectedCart.value > 0 ? selectedCart.value - 1 : 0;
    update();
  }

  void changeCart(int index) {
    selectedCart.value = index;
    update();
  }

  void nextCart() {
    selectedCart.value += 1;
    selectedCart.value %= listCarts.length;
    update();
  }

  void previousCart() {
    selectedCart.value += listCarts.length - 1;
    selectedCart.value %= listCarts.length;
    update();
  }

  void addProduct(Product product) {
    bool thereIsProductInCart = false;
    for (var elementProduct in listCarts[selectedCart.value].cartItems) {
      if (elementProduct.product.id == product.id) {
        if (elementProduct.product.stock <= elementProduct.quantity) {
          Get.closeAllSnackbars();
          Get.snackbar(
            "خطأ",
            "لا يمكن إضافة المنتج ${product.name} إلى السلة لأنه غير متوفر في المخزون.",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(bottom: 10),
            titleText: Text(
              "خطأ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            messageText: Text(
              "لا يمكن إضافة المنتج ${product.name} إلى السلة لأنه غير متوفر في المخزون.",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
          return;
        }
        elementProduct.quantity += 1;
        thereIsProductInCart = true;
        listCarts.refresh();
        update();
        return;
      }
    }

    if (!thereIsProductInCart) {
      if (product.stock <= 0) {
        Get.closeAllSnackbars();
        Get.snackbar(
          "خطأ",
          "لا يمكن إضافة المنتج ${product.name} إلى السلة لأنه غير متوفر في المخزون.",
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.only(bottom: 10),
          titleText: Text(
            "خطأ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          ),
          messageText: Text(
            "لا يمكن إضافة المنتج ${product.name} إلى السلة لأنه غير متوفر في المخزون.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
        return;
      }
      double price = product.price;
      if (product.salePrice != null && product.salePrice != 0.0) {
        price = product.salePrice!;
      }
      listCarts[selectedCart.value].cartItems.add(
        CartItem(product: product, quantity: 1, sellingPrice: price),
      );
    }
    listCarts.refresh();
    if (kDebugMode) {
      print(
        "Added product: ${product.name} with ${product.id} to cart ${selectedCart.value + 1}",
      );
    }
    update();
  }

  void updateItem(CartItem product) {
    for (var elementProduct in listCarts[selectedCart.value].cartItems) {
      if (elementProduct.product.id == product.product.id) {
        elementProduct.quantity = product.quantity;
        elementProduct.sellingPrice = product.getPrice;
      }
    }
    update();
  }

  void deleteItem(CartItem product) {
    listCarts[selectedCart.value].cartItems.removeWhere(
      (elementProduct) => elementProduct.product.id == product.product.id,
    );

    update();
  }

  void clearDataOfCart() {
    final Cart tmpCart = listCarts[selectedCart.value];
    tmpCart.cartItems.clear();
    tmpCart.customer = null;

    listCarts[selectedCart.value] = tmpCart;
    update();
  }

  Future<void> onDeleteCart() async {
    await Get.defaultDialog(
      title: "حذف ؟ ",
      titleStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "هل انت متأكد من حذف السلة ${selectedCart.value + 1}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      confirm: InkWell(
        onTap: () {
          removeCart();
          Get.back();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "متابعة",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      cancel: InkWell(
        onTap: () => Get.back(),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "الغاء",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> clearCarts() async {
    await Get.defaultDialog(
      title: "حذف ؟ ",
      titleStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "هل انت متأكد من حذف جميع العناصر في السلة ${selectedCart.value + 1}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      confirm: InkWell(
        onTap: () {
          clearDataOfCart();
          Get.back();
          update();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "متابعة",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      cancel: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "الغاء",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void setSelectedCustomer(Customer customer) {
    listCarts[selectedCart.value].customer = customer;
    update();
  }

  KeyEventResult handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final label = key.keyLabel;
    if (RegExp(r'^[1-9]$').hasMatch(label)) {
      final idx = int.parse(label) - 1;
      if (idx < listCarts.length) {
        changeCart(idx);
        return KeyEventResult.handled;
      }
    }
    final hasCtrl = HardwareKeyboard.instance.isControlPressed;
    final controller = Get.find<HomeController>();
    if (hasCtrl) {
      switch (key) {
        case LogicalKeyboardKey.keyW:
          removeCart();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyT:
          addCart();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.tab:
          if (HardwareKeyboard.instance.isShiftPressed) {
            previousCart();
          } else {
            nextCart();
          }
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowLeft:
          controller.nextPage();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowRight:
          controller.previousPage();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyF:
          controller.showSearch();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.enter:
          if (HardwareKeyboard.instance.isShiftPressed) {
            pay();
          }
          return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  Future<void> pay() async {
    final cart = listCarts[selectedCart.value];
    if (cart.cartItems.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "لا يوجد عناصر في السلة",
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(14),
      );
      return;
    }

    final invoice = CartToInvoiceConverter.createInvoiceFromCart(cart);
    isPayLoading.value = true;
    if (invoice != null) {
      try {
        await InvoiceRepository.store(invoice);

        // Update stock for each item in the cart
        final homeController = Get.find<HomeController>();
        for (final cartItem in cart.cartItems) {
          final productId = cartItem.product.id;
          final quantity = cartItem.quantity;
          final currentStock = cartItem.product.stock;
          final newStock = currentStock - quantity;

          // Call the updateProductStockLocally function
          await homeController.updateProductStockLocally(productId, newStock);
        }

        Get.snackbar(
          "تم",
          "تم إصدار الفاتورة",
          backgroundColor: const Color(0xff178F49),
          snackPosition: SnackPosition.BOTTOM,
        );
        clearDataOfCart();
        isPayLoading.value = false;
      } catch (error) {
        isPayLoading.value = false;
      }
    }
  }
}
