import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_shop/Providers/Auth_response.dart';
import 'package:furniture_shop/Widgets/CheckValidation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/Colors.dart';
import '../../Widgets/MyMessageHandler.dart';
import 'Forgot_Pass.dart';

class LoginSupplier extends StatefulWidget {
  const LoginSupplier({super.key});

  @override
  State<LoginSupplier> createState() => _LoginSupplierState();
}

class _LoginSupplierState extends State<LoginSupplier> {
  bool visiblePassword = false;
  late String email;
  late String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool processing = false;
  bool resendVerification = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  void signIn() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          processing = true;
        });
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.reloadUser();
        var user = AuthRepo.uid;
        final SharedPreferences prefs = await _prefs;
        prefs.setString('supplierID', user);

        await FirebaseFirestore.instance
            .collection('Suppliers')
            .doc(user)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            if (snapshot.get('role') == "supplier") {
              Navigator.pushReplacementNamed(context, '/Supplier_screen');
            }
          } else {
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'Please register account');
          }
        });
        // if (await AuthRepo.checkVerifiedMail()) {
        //   final SharedPreferences prefs = await _prefs;
        //   prefs.setString('supplierID', user);

        //   await FirebaseFirestore.instance
        //       .collection('Suppliers')
        //       .doc(user)
        //       .get()
        //       .then((DocumentSnapshot snapshot) {
        //     if (snapshot.exists) {
        //       if (snapshot.get('role') == "supplier") {
        //         Navigator.pushReplacementNamed(context, '/Supplier_screen');
        //       }
        //     } else {
        //       MyMessageHandler.showSnackBar(
        //           _scaffoldKey, 'Please register account');
        //     }
        //   });
        // } else {
        //   MyMessageHandler.showSnackBar(
        //       _scaffoldKey, 'Please check inbox & verify mail');
        //   setState(() {
        //     processing = false;
        //     resendVerification = true;
        //   });
        // }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
      }
      _formKey.currentState!.reset();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'Your email provided not found',
        );
        setState(() {
          processing = false;
        });
      } else if (e.code == 'wrong-password') {
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'Your password provided is wrong',
        );
        setState(() {
          processing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                color: Colors.black,
                                height: 1,
                                width: wMQ * 0.25),
                            SvgPicture.asset(
                              'assets/Images/Icons/SofaLogin.svg',
                              height: 100,
                              width: 100,
                            ),
                            Container(
                                color: Colors.black,
                                height: 1,
                                width: wMQ * 0.25),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'HELLO !\n',
                            style: GoogleFonts.merriweather(
                              color: const Color(0xFF909090),
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          TextSpan(
                            text: 'MY CUTE SUPPLIER',
                            style: GoogleFonts.merriweather(
                              color: const Color(0xFF303030),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.88,
                              letterSpacing: 1.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PhysicalModel(
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'please enter your email',
                                        );
                                        return 'please enter your email';
                                      } else if (value.isValidEmail() ==
                                          false) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'invalid email',
                                        );
                                        return 'invalid email';
                                      } else if (value.isValidEmail() == true) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF909090),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                    obscureText: !visiblePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF909090),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            visiblePassword = !visiblePassword;
                                          });
                                        },
                                        icon: Icon(visiblePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minHeight: 10),
                              child: resendVerification == true
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: MaterialButton(
                                        color: AppColor.amber,
                                        onPressed: () async {
                                          try {
                                            await FirebaseAuth
                                                .instance.currentUser!
                                                .sendEmailVerification();
                                            Future.delayed(
                                                    const Duration(seconds: 3))
                                                .whenComplete(() {
                                              setState(() {
                                                resendVerification = false;
                                              });
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Text(
                                          'Resend verification mail (click)',
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              color: AppColor.black),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPass()));
                                },
                                child: Text(
                                  'Forgot Password? (click)',
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF303030),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: GestureDetector(
                                onTap: signIn,
                                child: Container(
                                  height: 50,
                                  width: wMQ * 0.65,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: processing == true
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            'Log in',
                                            style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/Signup_sup');
                                },
                                child: Text(
                                  'Become a supplier'.toUpperCase(),
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF303030),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
