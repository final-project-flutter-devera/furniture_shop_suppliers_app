import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/supplier.dart';
import 'package:furniture_shop/data/data_source/supplier_data_service.dart';

class SupplierFirestoreService implements SupplierDataService {
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('Suppliers');

  @override
  Future<void> addSupplier(Supplier supplier) {
    return suppliers
        .doc(supplier.sid)
        .set(supplier.toJson())
        .then(
            (value) => debugPrint('Added a supplier with ID: ${supplier.sid}'))
        .catchError((error) => debugPrint('Failed to add a supplier: $error'));
  }

  @override
  Future<void> deleteSupplier(String supplierID) {
    return suppliers
        .doc(supplierID)
        .delete()
        .then((value) => debugPrint('Deleted a supplier with ID: $supplierID'))
        .catchError(
            (error) => debugPrint('Failed to delete a supplier: $error'));
  }

  @override
  Future<Supplier> getSupplier(String supplierID) async {
    Supplier? supplier;
    await suppliers.doc(supplierID).get().then((querySnapshot) {
      debugPrint('Get supplier $supplierID successfully');
      supplier =
          Supplier.fromJson(querySnapshot.data() as Map<String, dynamic>);
    });
    return Future.value(supplier);
  }

  @override
  Future<void> updateSupplier(
    String supplierID, {
    String? name,
    String? email,
    String? phone,
    String? profileimage,
    List<String>? follower,
    String? storeCoverImage,
    List<Address>? storeAddress,
    bool? isDeleted,
  }) {
    final updates = {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (profileimage != null) 'profileimage': profileimage,
      if (storeCoverImage != null) 'storeCoverImage': storeCoverImage,
      if (follower != null) 'follower': follower,
      if (storeAddress != null)
        'shippingAddress': storeAddress.map((e) => e.toJson()),
      if (isDeleted != null) 'isDeleted': isDeleted,
    };
    if (updates.isEmpty) {
      debugPrint('Nothing to update');
      return Future.value(null);
    }
    return suppliers
        .doc(supplierID)
        .update(updates)
        .then((value) => debugPrint('Updated a supplier: $supplierID'))
        .catchError(
            (error) => debugPrint('Failed to update a supplier: $error'));
  }
}
