import 'package:cloud_firestore/cloud_firestore.dart';

///The relationship of user with 'Vendor' role and Product
class VendorSupplies {
  final String vendorSuppliesID;
  final String userID;
  final String productID;
  int stock;
  double discount;
  Timestamp? discountStart;
  Timestamp? discountEnd;
  VendorSupplies({
    required this.vendorSuppliesID,
    required this.userID,
    required this.productID,
    required this.stock,
    this.discount = 0,
    this.discountStart,
    this.discountEnd,
  });

  ///Schedule a discount. Discount start can be before DateTime.now(),
  ///in this case discount will start immediately.
  void scheduleDiscount(double discount, Timestamp start, Timestamp end) {
    this.discount = discount;
    discountStart = start;
    discountEnd = end;
  }

  void removeDiscount() {
    discount = 0;
  }

  ///Used when vendor resupplies product
  void addStock(int addingValue) {
    stock += addingValue;
  }

  ///Used when an order with this product is placed
  void removeStock(int removingValue) {
    stock -= removingValue;
  }
}
