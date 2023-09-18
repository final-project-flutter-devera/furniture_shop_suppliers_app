import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/data/data_source/customer_data_service.dart';

class CustomerFirestoreService implements CustomerDataService {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');
  @override
  Future<void> addCustomer(Customer customer) {
    return customers
        .doc(customer.cid)
        .set(customer.toJson())
        .then(
            (value) => debugPrint('Added a customer with ID: ${customer.cid}'))
        .catchError((error) => debugPrint('Failed to add a customer: $error'));
  }

  @override

  ///DO NOT USE WHEN customer REQUEST TO DELETE. To delete a customer set flag isDeleted to true
  Future<void> deleteCustomer(String customerID) {
    return customers
        .doc(customerID)
        .delete()
        .then((value) => debugPrint('Deleted a customer with ID: $customerID'))
        .catchError(
            (error) => debugPrint('Failed to delete a customer: $error'));
  }

  @override
  Future<Customer> getCustomer(String customerID) async {
    Customer? customer;
    await customers.doc(customerID).get().then((querySnapshot) {
      debugPrint('Get customer $customerID successfully');
      customer =
          Customer.fromJson(querySnapshot.data() as Map<String, dynamic>);
    });
    return Future.value(customer);
  }

  @override
  Future<void> updateCustomer(
    String customerID, {
    String? name,
    String? email,
    String? phone,
    String? profileimage,
    List<String>? following,
    List<Address>? shippingAddresses,
    bool? isDeleted,
  }) {
    final updates = {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (profileimage != null) 'profileimage': profileimage,
      if (following != null) 'following': following,
      if (shippingAddresses != null)
        'shippingAddress': shippingAddresses.map((e) => e.toJson()),
      if (isDeleted != null) 'isDeleted': isDeleted,
    };
    if (updates.isNotEmpty) {
      return customers
          .doc(customerID)
          .update(updates)
          .then((value) => debugPrint('Updated a customer: $customerID'))
          .catchError(
              (error) => debugPrint('Failed to update a customer: $error'));
    } else {
      debugPrint('Nothing to update');
      return Future.value(null);
    }
  }
}
