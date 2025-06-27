import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isupply_app/features/invoice/presentation/controllers/invoice_controller.dart';

import '../../../../core/connection_controller.dart';
import '../../../../core/widgets/no_internet_widget.dart';
import '../widgets/invoice_search.dart';
import '../widgets/invoice_table.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key});

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  @override
  void initState() {
    super.initState();
    InvoiceController.to.getInvoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        title: Text(
          'الفواتير',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            color: const Color.fromARGB(255, 15, 38, 87),
            width: 50,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() {
                  if (!ConnectionController.to.isConnected.value) {
                    return NoInternetWidget(
                      onRetry: () {
                        ConnectionController.to.forceCheckConnection();
                      },
                    );
                  }
                  return SizedBox.shrink();
                }),
                const SizedBox(height: 24),
                const InvoiceSearch(),
                const SizedBox(height: 12),
                const InvoiceTable(),
              ],
            );
          },
        ),
      ),
    );
  }
}
