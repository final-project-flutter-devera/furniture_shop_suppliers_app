import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Providers/Auth_response.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../../../../../Constants/Colors.dart';
import '../../../../../Models/Product_model.dart';

class ManageProductDashboard extends StatefulWidget {
  const ManageProductDashboard({super.key});

  @override
  State<ManageProductDashboard> createState() => _ManageProductDashboardState();
}

class _ManageProductDashboardState extends State<ManageProductDashboard> {
  final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('sid', isEqualTo: AuthRepo.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.white,
        leading: const AppBarBackButtonPop(),
        title: const AppBarTitle(label: 'Manage Products'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return ProductModel(
                  products: snapshot.data!.docs[index],
                );
              },
              staggeredTileBuilder: (context) =>
              const StaggeredTile.fit(1),
            ),
          );
        },
      ),
    );
  }
}