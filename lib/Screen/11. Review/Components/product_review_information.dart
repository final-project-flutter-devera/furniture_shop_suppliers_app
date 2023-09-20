import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductReviewInformation extends StatelessWidget {
  //TODO: Pass product in
  const ProductReviewInformation({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            //Product Image
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/Images/Images/minimal_stand.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Product name',
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFF2C94C),
                    size: 20,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    'Rating score'.toString(),
                    style: GoogleFonts.nunitoSans(
                        fontSize: 24,
                        color: AppColor.black,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
                const Spacer(),
                Text(
                  'Number of reviews',
                  style: AppStyle.tab_title_text_style,
                ),
              ],
            ),
          ],
        ));
  }
}
