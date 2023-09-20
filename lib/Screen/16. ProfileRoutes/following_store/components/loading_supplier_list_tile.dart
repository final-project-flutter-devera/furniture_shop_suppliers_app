import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/loading_avatar.dart';
import 'package:shimmer/shimmer.dart';

class LoadingFollowerListTile extends StatelessWidget {
  const LoadingFollowerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(
          bottom: BorderSide(color: AppColor.blur_grey),
          top: BorderSide(color: AppColor.blur_grey)),
      contentPadding: const EdgeInsets.all(10),
      leading: const LoadingAvatar(),
      titleAlignment: ListTileTitleAlignment.center,
      title: Shimmer.fromColors(
        baseColor: AppColor.baseShimmerColor,
        highlightColor: AppColor.highlightShimmerColor,
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.widgetShimmerColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          height: 20,
          width: 100,
        ),
      ),
      trailing:
          IconButton(onPressed: () {}, icon: const Icon(Icons.remove_outlined)),
      onTap: () {},
    );
  }
}
