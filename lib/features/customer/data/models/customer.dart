import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 6)
class Customer extends Equatable {
  const Customer({this.name, required this.mobileNo, this.email, this.Id});

  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String mobileNo;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? Id;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    name: json['name'],
    mobileNo: json["mobileNo"],
    email: json["email"],
    Id: json["Id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mobileNo": mobileNo,
    "email": email,
    "Id": Id,
  };

  @override
  List<Object?> get props => [name, mobileNo, email, Id];
}
