import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Constants/Colors.dart';
import '../Widgets/ShowAlertDialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;

  const CustomerOrderModel({super.key, this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate = 5;
  late String comment = '';

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    widget.order['orderImage'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order['orderName'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('x${widget.order['orderQuantity']}'),
                              Text('\$ ' +
                                  widget.order['orderPrice'].toStringAsFixed(2))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 35,
                width: 100,
                decoration: const BoxDecoration(color: AppColor.black),
                child: Center(
                  child: Text(
                    'Detail',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColor.white),
                  ),
                ),
              ),
            ),
            widget.order['cancelStatus'] == true
                ? Text(
                    'Canceled',
                    style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.red),
                  )
                : Text(
                    widget.order['deliveryStatus'],
                  ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints:
                  const BoxConstraints(minHeight: 0, maxHeight: double.infinity),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColor.grey5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:    ' + widget.order['cusName'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Phone:    ' + widget.order['phone'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Email:    ' + widget.order['email'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Address:    ' + widget.order['address'],
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    widget.order['cancelStatus'] == true
                        ? Row(
                            children: [
                              Text(
                                'Canceled date:    ',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                (DateFormat('dd/MM/yyyy - HH:mm').format(
                                        widget.order['cancelDate'].toDate()))
                                    .toString(),
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.red),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                'Payment method:   ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.order['paymentStatus'],
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.blue),
                              ),
                            ],
                          ),
                    widget.order['cancelStatus'] == true
                        ? Row(
                            children: [
                              Text(
                                'Order status:    ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Cancel',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.red,
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                'Delivery Status:   ',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.order['deliveryStatus'],
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.green),
                              ),
                            ],
                          ),
                    widget.order['deliveryStatus'] == 'Shipping'
                        ? Text(
                            'Estimated Pick date:    ${DateFormat('dd/MM/yyyy - HH:mm')
                                    .format(
                                        widget.order['deliveryDate'].toDate())}',
                            style: GoogleFonts.nunito(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          )
                        : const Text(''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.order['deliveryStatus'] == 'Delivered' &&
                                widget.order['orderReview'] == false
                            ? MaterialButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Material(
                                      color: AppColor.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: 5,
                                              unratedColor: AppColor.grey5,
                                              minRating: 1,
                                              itemBuilder: (context, _) {
                                                return const Icon(
                                                  Icons.star,
                                                  color: AppColor.amber,
                                                );
                                              },
                                              onRatingUpdate: (value) {
                                                rate = value;
                                              },
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Enter your review',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: AppColor.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: AppColor.black,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                comment = value;
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    height: 39,
                                                    color: AppColor.red,
                                                    child: Text(
                                                      'Cancel',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColor.white),
                                                    ),
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: MaterialButton(
                                                    onPressed: () async {
                                                      CollectionReference
                                                          collRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(widget.order[
                                                                  'proID'])
                                                              .collection(
                                                                  'reviews');
                                                      await collRef
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        'name': widget
                                                            .order['cusName'],
                                                        'email': widget
                                                            .order['email'],
                                                        'profileImages': widget
                                                                .order[
                                                            'profileImages'],
                                                        'comment': comment,
                                                        'rate': rate,
                                                      }).whenComplete(() async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (transaction) async {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'orders')
                                                                  .doc(widget
                                                                          .order[
                                                                      'orderID']);
                                                          transaction.update(
                                                              documentReference,
                                                              {
                                                                'orderReview':
                                                                    true,
                                                              });
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    height: 39,
                                                    color: AppColor.amber,
                                                    child: Text(
                                                      'Send',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColor.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                elevation: 1,
                                height: 30,
                                color: AppColor.amber,
                                textColor: AppColor.black,
                                child: const Text('Review'),
                              )
                            : const Text(''),
                        widget.order['deliveryStatus'] == 'Delivered' &&
                                widget.order['orderReview'] == true
                            ? const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.task_alt),
                                  Text('Review Added')
                                ],
                              )
                            : const Text(''),
                        widget.order['cancelStatus'] == true ||
                                widget.order['sid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                            ? const Text('')
                            : widget.order['deliveryStatus'] == 'Delivered'
                                ? const Text('')
                                : MaterialButton(
                                    onPressed: () {
                                      MyAlertDialog.showMyDialog(
                                        context: context,
                                        title: 'Cancel Order',
                                        content: 'Are you sure?',
                                        tabNo: () {
                                          Navigator.pop(context);
                                        },
                                        tabYes: () {
                                          CollectionReference orderRef =
                                              FirebaseFirestore.instance
                                                  .collection('orders');
                                          orderRef
                                              .doc(widget.order['orderID'])
                                              .update({
                                            'cancelDate': DateTime.now(),
                                            'cancelStatus': true,
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    elevation: 1,
                                    height: 30,
                                    color: AppColor.red,
                                    textColor: AppColor.white,
                                    child: const Text('Cancel'),
                                  )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
