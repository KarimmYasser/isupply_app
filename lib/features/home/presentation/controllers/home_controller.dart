import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool loadingHome = false.obs;
  RxBool showHideCarts = false.obs;

  @override
  void onReady() {
    super.onReady();
    getProductsCategories();
    getProduct();
  }

  Category? selectedCategory;

  onSearch(String value) {
    newListHomeProduct.value =
        listHomeProduct
            .where(
              (string) =>
                  string.name.toLowerCase().contains(value.toLowerCase()),
            )
            .toList();
    update();
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
      listHomeProduct.value = await HomeLocalDataSource.getProducts();
      newListHomeProduct.value = listHomeProduct;
      update();
    } catch (e) {
      listHomeProduct.value = await HomeFakerDataSource.getProducts();
      newListHomeProduct.value = listHomeProduct;
      update();
      print("error getProduct $e");
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
      newListHomeProduct.value = listHomeProduct;
      update();
    } catch (e) {
      listHomeProduct.value = await HomeFakerDataSource.getProductsByGroupId(1);
      newListHomeProduct.value = listHomeProduct;
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
    update();
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }
}
