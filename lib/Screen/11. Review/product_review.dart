import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Screen/11.%20Review/Components/customer_review_card.dart';
import 'package:furniture_shop/Screen/11.%20Review/Components/product_review_information.dart';

class ProductReview extends StatelessWidget {
  const ProductReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
          ),
          title: const Text('Rating & Review'),
          titleTextStyle: AppStyle.app_bar_title_text_style,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColor.black,
          shadowColor: Colors.transparent,
        ),
        //TODO: Change to SliverListView
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SafeArea(
            child: Column(
              children: [
                const ProductReviewInformation(),
                const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Divider(
                    thickness: 1,
                    color: AppColor.blur_grey,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: CustomerReviewCard(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
