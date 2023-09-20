import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/Objects/supplier.dart';
import 'package:furniture_shop/Providers/customer_provider.dart';
import 'package:furniture_shop/Providers/supplier_provider.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/following_store/components/loading_supplier_list_tile.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/following_store/components/supplier_list_tile.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/following_store/components/supplier_search_delegate.dart';
import 'package:furniture_shop/Widgets/default_app_bar.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:provider/provider.dart';

class Follower extends StatefulWidget {
  final Supplier currentSupplier;
  const Follower({super.key, required this.currentSupplier});

  @override
  State<Follower> createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  var isLoading = true;
  late List<Customer> followingSuppliers;

  @override
  void initState() {
    _getFollowers();
    super.initState();
  }

  _getFollowers() async {
    List<Future<Customer>> requests = [];
    widget.currentSupplier.follower?.forEach((customerID) {
      requests.add(context.read<CustomerProvider>().getCustomer(customerID));
    });
    followingSuppliers = await Future.wait(requests);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
            context: context,
            title: context.localize(
              'followers_option',
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: CustomerSearchDelegate(
                            context: context,
                            followingSuppliers: followingSuppliers));
                  },
                  icon: const Icon(Icons.search))
            ]),
        body: widget.currentSupplier.follower == null ||
                widget.currentSupplier.follower!.isEmpty
            ? Center(
                child: Text(
                  context.localize('label_no_supplier_followed'),
                  style: AppStyle.tab_title_text_style,
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.currentSupplier.follower!.length,
                itemBuilder: ((context, index) {
                  if (isLoading) return const LoadingFollowerListTile();
                  return FollowerListTile(customer: followingSuppliers[index]);
                }),
              ));
  }
}
