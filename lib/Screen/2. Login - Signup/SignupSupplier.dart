import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_shop/Providers/Auth_reponse.dart';
import 'package:furniture_shop/Widgets/CheckValidation.dart';
import 'package:furniture_shop/Widgets/MyMessageHandler.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/TextLoginWidget.dart';

class SignupSupplier extends StatefulWidget {
  const SignupSupplier({super.key});

  @override
  State<SignupSupplier> createState() => _SignupSupplierState();
}

class _SignupSupplierState extends State<SignupSupplier> {
  late String name;
  late String email;
  late String password;
  late String repass;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool strongPass = false;
  bool visiblePassword = false;
  final TextEditingController _pwController = TextEditingController();
  CollectionReference suppliers = FirebaseFirestore.instance.collection('Suppliers');
  CollectionReference checkUID = FirebaseFirestore.instance.collection('UID');

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      if (password == repass) {
        setState(() {
          processing = true;
        });
        try {
          await AuthRepo.signUpWithEmailAndPassword(email, password)
              .whenComplete(() => AuthRepo.updateDisplayName(name))
              .whenComplete(() => AuthRepo.sendVerificationEmail());
          _uid = AuthRepo.uid;

          await suppliers.doc(_uid).set({
            'name': name,
            'email': email,
            'phone': '',
            'address': '',
            'profileimage': '',
            'storeLogo': '',
            'storeCoverImage': '',
            'storeName': '',
            'sid': _uid,
            'role': 'supplier'
          });
          await checkUID.doc(email).set({'uid': AuthRepo.uid});
          _formKey.currentState!.reset();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/Login_sup');
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            MyMessageHandler.showSnackBar(_scaffoldKey,
                'The password provided is too week \n (at least 6 words)');
            setState(() {
              processing = false;
            });
          } else if (e.code == 'email-already-in-use') {
           /* MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exists for that email.');*/
            await FirebaseFirestore.instance
                .collection('Suppliers')
                .doc(AuthRepo.uid)
                .get()
                .then((DocumentSnapshot snapshot) async {
              if (snapshot.exists) {
                if (snapshot.get('role') == "supplier") {
                  await AuthRepo.signInWithEmailAndPassword(email, password);
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                        context, '/Supplier_screen');
                  }
                }
              } else {
                var uID = await FirebaseFirestore.instance
                    .collection('UID')
                    .doc(email)
                    .get();
                await suppliers.doc(uID['uid']).set({
                  'name': name,
                  'email': email,
                  'phone': '',
                  'address': '',
                  'profileimage': '',
                  'role': 'supplier',
                  'cid': uID['uid'],
                });
                _formKey.currentState!.reset();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/Login_sup');
                }
              }
            });
          }
        }
      } else {
        MyMessageHandler.showSnackBar(
          _scaffoldKey,
          'Please fill re-confirm password match password',
        );
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
                  const TextLoginSignup(
                    label: 'Hello!\n',
                    label2: 'Let\'s Sign up',
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
                                          'Please enter your name',
                                        );
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
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
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'Please enter your email',
                                        );
                                      } else if (value.isValidEmail() ==
                                          false) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'invalid email',
                                        );
                                      } else if (value.isValidEmail() == true) {
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    textCapitalization:
                                        TextCapitalization.characters,
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
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'Please enter your password',
                                        );
                                      }
                                      return null;
                                    },
                                    obscureText: !visiblePassword,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF909090),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(visiblePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              visiblePassword =
                                                  !visiblePassword;
                                            });
                                          },
                                        )),
                                  ),
                                  FlutterPwValidator(
                                      width: MediaQuery.of(context).size.width,
                                      height: 90,
                                      minLength: 6,
                                      uppercaseCharCount: 1,
                                      specialCharCount: 1,
                                      onSuccess: () {
                                        print('Match');
                                        setState(() {
                                          strongPass = true;
                                        });
                                      },
                                      onFail: () {
                                        setState(() {
                                          strongPass = false;
                                        });
                                      },
                                      controller: _pwController),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        MyMessageHandler.showSnackBar(
                                          _scaffoldKey,
                                          'Please enter your re - password',
                                        );
                                      }
                                      if (password != repass) {
                                        MyMessageHandler.showSnackBar(
                                            _scaffoldKey,
                                            'Re-confirm pass does not match');
                                      }
                                      return null;
                                    },
                                    obscureText: !visiblePassword,
                                    onChanged: (value) {
                                      repass = value;
                                    },
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                        labelText: 'Re - Confirm Password',
                                        labelStyle: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF909090),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(visiblePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              visiblePassword =
                                                  !visiblePassword;
                                            });
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: processing == true
                                  ? const CircularProgressIndicator()
                                  : GestureDetector(
                                      onTap: () {
                                        signUp();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: wMQ * 0.65,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Sign up',
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
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have account?',
                                    style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/Login_sup');
                                    },
                                    child: Text(
                                      'SIGN IN',
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF303030),
                                      ),
                                    ),
                                  ),
                                ],
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
