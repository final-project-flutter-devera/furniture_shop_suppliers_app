import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/supplier.dart';

abstract class SupplierRepository {
  Future<void> addSupplier(Supplier supplier);
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
  });

  Future<void> deleteSupplier(String supplierID);
  Future<Supplier> getSupplier(String supplierID);
}
