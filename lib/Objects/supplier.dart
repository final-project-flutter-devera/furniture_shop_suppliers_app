import 'package:furniture_shop/Objects/address.dart';

class Supplier {
  final String sid;
  String name;
  String? email;
  String? phone;
  String? profileimage;
  List<String>? follower;
  String? storeCoverImage;
  List<Address> storeAddress;
  bool? isDeleted;

  Supplier({
    required this.sid,
    required this.name,
    this.email,
    this.phone = '',
    this.profileimage,
    this.follower = const [],
    this.storeAddress = const [],
    this.storeCoverImage,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'name': name,
      'email': email,
      'phone': phone,
      'profileimage': profileimage,
      'follower': follower,
      //TODO: TO JSON FOR SHIPPING ADDRESS
      'storeAddress': storeAddress.map(
        (e) => e.toJson(),
      ),
      'storeCoverImage': storeCoverImage,
      'isDeleted': isDeleted,
    };
  }

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      sid: json['sid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileimage: json['profileimage'],
      follower: (json['follower'] as List?)?.map((e) => e as String).toList(),
      isDeleted: json['isDeleted'],
      storeAddress: (json['storeAddress'] as List<dynamic>)
          .map((e) => Address.fromJson(e))
          .toList(),
      storeCoverImage: json['storeCoverImage'],
    );
  }
}
