import 'package:flutter/material.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/supplier.dart';
import 'package:furniture_shop/Providers/Auth_response.dart';
import 'package:furniture_shop/data/repository/supplier_repository.dart';
import 'package:furniture_shop/data/repository/supplier_repository_implement.dart';

class SupplierProvider extends ChangeNotifier {
  late SupplierRepository _supplierRepository;
  SupplierProvider() {
    _supplierRepository = SupplierRepositoryImpl();
    _init();
  }
  _init() {
    notifyListeners();
  }

  ///Only used to get supplier ID when using supplier app
  String getID() {
    return AuthRepo.uid;
  }

  void addSupplier(Supplier supplier) async {
    await _supplierRepository.addSupplier(supplier);
    notifyListeners();
  }

  Future<Supplier> getCurrentSupplier() async {
    Supplier supplier;
    supplier = await _supplierRepository.getSupplier(getID());
    notifyListeners();
    return supplier;
  }

  Future<Supplier> getSupplier(String supplierID) async {
    Supplier supplier;
    supplier = await _supplierRepository.getSupplier(supplierID);
    notifyListeners();
    return supplier;
  }

  void updateCurrentSupplier(
      {String? name,
      String? email,
      String? phone,
      String? profileimage,
      List<String>? follower,
      String? storeCoverImage,
      List<Address>? storeAddress,
      bool? isDeleted}) {
    _supplierRepository.updateSupplier(getID(),
        name: name,
        email: email,
        phone: phone,
        profileimage: profileimage,
        follower: follower,
        storeCoverImage: storeCoverImage,
        storeAddress: storeAddress,
        isDeleted: isDeleted);
  }

  void updateSupplier(String supplierID,
      {String? name,
      String? email,
      String? phone,
      String? profileimage,
      List<String>? follower,
      String? storeCoverImage,
      List<Address>? storeAddress,
      bool? isDeleted}) {
    _supplierRepository.updateSupplier(supplierID,
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
