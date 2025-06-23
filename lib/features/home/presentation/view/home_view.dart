// ignore: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../cart/presentation/controllers/carts_controller.dart';
import '../../../cart/presentation/view/cart_view.dart';
import '../../data/models/product.dart';
import '../controllers/home_controller.dart';
import '../widgets/cart_action_button.dart';
import '../widgets/category_widget.dart';
import '../widgets/header_home.dart';
import '../widgets/product_widget.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final cartsController = Get.put(CartsController());

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          ResponsiveBreakpoints.of(context).isMobile
              ? CartActionButton()
              : null,
      key: controller.scaffoldKey,
      drawer: Drawer(
        shape: ContinuousRectangleBorder(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 15, 38, 87),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 50),
                    SizedBox(height: 10),
                    Text(
                      'Sales management system'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'.tr),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Products'.tr),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'.tr),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Invoices'.tr),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'.tr),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF4F5FA),
      body: GetBuilder<HomeController>(
        builder:
            (HomeController cont) => Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeaderHomeWidget(controller: cont),
                        if (cont.showHideCarts.value &&
                            ResponsiveBreakpoints.of(context).isMobile)
                          const Expanded(child: CartView()),
                        if (!(cont.showHideCarts.value &&
                            ResponsiveBreakpoints.of(context).isMobile))
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(width: 10),
                                    ...cont.listCategory.map((category) {
                                      return GestureDetector(
                                        onTap: () {
                                          cont.changeCategory(category);
                                        },
                                        child: CategoryWidget(
                                          title: category.name,
                                          isSelected:
                                              cont.selectedCategory != null &&
                                              cont.selectedCategory!.id ==
                                                  category.id,
                                        ),
                                      );
                                    }).toList(),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        if (!(cont.showHideCarts.value &&
                            ResponsiveBreakpoints.of(context).isMobile))
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children:
                                    cont.newListHomeProduct.map((
                                          Product product,
                                        ) {
                                          return InkWell(
                                            onTap: () {
                                              cartsController.addProduct(
                                                product,
                                              );
                                            },
                                            child: SizedBox(
                                              width:
                                                  width < 450
                                                      ? width * 0.9
                                                      : 224,
                                              height: 250,
                                              child: ProductWidget(
                                                product: product,
                                              ),
                                            ),
                                          );
                                        }).toList()
                                        as List<Widget>,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (!ResponsiveBreakpoints.of(context).isMobile)
                  Container(
                    width:
                        ResponsiveBreakpoints.of(context).screenWidth > 1000
                            ? ResponsiveBreakpoints.of(context).screenWidth *
                                0.3
                            : 300,
                    color: Colors.white,
                    child: const CartView(),
                  ),
              ],
            ),
      ),
    );
  }
}
