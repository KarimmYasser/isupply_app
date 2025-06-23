import '../../models/customer.dart';

abstract class RemoteCustomer {
  Future<Customer> store(Customer customer);
  Future <List<Customer>> load();
}