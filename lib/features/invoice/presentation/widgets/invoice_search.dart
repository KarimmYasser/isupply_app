import 'package:flutter/material.dart';
import 'package:isupply_app/features/invoice/presentation/controllers/invoice_controller.dart';

class InvoiceSearch extends StatelessWidget {
  const InvoiceSearch({super.key});

  @override
  Widget build(BuildContext context) {
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
              onChanged: InvoiceController.to.onSearch,
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
}
