import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controllers/invoice_controller.dart';

class InvoiceTable extends GetView<InvoiceController> {
  const InvoiceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.getInvoice(),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Obx(
                () => DataTable(
                  columnSpacing:
                      ResponsiveBreakpoints.of(context).screenWidth * 0.13,
                  headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                  columns: const [
                    DataColumn(
                      label: Text('رقم الفاتورة', textAlign: TextAlign.center),
                    ),
                    DataColumn(
                      label: Text('الحالة', textAlign: TextAlign.center),
                    ),
                    DataColumn(
                      label: Text('التاريخ', textAlign: TextAlign.center),
                    ),
                    DataColumn(
                      label: Text('الوقت', textAlign: TextAlign.center),
                    ),
                    DataColumn(
                      label: Text('القيمة', textAlign: TextAlign.center),
                    ),
                  ],
                  rows:
                      controller.newListInvoice.map((invoice) {
                        return DataRow(
                          cells: [
                            DataCell(Text(invoice.id)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      invoice.status == 'Done'
                                          ? Colors.green
                                          : invoice.status == 'Pending'
                                          ? Colors.orange
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  invoice.status.tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataCell(Text(invoice.date)),
                            DataCell(Text(invoice.time)),
                            DataCell(Text(invoice.totalPaid.toString())),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
