import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetail {
  final String productID;
  final int amount;
  const ProductDetail({required this.productID, required this.amount});
  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'amount': amount,
    };
  }

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productID: json['productID'] as String,
      amount: json['amount'] as int,
    );
  }
}

class Order {
  final String id;
  final String buyerID;
  final String sellerID;
  String? ratingAndReviewID;

  List<ProductDetail> productDetail;

  double totalPrice;
  late Timestamp? orderDate;

  Timestamp? deliveryDate;
  Timestamp? cancelDate;
  late String? status;

  Order({
    required this.id,
    required this.buyerID,
    required this.sellerID,
    required this.productDetail,
    this.ratingAndReviewID,
    this.totalPrice = 0,
    this.status = 'Processing',
    this.orderDate,
    this.deliveryDate,
    this.cancelDate,
  }) {
    //TODO: Calculate totalPrice later
    orderDate ??= Timestamp.now();
  }

  void updateStatus(String status) {
    this.status = status;
  }

  void updateDeliveryDate() {
    if (deliveryDate == null) {
      deliveryDate = Timestamp.now();
    } else {
      throw 'This order already has a delivery date';
    }
  }

  void cancelOrder() {
    if (cancelDate == null) {
      cancelDate = Timestamp.now();
    } else {
      throw 'This order is already canceled';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerID': buyerID,
      'sellerID': sellerID,
      'ratingAndReviewID': ratingAndReviewID,
      'productDetail': productDetail
          .map((e) => {'productID': e.productID, 'amount': e.amount}),
      'totalPrice': totalPrice,
      'status': status,
      'orderDate': orderDate.toString(),
      'deliveryDate': deliveryDate.toString(),
      'cancelDate': cancelDate.toString(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      buyerID: json['buyerID'] as String,
      sellerID: json['sellerID'] as String,
      ratingAndReviewID: json['ratingAndReviewID'] as String?,
      productDetail: (json['productDetail'] as List<dynamic>)
          .map((e) => ProductDetail.fromJson(e))
          .toList(),
      status: json['status'] as String,
      totalPrice: json['totalPrice'] as double,
      orderDate: json['orderDate'] as Timestamp,
      deliveryDate: json['deliveryDate'] as Timestamp?,
      cancelDate: json['cancelDate'] as Timestamp?,
    );
  }
}
