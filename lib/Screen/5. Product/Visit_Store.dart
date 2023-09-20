import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../Models/Product_model.dart';
import '../4. SupplierHomeScreen/Screen/Components/Dashboard/SupStore/Edit_Store_Screen.dart';

class VisitStore extends StatefulWidget {
  final String supplierID;

  const VisitStore({super.key, required this.supplierID});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;


  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('Suppliers');
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.supplierID)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.supplierID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List follower = data['follower'];
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 135,
              leading: const AppBarBackButtonPop(),
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  data['storeCoverImage'] == ''
                      ? Image.asset(
                          'assets/Images/Images/boarding.png',
                          fit: BoxFit.cover,
                        )
                      : Image.network(data['storeCoverImage'],fit: BoxFit.cover,),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter,
                        colors: [
                          AppColor.black,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 39,
                        backgroundColor: AppColor.white,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(data['storeLogo']),
                          backgroundColor: AppColor.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: wMQ * 0.5,
                        child: Text(
                          data['name'],
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              color: AppColor.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColor.amber,
                            size: 15,
                          ),
                          Text(
                            '5.0 / ',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColor.white,
                            ),
                          ),

                          Text(
                            '${follower.length.toString()} followers',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                      widget.supplierID ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? Container(
                              width: 110,
                              height: 35,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: AppColor.white),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditStore(
                                                data: data,
                                              )));
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Edit'),
                                    Icon(Icons.edit),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(height: 35,)
                    ],
                  ),
                ],
              ),
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

        return const Scaffold();
      },
    );
  }
}
