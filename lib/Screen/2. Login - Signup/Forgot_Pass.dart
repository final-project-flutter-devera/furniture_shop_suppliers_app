import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Providers/Auth_response.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:furniture_shop/Widgets/CheckValidation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/MyMessageHandler.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          leading: const AppBarBackButtonPop(),
          title: const AppBarTitle(label: 'Resend Password'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'To reset password'.toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        MyMessageHandler.showSnackBar(
                          _scaffoldKey,
                          'Please enter your email',
                        );
                      } else if (value.isValidEmail() == false) {
                        MyMessageHandler.showSnackBar(
                          _scaffoldKey,
                          'invalid email',
                        );
                      } else if (value.isValidEmail() == true) {
                        return null;
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText:
                          'Please enter your email and click submit bellow',
                      labelStyle: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF909090),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await AuthRepo.sendEmailResetPassword(
                            emailController.text.trim());
                      } else {
                        print('form not invalid');
                      }
                    },
                    color: AppColor.amber,
                    child: const Text('Submit'),
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
