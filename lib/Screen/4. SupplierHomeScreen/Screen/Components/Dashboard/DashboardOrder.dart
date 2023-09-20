import 'package:flutter/material.dart';
import 'package:furniture_shop/Screen/4.%20SupplierHomeScreen/Screen/Components/Dashboard/SupOrder/SupPreparing.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../Constants/Colors.dart';
import 'SupOrder/SupDelivered.dart';
import 'SupOrder/SupShipping.dart';

class OrderDashboard extends StatefulWidget {
  const OrderDashboard({super.key});

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const TabBarView(
          children: [
            SupPreparing(),
            SupShipping(),
            SupDelivered()
          ],
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.white,
          leading: const AppBarBackButtonPop(),
          title: const AppBarTitle(label: 'Orders'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColor.black,
            indicatorColor: AppColor.black,
            unselectedLabelColor: AppColor.disabled_button,
            indicator: UnderlineTabIndicator(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                borderSide: const BorderSide(width: 3),
                insets: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 10)),
            tabs: [
              Tab(child: Text('Preparing',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 18))),
              Tab(child: Text('Shipping',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 18))),
              Tab(child: Text('Delivered',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 18))),
            ],),
        ),
      ),
    );
  }
}