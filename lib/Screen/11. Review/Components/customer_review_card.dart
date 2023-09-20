import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Widgets/star_ratings.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerReviewCard extends StatelessWidget {
  //TODO: Pass review information
  const CustomerReviewCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        margin: const EdgeInsets.only(top: 20),
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
        decoration: AppStyle.white_container_decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Reviewer name",
                  style: GoogleFonts.nunitoSans(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  "Review date",
                  style: AppStyle.date_text_style,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: StarRatings(ratings: 4),
            ),
            Text(
              'Nice Furniture with good delivery. The delivery time is very fast. Then products look like exactly the picture in the app. Besides, color is also the same and quality is very good despite very cheap price',
              style: GoogleFonts.nunitoSans(
                color: AppColor.primary,
                fontSize: 14,
              ),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.fade,
            )
          ],
        ),
      ),
      const CircleAvatar(
        backgroundColor: Colors.green,
        radius: 20,
      ),
    ]);
  }
}
