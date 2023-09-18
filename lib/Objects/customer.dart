import 'package:furniture_shop/Objects/address.dart';

class Customer {
  final String cid;
  String name;
  String? email;
  String? phone;
  String? profileimage;
  String? role;
  List<String>? following;
  List<Address> shippingAddress;
  bool? isDeleted;

  Customer(
      {required this.cid,
      required this.name,
      this.email,
      this.phone = '',
      this.profileimage,
      this.role,
      this.isDeleted = false,
      this.following = const [],
      this.shippingAddress = const []});

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'name': name,
      'email': email,
      'phone': phone,
      'profileimage': profileimage,
      'following': following,
      'isDeleted': isDeleted,
      //TODO: TO JSON FOR SHIPPING ADDRESS
      'shippingAddress': shippingAddress.map(
        (e) => e.toJson(),
      )
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      cid: json['cid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileimage: json['profileimage'],
      following: (json['following'] as List?)?.map((e) => e as String).toList(),
      isDeleted: json['isDeleted'],
      shippingAddress: (json['shippingAddress'] as List<dynamic>)
          .map((e) => Address.fromJson(e))
          .toList(),
    );
  }
}
