import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/Providers/Auth_response.dart';
import 'package:furniture_shop/data/repository/customer_repository.dart';
import 'package:furniture_shop/data/repository/customer_repository_implement.dart';

class CustomerProvider extends ChangeNotifier {
  late CustomerRepository _userRepository;
  CustomerProvider() {
    _userRepository = CustomerRepositoryImpl();
    _init();
  }
  _init() {
    notifyListeners();
  }

  ///Only used to get customer ID when using customer app
  String getID() {
    return AuthRepo.uid;
  }

  void addUser(Customer user) async {
    await _userRepository.addCustomer(user);
    notifyListeners();
  }

  Future<Customer> getCurrentCustomer() async {
    Customer user;
    user = await _userRepository.getCustomer(getID());
    notifyListeners();
    return user;
  }

  Future<Customer> getCustomer(String customerID) async {
    Customer customer;
    customer = await _userRepository.getCustomer(customerID);
    notifyListeners();
    return customer;
  }

  ///Call updateUser instead
  // void followVendor(String buyerID, String vendorID) async {
  //   final buyerFuture = _userRepository.getUser(buyerID);
  //   final vendorFuture = _userRepository.getUser(vendorID);
  //   final buyer = await buyerFuture;
  //   final vendor = await vendorFuture;

  //   buyer.following.add(vendorID);
  //   vendor.follower.add(buyerID);
  //   await Future.wait([
  //     _userRepository.updateUser(buyerID, following: buyer.following),
  //     _userRepository.updateUser(vendorID, follower: vendor.follower),
  //   ]);
  //   notifyListeners();
  // }

  void updateCurrentCustomer(
      {String? name,
      String? email,
      String? phone,
      String? profileimage,
      List<String>? following,
      List<Address>? shippingAddress,
      bool? isDeleted}) {
    _userRepository.updateCustomer(getID(),
        name: name,
        email: email,
        phone: phone,
        profileimage: profileimage,
        following: following,
        shippingAddresses: shippingAddress,
        isDeleted: isDeleted);
  }

  void updateCustomer(String customerID,
      {String? name,
      String? email,
      String? phone,
      String? profileimage,
      List<String>? following,
      List<Address>? shippingAddress,
      bool? isDeleted}) {
    _userRepository.updateCustomer(customerID,
        name: name,
        email: email,
        phone: phone,
        profileimage: profileimage,
        following: following,
        shippingAddresses: shippingAddress,
        isDeleted: isDeleted);
  }
}
