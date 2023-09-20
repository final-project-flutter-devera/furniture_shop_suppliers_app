import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Widgets/action_button.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSuccess extends StatelessWidget {
  //TODO: Pass order link here so that button can navigate to order page
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Text(
              'SUCCESS!',
              style: GoogleFonts.merriweather(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            //Success Icon
            SizedBox(
              height: MediaQuery.of(context).size.width - 60,
              child: const Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  //Background
                  Positioned(
                    top: 10,
                    left: 10,
                    bottom: 5,
                    right: 10,
                    child: Image(
                      image: AssetImage(
                          'assets/Images/Images/success_icon_background.png'),
                    ),
                  ),
                  //Furniture icon
                  Positioned(
                    top: 50,
                    left: 50,
                    bottom: 45,
                    right: 50,
                    child: Image(
                      image:
                          AssetImage('assets/Images/Images/success_icon.png'),
                    ),
                  ),
                  //Check mark
                  Positioned(
                      bottom: 1,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check_rounded,
                          color: AppColor.white,
                          size: 40,
                        ),
                      ))
                ],
              ),
            ),
            const Spacer(),
            //Success message
            Text(
                "Your order will be delivered soon.\nThank you for choosing our app!",
                style: GoogleFonts.nunitoSans(
                    fontSize: 18, color: AppColor.black3)),
            const Spacer(),
            //Buttons
            ActionButton(
                boxShadow: const [],
                content: Text(
                  "Track your orders",
                  style: AppStyle.text_style_on_black_button,
                ),
                size: const Size(double.infinity, 60),
                color: AppColor.black,
                onPressed: () {}),
            const Padding(padding: EdgeInsets.only(top: 25)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: AppColor.black)),
              child: ActionButton(
                  boxShadow: const [],
                  content: Text(
                    "BACK TO HOME",
                    style: AppStyle.text_style_on_white_button,
                  ),
                  size: const Size(double.infinity, 60),
                  color: AppColor.white,
                  onPressed: () {}),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
