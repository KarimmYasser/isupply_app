import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config.dart';
import '../../../cart/presentation/controllers/carts_controller.dart';
import '../../data/data_source/home_faker_data_source.dart';
import '../../data/data_source/home_local_data_source.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../data/repositories/home_repository.dart';

class HomeController extends GetxController {
  var listHomeProduct = <Product>[].obs;
  var newListHomeProduct = <Product>[].obs;
  var listCategory = <Category>[].obs;
  var searching = false.obs;
  var barcoding = false.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode searchFocusNode = FocusNode();
  RxBool isSearchFocused = false.obs;
  RxBool loadingHome = false.obs;
  RxBool showHideCarts = false.obs;
  Timer? _debounceTimer;
  static const itemsPerPage = 30;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  Category? selectedCategory;
  final cartsController = Get.find<CartsController>();

  @override
  void onReady() {
    super.onReady();
    getProductsCategories();
    getProduct();
  }

  onSearch(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      currentPage.value = 1;
      if (value.isEmpty) {
        newListHomeProduct.value = listHomeProduct;
        calculateTotalPages();
        updateProductList();
        update();
        return;
      }
      try {
        newListHomeProduct.value =
            listHomeProduct
                .where(
                  (string) =>
                      string.name.toLowerCase().contains(value.toLowerCase()),
                )
                .toList();
      } catch (e) {
        print("Error during search: $e");
        Get.snackbar("Error", "An error occurred during the search.");
        newListHomeProduct.value = [];
      } finally {
        totalPages.value = (newListHomeProduct.length / itemsPerPage).ceil();
        update();
      }
    });
  }

  onBarcode(String value) {
    newListHomeProduct.value =
        listHomeProduct
            .where(
              (string) =>
                  string.name.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
    update();
  }

  Future getProduct() async {
    loadingHome.value = true;
    listHomeProduct.value = await HomeRepository.getProducts();
    calculateTotalPages();
    updateProductList();
    update();
    loadingHome.value = false;
  }

  Future getProductsByGroupId() async {
    loadingHome.value = true;
    if (selectedCategory == null) {
      return;
    }
    try {
      listHomeProduct.value = await HomeLocalDataSource.getProductsByGroupId(1);
      calculateTotalPages();
      updateProductList();
      update();
    } catch (e) {
      listHomeProduct.value = await HomeFakerDataSource.getProductsByGroupId(1);
      calculateTotalPages();
      updateProductList();
      update();
      print("error getProduct $e");
    }
    loadingHome.value = false;
  }

  Future getProductsCategories() async {
    loadingHome.value = true;
    update();
    listCategory.value = [
      Category(id: 1, name: 'Pharma'),
      Category(id: 2, name: 'Cosmetics'),
    ];
    loadingHome.value = false;
    update();
  }

  Future<void> updateProductStockLocally(String productId, int newStock) async {
    try {
      // Find the product in the local list
      final productIndex = listHomeProduct.indexWhere(
        (product) => product.id == productId,
      );

      if (productIndex != -1) {
        // Update the stock
        listHomeProduct[productIndex].stock = newStock;

        // Update the product in the Hive box
        await productsBox.put(productId, listHomeProduct[productIndex]);

        // Refresh the displayed list
        updateProductList();
        update();
      } else {
        print("Product not found in local list");
      }
    } catch (e) {
      print("Error updating product stock locally: $e");
      Get.snackbar("Error", "Failed to update product stock locally");
    }
  }

  Future changeCategory(Category cat) async {
    if (cat == selectedCategory) {
      selectedCategory = null;
      getProduct();
      return;
    } else {
      selectedCategory = cat;
    }
    update();
    loadingHome.value = !loadingHome.value;
    getProductsByGroupId();
    refresh();
  }

  Future showHidCart() async {
    showHideCarts.value = !showHideCarts.value;
    update();
  }

  Future showSearch() async {
    searching.value = !searching.value;
    if (searching.value) {
      searchFocusNode.requestFocus();
      isSearchFocused.value = true;
    } else {
      searchFocusNode.unfocus();
      cartsController.cartFocusNode.requestFocus();
      isSearchFocused.value = false;
    }
    update();
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void goToPage(int page) {
    currentPage.value = page;
    updateProductList();
  }

  void nextPage() {
    if (currentPage.value == totalPages.value) {
      return;
    }
    currentPage.value += 1;
    updateProductList();
  }

  void previousPage() {
    if (currentPage.value == 1) {
      return;
    }
    currentPage.value -= 1;
    updateProductList();
  }

  void updateProductList() {
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= listHomeProduct.length) {
      newListHomeProduct.value = [];
    } else {
      newListHomeProduct.value = listHomeProduct.sublist(
        startIndex,
        endIndex > listHomeProduct.length ? listHomeProduct.length : endIndex,
      );
    }
    update();
  }

  void calculateTotalPages() {
    totalPages.value = (listHomeProduct.length / itemsPerPage).ceil();
  }
}
