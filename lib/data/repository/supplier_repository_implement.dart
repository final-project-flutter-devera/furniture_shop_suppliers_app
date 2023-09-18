import 'dart:math';

import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/supplier.dart';
import 'package:furniture_shop/data/data_source/remote/supplier_firestore_service.dart';
import 'package:furniture_shop/data/repository/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierFirestoreService _supplierFirestoreService;

  SupplierRepositoryImpl({SupplierFirestoreService? supplierFirestoreService})
      : _supplierFirestoreService =
            supplierFirestoreService ?? SupplierFirestoreService();
  @override
  Future<void> addSupplier(Supplier supplier) {
    return _supplierFirestoreService.addSupplier(supplier);
  }

  @override
  Future<void> deleteSupplier(String supplierID) {
    return _supplierFirestoreService.deleteSupplier(supplierID);
  }

  @override
  Future<Supplier> getSupplier(String supplierID) {
    return _supplierFirestoreService.getSupplier(supplierID);
  }

  @override
  Future<void> updateSupplier(String supplierID,
      {String? name,
      String? email,
      String? phone,
      String? profileimage,
      List<String>? follower,
      String? storeCoverImage,
      List<Address>? storeAddress,
      bool? isDeleted}) {
    return _supplierFirestoreService.updateSupplier(supplierID,
        name: name,
        email: email,
        phone: phone,
        profileimage: profileimage,
        follower: follower,
        storeCoverImage: storeCoverImage,
        storeAddress: storeAddress,
        isDeleted: isDeleted);
  }
}
