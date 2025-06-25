import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../customer/data/models/customer.dart';
import '../../../customer/presentation/controllers/customer_controller.dart';
import '../controllers/carts_controller.dart';
import '../widgets/cart_item_product_widget.dart';
import '../widgets/cart_item_widget.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var cartsController = Get.find<CartsController>();

  final TextEditingController textController = TextEditingController();
  final CustomerController customerController = Get.put(CustomerController());
  Customer? selectedCustomer;

  @override
  void initState() {
    super.initState();
    cartsController.cartFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: cartsController.cartFocusNode,
      onKeyEvent: (value) => cartsController.handleKeyEvent(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          () => Container(
            padding: const EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...cartsController.listCarts.map((cart) {
                        final index = cartsController.listCarts.indexOf(cart);

                        return InkWell(
                          onTap: () {
                            cartsController.changeCart(index);
                          },
                          child: CartItemWidget(
                            title: (index + 1).toString(),
                            isSelected:
                                cartsController.selectedCart.value == index,
                          ),
                        );
                      }).toList(),
                      InkWell(
                        onTap: () {
                          cartsController.addCart();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Color.fromARGB(255, 15, 38, 87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 15, 38, 87),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: 56,
                        child: DropdownMenu<Customer?>(
                          width: constraints.maxWidth - 20,
                          controller: textController,
                          expandedInsets: EdgeInsets.zero,
                          inputDecorationTheme: const InputDecorationTheme(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          enableFilter: true,
                          leadingIcon: const Icon(Icons.search),
                          initialSelection:
                              cartsController
                                  .listCarts[cartsController.selectedCart.value]
                                  .customer,
                          hintText: 'اختر عميل ...',
                          onSelected: (Customer? customer) {
                            if (customer != null) {
                              if (customer.mobileNo == "null") {
                                customerController.showDialogAddCustomer();
                                setState(() {});
                              } else {
                                cartsController.setSelectedCustomer(customer);
                              }
                            }
                          },
                          dropdownMenuEntries: [
                            ...customerController.listCustomer.map((customer) {
                              return DropdownMenuEntry(
                                value: customer,
                                label: customer.mobileNo,
                              );
                            }),
                            DropdownMenuEntry(
                              value: Customer(mobileNo: "null"),
                              label: "إضافة عميل جديد",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => cartsController.onDeleteCart(),
                      child: SvgPicture.asset("assets/svg/edit.svg", width: 25),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السلة ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(9999.0, 9999.0),
                            ),
                            color: Colors.red,
                          ),
                          child: Text(
                            '${cartsController.listCarts[cartsController.selectedCart.value].cartItems.length}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        cartsController.clearCarts();
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        "assets/svg/delet.svg",
                        width: 25,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount:
                        cartsController
                            .listCarts[cartsController.selectedCart.value]
                            .cartItems
                            .length,
                    itemBuilder: (context, index) {
                      var item =
                          cartsController
                              .listCarts[cartsController.selectedCart.value]
                              .cartItems[index];
                      return CartItemProductWidget(
                        item: item,
                        refresh: () {
                          setState(() {});
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      cartsController.pay();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 15, 38, 87),
                    ),
                    child:
                        cartsController.isPayLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                              height: 55,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'الدفع',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${cartsController.invoiceTotal}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Pound'.tr,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
