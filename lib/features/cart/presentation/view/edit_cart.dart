import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config.dart';
import '../../data/models/cart_item.dart';
import '../controllers/carts_controller.dart';
import '../widgets/key_pad.dart';

class EditCartWidget extends StatefulWidget {
  const EditCartWidget({super.key, required this.item});
  final CartItem item;

  @override
  _EditCartWidgetState createState() => _EditCartWidgetState();
}

class _EditCartWidgetState extends State<EditCartWidget> {
  TextEditingController pinController = TextEditingController();
  final cartsController = Get.find<CartsController>();

  @override
  void initState() {
    super.initState();
    refreshView();
  }

  bool isPriceSelected = false;
  refreshView() {
    if (isPriceSelected == true) {
      pinController.text = widget.item.getPrice.toString();
    } else {
      pinController.text = widget.item.quantity.toString();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.item.product.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "الباركود : ",
                              style: TextStyle(
                                color: Colors.black.withAlpha(102),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${faker.datatype.number(min: 10000000, max: 932838389)}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "السعر : ",
                              style: TextStyle(
                                color: Colors.black.withAlpha(102),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: "${widget.item.getPrice} جنيه",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                    border: Border.all(
                      width: 1.0,
                      color: const Color(0xffdadada),
                    ),
                  ),
                  child: Image.network(
                    widget.item.product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isPriceSelected = true;
                      });
                      refreshView();
                    },
                    child: Container(
                      color: isPriceSelected ? Colors.white : Color(0xffF4F5FA),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Color(
                                isPriceSelected ? 0xff178f49 : 0xffE6E6E6,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  "${widget.item.getPrice}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "السعر",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isPriceSelected = false;
                      });
                      refreshView();
                    },
                    child: Container(
                      color:
                          !isPriceSelected ? Colors.white : Color(0xffF4F5FA),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Color(
                                !isPriceSelected ? 0xff178f49 : 0xffE6E6E6,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  "${widget.item.quantity}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "العدد",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xfff4f5fa),
              border: Border.all(width: 1.0, color: const Color(0xffdadada)),
            ),
            child: Text(
              pinController.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff000000),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 400,
            child: KeyPad(
              onChange: (t) {
                setState(() {});
              },
              textEditingController: pinController,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      cartsController.deleteItem(widget.item);
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffE14646),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "حذف",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (isPriceSelected == true) {
                        widget.item.sellingPrice = double.parse(
                          pinController.text,
                        );
                      } else {
                        widget.item.quantity = int.parse(pinController.text);
                      }
                      cartsController.updateItem(widget.item);
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff178F49),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "تحديث",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
