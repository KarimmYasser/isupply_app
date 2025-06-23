import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cart/presentation/view/cart_view.dart';

class CartActionButton extends StatelessWidget {
  const CartActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 149, 216, 255),
      hoverElevation: 5,
      onPressed:
          () => Get.to(
            () => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  'Shopping Cart'.tr,
                  style: TextStyle(color: Colors.black),
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: CartView(),
            ),
          ),
      child: Icon(
        Icons.shopping_cart_outlined,
        size: 50,
        color: const Color.fromARGB(255, 15, 38, 87),
      ),
    );
  }
}
