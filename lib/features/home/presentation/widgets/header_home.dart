import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'search_widget.dart';

class HeaderHomeWidget extends StatelessWidget {
  const HeaderHomeWidget({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.2,
      title: SearchBar(
        isSearching: controller.searching.value,
        controller: controller,
        isBarcode: controller.barcoding.value,
        isAutoFous: controller.barcoding.value,
      ),
      leading: InkWell(
        onTap: () {
          controller.openDrawer();
        },
        child: Container(
          color: const Color.fromARGB(255, 15, 38, 87),
          width: 50,
          child: const Icon(Icons.menu, color: Colors.white),
        ),
      ),
      actions:
          controller.searching.value
              ? [
                InkWell(
                  onTap: () {
                    controller.showSearch();
                  },
                  child: Icon(Icons.close, color: Colors.black, size: 30),
                ),
                SizedBox(width: 12),
              ]
              : [
                InkWell(
                  child: SvgPicture.asset(
                    "assets/svg/barcode.svg",
                    width: 30,
                  ),
                  onTap: () {},
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    controller.showSearch();
                  },
                  child: SvgPicture.asset("assets/svg/search.svg", width: 20),
                ),
                SizedBox(width: 20),
              ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final bool isSearching;
  final bool isBarcode;
  final bool isAutoFous;
  final HomeController controller;

  const SearchBar({super.key, 
    required this.isSearching,
    required this.controller,
    required this.isBarcode,
    required this.isAutoFous,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimateExpansion(
          animate: true,
          axisAlignment: 1.0,
          child: Text(
            'Sales'.tr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        AnimateExpansion(
          animate: isSearching,
          axisAlignment: -1.0,
          child: Search(controller),
        ),
      ],
    );
  }
}
