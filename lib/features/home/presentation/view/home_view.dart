import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isupply_app/core/widgets/no_internet_widget.dart';
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
  HomeView({super.key});

  final cartsController = Get.find<CartsController>();

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
                Get.back();
                Get.toNamed("/invoice");
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
                        if (!controller.internet.value)
                          NoInternetWidget(
                            onRetry: () {
                              print(controller.internet.value);
                              controller.internetConnectivity();
                            },
                          ),
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
                                    }),
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
                            child:
                                cont.newListHomeProduct.isNotEmpty
                                    ? SingleChildScrollView(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children:
                                            cont.newListHomeProduct.map((
                                                  Product product,
                                                ) {
                                                  return InkWell(
                                                    onTap: () {
                                                      cartsController
                                                          .addProduct(product);
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
                                    )
                                    : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'لا توجد منتجات متاحة',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'يرجى التحقق لاحقًا.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        if (controller.listHomeProduct.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed:
                                      controller.currentPage.value > 1
                                          ? controller.previousPage
                                          : null,
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Text(
                                  '${controller.currentPage.value} / ${controller.totalPages.value}',
                                ),
                                IconButton(
                                  onPressed:
                                      controller.currentPage.value <
                                              controller.totalPages.value
                                          ? controller.nextPage
                                          : null,
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ],
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const CartView(),
                  ),
              ],
            ),
      ),
    );
  }
}
