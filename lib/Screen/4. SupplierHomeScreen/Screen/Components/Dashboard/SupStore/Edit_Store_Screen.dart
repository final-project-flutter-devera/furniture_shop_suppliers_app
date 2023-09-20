import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/AppBarButton.dart';
import 'package:furniture_shop/Widgets/AppBarTitle.dart';
import 'package:furniture_shop/Widgets/MyMessageHandler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  final dynamic data;

  const EditStore({super.key, required this.data});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final ImagePicker _picker = ImagePicker();
  XFile? _logoFile;
  XFile? _coverImageFile;
  dynamic _pickedLogoError;
  dynamic _pickedCoverImageError;

  late String storeName;
  late String storePhone;
  late String storeAddress;
  late String storeLogo;
  late String storeCoverImage;

  bool processing = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _logoFile = pickedStoreLogo!;
      });
    } catch (e) {
      setState(() {
        _pickedLogoError = e;
      });
      print(_pickedLogoError);
    }
  }

  pickStoreCoverImage() async {
    try {
      final pickedStoreCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _coverImageFile = pickedStoreCoverImage!;
      });
    } catch (e) {
      setState(() {
        _pickedCoverImageError = e;
      });
      print(_pickedCoverImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (_logoFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supplier-Images/${widget.data['email']}.jpg');
        await ref.putFile(File(_logoFile!.path));
        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storeLogo'];
    }
  }

  Future uploadStoreCoverImage() async {
    if (_coverImageFile != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supplier-Images/${widget.data['email']}-cover.jpg');
        await ref2.putFile(File(_logoFile!.path));
        storeCoverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeCoverImage = widget.data['storeCoverImage'];
    }
  }

  Future editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storeName': storeName,
        'phone': storePhone,
        'storeCoverImage': storeCoverImage,
        'storeLogo': storeLogo,
        'address': storeAddress,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        processing = true;
      });
      _formKey.currentState!.save();
      await uploadStoreLogo().whenComplete(
        () async => uploadStoreCoverImage().whenComplete(
          () async =>
              editStoreData().whenComplete(() async => Navigator.pop(context)),
        ),
      );
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    var wMQ = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          leading: const AppBarBackButtonPop(),
          title: const AppBarTitle(
            label: 'Edit Store',
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Store Logo',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: wMQ,
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.black,
                              radius: 60,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    NetworkImage(widget.data['storeLogo']),
                                backgroundColor: AppColor.white,
                              ),
                            ),
                            Text(
                              'OLD',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                onPressed: () {
                                  pickStoreLogo();
                                },
                                color: AppColor.amber,
                                height: 40,
                                minWidth: wMQ * 0.2,
                                child: Text(
                                  'Change to',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            _logoFile == null
                                ? const SizedBox()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _logoFile = null;
                                        });
                                      },
                                      color: AppColor.red,
                                      height: 40,
                                      minWidth: wMQ * 0.2,
                                      child: Text(
                                        'Reset',
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.black,
                              radius: 60,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: _logoFile != null
                                    ? FileImage(File(_logoFile!.path))
                                    : null,
                                backgroundColor: AppColor.white,
                              ),
                            ),
                            Text(
                              'NEW',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: AppColor.black,
                ),
                Text(
                  'Store Cover Image',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: wMQ,
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.black,
                              radius: 60,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    NetworkImage(widget.data['storeCoverImage']),
                                backgroundColor: AppColor.white,
                              ),
                            ),
                            Text(
                              'OLD',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                onPressed: () {
                                  pickStoreCoverImage();
                                },
                                color: AppColor.amber,
                                height: 40,
                                minWidth: wMQ * 0.2,
                                child: Text(
                                  'Change to',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            _coverImageFile == null
                                ? const SizedBox()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          _coverImageFile = null;
                                        });
                                      },
                                      color: AppColor.red,
                                      height: 40,
                                      minWidth: wMQ * 0.2,
                                      child: Text(
                                        'Reset',
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.black,
                              radius: 60,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: _coverImageFile != null
                                    ? FileImage(File(_coverImageFile!.path))
                                    : null,
                                backgroundColor: AppColor.white,
                              ),
                            ),
                            Text(
                              'NEW',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: AppColor.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your store\'s name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storeName = value!;
                    },
                    initialValue: widget.data['name'],
                    decoration: decorTextForm.copyWith(
                        labelText: 'Store name',
                        hintText: 'Enter your Store name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your store\'s phone';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storePhone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: decorTextForm.copyWith(
                        labelText: 'Phone', hintText: 'Enter your Phone'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your store\'s address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storeAddress = value!;
                    },
                    initialValue: widget.data['address'],
                    decoration: decorTextForm.copyWith(
                        labelText: 'Address', hintText: 'Enter your Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        height: 50,
                        minWidth: wMQ * 0.3,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: AppColor.red,
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColor.white),
                        ),
                      ),
                      processing == true
                          ? MaterialButton(
                              minWidth: wMQ * 0.3,
                              height: 50,
                              onPressed: () {
                                null;
                              },
                              color: AppColor.black,
                              child: const Center(child: CircularProgressIndicator()))
                          : MaterialButton(
                              minWidth: wMQ * 0.3,
                              height: 50,
                              onPressed: () {
                                saveChanges();
                              },
                              color: AppColor.black,
                              child: Text(
                                'Save changes',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColor.white),
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
    );
  }
}

var decorTextForm = InputDecoration(
  labelText: 'Price',
  hintText: 'Set price ...\$',
  labelStyle: GoogleFonts.nunito(color: AppColor.black),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColor.black,
      width: 1,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColor.black,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColor.black,
      width: 3,
    ),
  ),
);
