import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:isupply_app/features/cart/presentation/controllers/carts_controller.dart';
import 'package:isupply_app/features/home/data/repositories/home_repository.dart';

import '../../data/data_source/home_faker_data_source.dart';
import '../../data/data_source/home_local_data_source.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';

class HomeController extends GetxController {
  var listHomeProduct = <Product>[].obs;
  var newListHomeProduct = <Product>[].obs;
  var listCategory = <Category>[].obs;
  var searching = false.obs;
  var barcoding = false.obs;
  var internet = true.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode searchFocusNode = FocusNode();
  RxBool isSearchFocused = false.obs;
  RxBool loadingHome = false.obs;
  RxBool showHideCarts = false.obs;
  late Timer _timer;
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
    try {
      listHomeProduct.value = await HomeRepository.getProducts();
      calculateTotalPages();
      updateProductList();
      update();
    } catch (e) {
      listHomeProduct.value = await HomeFakerDataSource.getProducts();
      calculateTotalPages();
      updateProductList();
      update();
    }
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

  Future internetConnectivity() async {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) async {
      internet.value = await InternetConnection().hasInternetAccess;
      update();
    });
  }

  void stopCheckingInternet() {
    _timer.cancel();
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
