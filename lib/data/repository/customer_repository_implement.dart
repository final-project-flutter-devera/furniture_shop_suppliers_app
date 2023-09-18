import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/data/data_source/remote/customer_firestore_service.dart';
import 'package:furniture_shop/data/repository/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerFirestoreService _userFirestoreService;

  CustomerRepositoryImpl({CustomerFirestoreService? userFirestoreService})
      : _userFirestoreService =
            userFirestoreService ?? CustomerFirestoreService();

  @override
  Future<void> addCustomer(Customer user) {
    return _userFirestoreService.addCustomer(user);
  }

  @override
  Future<void> deleteCustomer(String userID) {
    return _userFirestoreService.deleteCustomer(userID);
  }

  @override
  Future<Customer> getCustomer(String userID) {
    return _userFirestoreService.getCustomer(userID);
  }

  @override
  Future<void> updateCustomer(String userID,
      {String? name,
      String? email,
      String? phone,
      String? profileimage,
      List<String>? following,
      List<Address>? shippingAddresses,
      bool? isDeleted}) {
    return _userFirestoreService.updateCustomer(userID,
        name: name,
        email: email,
        phone: phone,
        profileimage: profileimage,
        following: following,
        shippingAddresses: shippingAddresses,
        isDeleted: isDeleted);
  }
}
