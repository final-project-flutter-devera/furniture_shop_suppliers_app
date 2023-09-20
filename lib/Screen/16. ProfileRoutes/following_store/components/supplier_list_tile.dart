import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/Widgets/avatar.dart';

class FollowerListTile extends StatelessWidget {
  final Customer customer;
  const FollowerListTile({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(
          bottom: BorderSide(color: AppColor.blur_grey),
          top: BorderSide(color: AppColor.blur_grey)),
      contentPadding: const EdgeInsets.all(10),
      leading: Avatar(
        name: customer.name,
        avatarLink: customer.profileimage,
      ),
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(
        customer.name,
        textAlign: TextAlign.left,
        style: AppStyle.tab_title_text_style,
        overflow: TextOverflow.fade,
      ),
      trailing:
          IconButton(onPressed: () {}, icon: const Icon(Icons.remove_outlined)),
    );
  }
}
