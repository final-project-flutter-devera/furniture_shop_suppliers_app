import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/following_store/components/supplier_list_tile.dart';
import 'package:furniture_shop/localization/app_localization.dart';

class CustomerSearchDelegate extends SearchDelegate {
  final BuildContext context;
  final List<Customer> followingSuppliers;
  CustomerSearchDelegate(
      {required this.context, required this.followingSuppliers});
  //TODO: Implement search history?
  @override
  String? get searchFieldLabel => context.localize('label_search_for_follower');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  Widget suggestionTile(Customer customer) {
    return FollowerListTile(customer: customer);
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (followingSuppliers.isEmpty) {
      return Center(
        child: Text(
          context.localize('label_no_supplier_followed'),
          style: AppStyle.tab_title_text_style,
        ),
      );
    }

    if (query.isEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: followingSuppliers.length,
        itemBuilder: ((context, index) =>
            FollowerListTile(customer: followingSuppliers[index])),
      );
    }

    List<Customer> suggestion = [];

    for (final supplier in followingSuppliers) {
      if (supplier.name.toLowerCase().contains(query.toLowerCase())) {
        suggestion.add(supplier);
      }
    }

    return ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: ((context, index) =>
            FollowerListTile(customer: suggestion[index])));
  }
}
