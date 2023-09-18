import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/customer.dart';

abstract class CustomerRepository {
  Future<void> addCustomer(Customer user);
  Future<void> updateCustomer(
    String userID, {
    String? name,
    String? email,
    String? phone,
    String? profileimage,
    List<String>? following,
    List<Address>? shippingAddresses,
    bool? isDeleted,
  });
  Future<void> deleteCustomer(String customerID);
  Future<Customer> getCustomer(String customerID);
}
