import 'dart:math';

import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Screen/9.%20Notifications/Components/notification_card.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<StatefulWidget> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const Icon(
            Icons.search,
            size: 20,
          ),
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Notification'),
          titleTextStyle: AppStyle.app_bar_title_text_style,
          foregroundColor: AppColor.black,
        ),
        backgroundColor: AppColor.white,
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: ((context, index) => NotificationCard(
                  hasImage: Random().nextBool(),
                  isAd: Random().nextBool(),
                  isViewed: Random().nextBool(),
                ))));
  }
}
