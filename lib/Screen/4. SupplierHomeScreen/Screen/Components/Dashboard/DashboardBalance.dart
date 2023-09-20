import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceDashboard extends StatelessWidget {
  const BalanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var wMQ = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('cancelStatus', isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(body: Center(child: Text('Something went wrong')));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          num quantitySold = 0;
          for (var product in snapshot.data!.docs) {
            quantitySold += product['orderQuantity'];
          }

          double balance = 0.0;
          for (var product in snapshot.data!.docs) {
            balance += product['orderQuantity'] * product['orderPrice'];
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.white,
              leading: const AppBarBackButtonPop(),
              title: const AppBarTitle(label: 'Balance'),
              centerTitle: true,
            ),
            body: SizedBox(
              width: wMQ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnalysisMode(
                    label: 'balance',
                    value: balance,
                    decimal: 2,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                      onPressed: () {},
                      color: AppColor.green,
                      child: Text(
                        'Withdraw',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColor.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class AnalysisMode extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimal;

  const AnalysisMode(
      {super.key,
        required this.label,
        required this.value,
        required this.decimal});

  @override
  Widget build(BuildContext context) {
    var wMQ = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 30,
          width: wMQ * 0.9,
          decoration: const BoxDecoration(
            color: AppColor.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColor.white),
            ),
          ),
        ),
        Container(
            constraints: const BoxConstraints(minHeight: 70),
            width: wMQ * 0.9,
            decoration: const BoxDecoration(
              color: AppColor.grey5,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: AnimatedCounter(
              count: value,
              decimal: decimal,
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final dynamic count;
  final int decimal;

  const AnimatedCounter(
      {super.key, required this.count, required this.decimal});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
            child: Text(
              _animation.value.toStringAsFixed(widget.decimal),
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColor.red),
            ),
          );
        });
  }
}
