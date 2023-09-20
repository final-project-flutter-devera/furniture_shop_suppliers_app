import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Canceled_Screen.dart';
import 'Delivered_Screen.dart';
import 'Processing_Screen.dart';
import 'Shipping_Screen.dart';


class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: const TabBarView(
          children: [
            Processing(),
            Shipping(),
            Delivered(),
            Canceled(),
          ],
        ),
        appBar: AppBar(
          backgroundColor: AppColor.white,
          foregroundColor: AppColor.black,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
            ),
          ),
          title: const AppBarTitle(label: 'My Order'),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 30),
            labelColor: AppColor.black,
            indicatorColor: AppColor.black,
            unselectedLabelColor: AppColor.disabled_button,
            indicator: UnderlineTabIndicator(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                borderSide: const BorderSide(width: 3),
                insets: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 10)),
            tabs: [
              Tab(
                  child: Text('Processing',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 18))),
              Tab(
                  child: Text('Shipping',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 18))),
              Tab(
                  child: Text('Delivered',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 18))),
              Tab(
                  child: Text('Canceled',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}
