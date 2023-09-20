import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAvatar extends StatelessWidget {
  const LoadingAvatar({super.key});

  @override
  CircleAvatar build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: AppColor.amber,
        radius: 45,
        child: Shimmer.fromColors(
          baseColor: AppColor.baseShimmerColor,
          highlightColor: AppColor.highlightShimmerColor,
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            radius: 40,
          ),
        ));
  }
}
