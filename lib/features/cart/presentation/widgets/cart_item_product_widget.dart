import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../data/models/cart_item.dart';
import '../controllers/carts_controller.dart';
import '../view/edit_cart.dart';

class CartItemProductWidget extends StatelessWidget {
  final CartItem item;
  final Function refresh;
  final cartsController = Get.find<CartsController>();

  CartItemProductWidget({super.key, required this.item, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: ListTile(
        onTap: () async {
          await Get.bottomSheet(
            EditCartWidget(item: item),
            enableDrag: true,
            isScrollControlled: true,
            ignoreSafeArea: true,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
          );
          refresh();
        },
        leading: Text(
          "X ${item.quantity}",
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${item.quantity * item.getPrice!}",
                style: TextStyle(
                  color: Color.fromARGB(255, 15, 38, 87),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Pound'.tr,
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          item.product.name,
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
