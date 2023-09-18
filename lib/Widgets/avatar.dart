import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';

class Avatar extends StatelessWidget {
  final String? avatarLink;
  final String name;
  Avatar({super.key, required this.name, this.avatarLink});

  @override
  CircleAvatar build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColor.amber,
      radius: 45,
      child: CircleAvatar(
          backgroundColor: AppColor.white,
          radius: 40,
          child: avatarLink == null || avatarLink == ''
              ? Text(
                  (() {
                    final _initials = name.split(' ').reduce((value, element) =>
                        value[0] + element[0].toUpperCase());
                    return _initials.substring(_initials.length - 2);
                  })(),
                  style: TextStyle(color: AppColor.black, fontSize: 40),
                )
              : Image.network(avatarLink!)),
    );
  }
}
