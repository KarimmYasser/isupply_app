import 'package:hive/hive.dart';
import 'invoice_item.dart';

@HiveType(typeId: 0)
class Invoice {
  Invoice({
    required this.id,
    required this.mobileNo,
    required this.items,
    required this.date,
    required this.status,
    required this.time,
    required this.totalPaid,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String mobileNo;
  @HiveField(2)
  List<InvoiceItem> items;
  @HiveField(3)
  String date;
  @HiveField(4)
  String status;
  @HiveField(5)
  String time;
  @HiveField(6)
  double totalPaid;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final List<InvoiceItem> invoiceItems = <InvoiceItem>[];
    final List<dynamic> items = json['items'];
    for (final Map<String, dynamic> value in items) {
      invoiceItems.add(InvoiceItem.fromJson(value));
    }
    return Invoice(
      id: json['id'],
      mobileNo: json['mobile_no'],
      items: invoiceItems,
      date: json['date'],
      status: json['status'],
      time: json['time'],
      totalPaid: json['total_paid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mobile_no'] = mobileNo;
    data['items'] = items.map((InvoiceItem value) => value.toJson()).toList();
    data['date'] = date;
    data['status'] = status;
    data['time'] = time;
    data['total_paid'] = totalPaid;
    return data;
  }
}
