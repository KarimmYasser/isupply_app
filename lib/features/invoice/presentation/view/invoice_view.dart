import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/widgets/no_internet_widget.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({Key? key}) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
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
            final controller = Get.find<HomeController>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!controller.internet.value)
                  NoInternetWidget(
                    onRetry: () {
                      print(controller.internet.value);
                      controller.internetConnectivity();
                    },
                  ),
                // SizedBox(height: 8),
                // Center(
                //   child: Wrap(
                //     spacing: 12,
                //     runSpacing: 12,
                //     children: [
                //       FractionallySizedBox(
                //         widthFactor:
                //             ResponsiveBreakpoints.of(context).isMobile
                //                 ? 0.45
                //                 : 0.20,
                //         child: buildStatCard(
                //           'فواتير اليوم',
                //           '40',
                //           Colors.green,
                //         ),
                //       ),
                //       FractionallySizedBox(
                //         widthFactor:
                //             ResponsiveBreakpoints.of(context).isMobile
                //                 ? 0.45
                //                 : 0.20,
                //         child: buildStatCard(
                //           'فواتير الاسبوع',
                //           '160',
                //           Colors.orangeAccent,
                //         ),
                //       ),
                //       FractionallySizedBox(
                //         widthFactor:
                //             ResponsiveBreakpoints.of(context).isMobile
                //                 ? 0.45
                //                 : 0.20,
                //         child: buildStatCard(
                //           'فواتير الشهر',
                //           '1200',
                //           Colors.amber,
                //         ),
                //       ),
                //       FractionallySizedBox(
                //         widthFactor:
                //             ResponsiveBreakpoints.of(context).isMobile
                //                 ? 0.45
                //                 : 0.20,
                //         child: buildStatCard(
                //           'كل الفواتير',
                //           '5000',
                //           Colors.brown,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 24),
                buildSearchAndFilter(),
                const SizedBox(height: 12),
                buildInvoicesTable(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ادخل رقم الفاتورة',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInvoicesTable() {
    final invoices = List.generate(100, (index) {
      return {
        'number': '1551689168728',
        'customer': 'زبون ${index + 11}',
        'date': index == 1 ? '31/10/2021' : '01/11/2021',
        'time': index == 1 ? '07:05:22' : '12:60:10',
        'amount': index == 1 ? '110\$' : '500\$',
        'status': index == 0 ? 'معلقة' : 'دفع',
      };
    });

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            DataTable(
              columnSpacing:
                  ResponsiveBreakpoints.of(context).screenWidth * 0.13,
              headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
              columns: const [
                DataColumn(
                  label: Text('رقم الفاتورة', textAlign: TextAlign.center),
                ),
                DataColumn(label: Text('الحالة', textAlign: TextAlign.center)),
                DataColumn(label: Text('التاريخ', textAlign: TextAlign.center)),
                DataColumn(label: Text('الوقت', textAlign: TextAlign.center)),
                DataColumn(label: Text('القيمة', textAlign: TextAlign.center)),
              ],
              rows:
                  invoices.map((invoice) {
                    return DataRow(
                      cells: [
                        DataCell(Text(invoice['number']!)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  invoice['status'] == 'دفع'
                                      ? Colors.green
                                      : Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              invoice['status']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        DataCell(Text(invoice['date']!)),
                        DataCell(Text(invoice['time']!)),
                        DataCell(Text(invoice['amount']!)),
                      ],
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
