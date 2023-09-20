import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Timer? countDownTimer;
  int seconds = 5;
  late int selectedIndex;
  late String imageIndex;
  List<String> imageList = [
    'assets/Images/Images/Boarding/boarding.png',
    'assets/Images/Images/Boarding/boarding1.jpg',
    'assets/Images/Images/Boarding/boarding2.jpg',
    'assets/Images/Images/Boarding/boarding3.jpg',
    'assets/Images/Images/Boarding/boarding4.jpg',
    'assets/Images/Images/Boarding/boarding5.jpg',
  ];

  String supplierID = '';

  @override
  void initState() {
    selectRandomImageBoarding();
    startTimer();

    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('supplierID') ?? '';
    }).then((String value) {
      setState(() {
        supplierID = value;
      });
      print(supplierID);
    });

    super.initState();
  }

  void selectRandomImageBoarding() {
    for (var i = 0; i < imageList.length; i++) {
      var random = Random();
      setState(() {
        selectedIndex = random.nextInt(imageList.length);
        imageIndex = imageList[selectedIndex].toString();
      });
    }
    print('index $selectedIndex');
  }

  void startTimer() {
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        if (context.mounted) {
          supplierID != ''
              ? Navigator.pushReplacementNamed(context, '/Supplier_screen')
              : Navigator.pushReplacementNamed(context, '/Login_sup');
        }
      }
      // print(timer.tick);
      // print(seconds);
    });
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;
    double hMQ = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: wMQ,
        height: hMQ,
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.centerRight,
                image: AssetImage(imageIndex),
                fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Stack(
            children: [
              Positioned(
                left: wMQ * 0.1,
                top: hMQ * 0.28,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(context.localize('boarding_title_1'),
                            style: GoogleFonts.gelasio(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                // color: AppColor.white,
                                color: const Color(0xFF606060),
                                letterSpacing: 1.2)),
                      ],
                    )),
              ),
              Positioned(
                left: wMQ * 0.1,
                top: hMQ * 0.35,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.localize('boarding_title_2'),
                    style: GoogleFonts.gelasio(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      // color: AppColor.white
                      color: const Color(0xFF303030),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: wMQ * 0.2,
                top: hMQ * 0.45,
                child: Container(
                  height: 105,
                  width: 286,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.localize('boarding_description'),
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      // color: AppColor.white
                      color: const Color(0xFF808080),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Positioned(
                top: hMQ * 0.8,
                left: wMQ * 0.3,
                child: GestureDetector(
                  onTap: () async {
                    stopTimer();
                    if (context.mounted) {
                      supplierID != ''
                          ? Navigator.pushReplacementNamed(context, '/Supplier_screen')
                          : Navigator.pushReplacementNamed(context, '/Login_sup');
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    width: 159,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 54,
                          width: 159,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF232323),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            shadows: const [
                              BoxShadow(
                                  color: Color(0x4C303030),
                                  blurRadius: 30,
                                  offset: Offset(0, 8),
                                  spreadRadius: 0)
                            ],
                          ),
                        ),
                        Center(
                          child: seconds < 1
                              ? Text(context.localize('label_get_started'),
                                  style: GoogleFonts.gelasio(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white))
                              : Text(
                                  '${context.localize('label_get_started')} | $seconds',
                                  style: GoogleFonts.gelasio(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
