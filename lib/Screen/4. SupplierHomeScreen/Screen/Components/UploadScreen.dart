import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/CheckValidation.dart';
import 'package:furniture_shop/Widgets/MyMessageHandler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../List/ListCategory.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  late String proID;
  int? discount = 0;
  String mainValue = 'Select Main Category';
  String subValue = 'Select Sub Category';
  List<String> subCategory = [];
  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? imagesFileList = [];
  List<String> imagesUrlList = [];
  dynamic _pickedImageError;

  void pickProductImage() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 1000, maxWidth: 1000, imageQuality: 100);
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImage() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return const Center(child: Text('Please picked images yet! '));
    }
  }

  Future<void> uploadImages() async {
    if (mainValue != 'Select Main Category' &&
        subValue != 'Select Sub Category') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imagesFileList!.isNotEmpty) {
          setState(() {
            processing = true;
          });
          try {
            for (var images in imagesFileList!) {
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(images.path)}');
              await ref.putFile(File(images.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  imagesUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(_scaffoldKey, 'Please picked images');
        }
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please select categories');
    }
  }

  void uploadData() async {
    if (imagesUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');
      proID = const Uuid().v4();
      await productRef.doc(proID).set({
        'proID': proID,
        'mainCategory': mainValue,
        'subCategory': subValue,
        'price': price ,
        'inStock': quantity,
        'proName': proName,
        'prodesc': proDesc,
        'sid': FirebaseAuth.instance.currentUser!.uid,
        'proImages': imagesUrlList,
        'discount': discount,
      }).whenComplete(() {
        setState(() {
          processing = false;
          imagesUrlList = [];
          imagesFileList = [];
          mainValue = 'Select Main Category';
          subCategory = [];
        });
      });

      _formKey.currentState!.reset();
    } else {
      print('No images');
    }
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(() => uploadData());
  }

  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: wMQ * 0.5,
                        width: wMQ * 0.5,
                        color: AppColor.grey,
                        child: imagesFileList != null
                            ? previewImage()
                            : const Center(
                                child: Text('Please picked images yet! '),
                              ),
                      ),
                      SizedBox(
                        height: wMQ * 0.5,
                        width: wMQ * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' * Select main category',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.red,
                              ),
                            ),
                            DropdownButton2(
                              dropdownStyleData: DropdownStyleData(
                                width: wMQ * 0.4,
                                useSafeArea: true,
                              ),
                              value: mainValue,
                              items: categoryMain
                                  .map<DropdownMenuItem<Object>>((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                mainValue = value!.toString();
                                subValue = 'Select Sub Category';
                                setState(() {
                                  if (mainValue == 'Chair') {
                                    subCategory = categoryChair;
                                  } else if (mainValue == 'Table') {
                                    subCategory = categoryTable;
                                  } else if (mainValue == 'Armchair') {
                                    subCategory = categoryArmchair;
                                  } else if (mainValue == 'Bed') {
                                    subCategory = categoryBed;
                                  } else if (mainValue == 'Lamp') {
                                    subCategory = categoryLamp;
                                  } else if (mainValue ==
                                      'Select Main Category') {
                                    setState(() {
                                      subCategory = [];
                                    });
                                  }
                                  print(mainValue);
                                });
                              },
                            ),
                            Text(
                              ' * Select sub category',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.red,
                              ),
                            ),
                            DropdownButton2(
                              dropdownStyleData: DropdownStyleData(
                                width: wMQ * 0.4,
                                useSafeArea: true,
                              ),
                              value: subValue,
                              items: subCategory
                                  .map<DropdownMenuItem<Object>>((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  subValue = value!.toString();
                                  print(subValue);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: AppColor.black,
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: wMQ * 0.45,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter price';
                              } else if(value.isValidPrice() != true){
                                return 'invalid Price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: decorTextForm.copyWith(
                              labelText: 'Price',
                              hintText: 'Set price ...\$',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: wMQ * 0.45,
                          child: TextFormField(
                            maxLength: 2,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              }else if(value.isValidDiscount() != true){
                                return 'invalid Discount';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              discount = int.parse(value!);
                            },
                            initialValue: discount.toString(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: decorTextForm.copyWith(
                              labelText: 'Discount',
                              hintText: 'Set discount ...%',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: wMQ * 0.45,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter quantity';
                          } else if(value.isValidQuantity() != true){
                            return 'invalid Quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        decoration: decorTextForm.copyWith(
                          labelText: 'Quantity',
                          hintText: 'Set quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: wMQ,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          proName = value!;
                        },
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        maxLength: 100,
                        decoration: decorTextForm.copyWith(
                          labelText: 'Product name',
                          hintText: 'Set product name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: wMQ,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter product description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          proDesc = value!;
                        },
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        maxLength: 700,
                        decoration: decorTextForm.copyWith(
                          labelText: 'Product description',
                          hintText: 'Set product description',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: AppColor.amber,
              onPressed: imagesFileList!.isEmpty
                  ? () {
                      pickProductImage();
                    }
                  : () {
                      setState(() {
                        imagesFileList = [];
                      });
                    },
              child: imagesFileList!.isEmpty
                  ? const Icon(
                      Icons.photo_library,
                      color: AppColor.black,
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      color: AppColor.black,
                    ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              backgroundColor: AppColor.amber,
              onPressed: processing == true
                  ? null
                  : () {
                      uploadProduct();
                    },
              child: processing == true
                  ? const CircularProgressIndicator(
                      color: AppColor.black,
                    )
                  : const Icon(
                      Icons.upload,
                      color: AppColor.black,
                    ),
            ),
          ],
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
      color: AppColor.amber,
      width: 1,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColor.grey,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColor.amber,
      width: 2,
    ),
  ),
);

