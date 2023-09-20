import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Widgets/CheckValidation.dart';
import 'package:furniture_shop/Widgets/MyMessageHandler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../List/ListCategory.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProduct extends StatefulWidget {
  final dynamic items;

  const EditProduct({super.key, required this.items});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
  List<dynamic> subCategory = [];
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

  Widget previewCurrentImage() {
    List<dynamic> itemImages = widget.items['proImages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index]);
        });
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

  Future uploadImage() async {
    if (imagesFileList!.isNotEmpty) {
      if (mainValue != 'Select Main Category' &&
          subValue != 'Select Sub Category') {
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
        MyMessageHandler.showSnackBar(_scaffoldKey, 'Please select categories');
      }
    } else {
      imagesUrlList = widget.items['proImages'];
    }
  }

  Future editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['proID']);
      transaction.update(documentReference, {
        // 'mainCategory': mainValue,
        // 'subCategory': subValue,
        'price': price,
        'inStock': quantity,
        'proName': proName,
        'prodesc': proDesc,
        'proImages': imagesUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    print(price);
    if (_formKey.currentState!.validate()) {
      await uploadImage().whenComplete(() => editProductData());
    }
  }

  @override
  Widget build(BuildContext context) {
    double wMQ = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  changeImageCategory(wMQ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: wMQ * 0.45,
                          child: TextFormField(
                            initialValue: '${widget.items['price']}',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter price';
                              } else if (value.isValidPrice() != true) {
                                return 'invalid Price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: decorTextForm.copyWith(
                              labelText: 'Price',
                              hintText: 'Set price ...\$',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: wMQ * 0.45,
                          child: TextFormField(
                            initialValue: '${widget.items['discount']}',
                            maxLength: 2,
                            onSaved: (value) {
                              discount = int.parse(value!);
                            },
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
                          } else if (value.isValidQuantity() != true) {
                            return 'invalid Quantity';
                          }
                          return null;
                        },
                        initialValue: '${widget.items['inStock']}',
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
                        initialValue: '${widget.items['proName']}',
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
                        initialValue: '${widget.items['prodesc']}',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: AppColor.red,
                            height: 41,
                            minWidth: wMQ * 0.25,
                            child: Text(
                              'cancel',
                              style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.white),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: MaterialButton(
                            onPressed: () {
                              // saveChanges();
                              MyMessageHandler.showSnackBar(_scaffoldKey, 'Feature still developing');
                            },
                            color: AppColor.black,
                            height: 41,
                            minWidth: wMQ * 0.5,
                            child: Text(
                              'Save Changes',
                              style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.white),
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
      ),
    );
  }

  Widget changeImageCategory(var wMQ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                height: wMQ * 0.5,
                width: wMQ * 0.5,
                color: AppColor.grey5,
                child: previewCurrentImage()),
            SizedBox(
              height: wMQ * 0.5,
              width: wMQ * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        ' Main category',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.red,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.all(6),
                        constraints: BoxConstraints(
                          maxWidth: wMQ * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.items['mainCategory'],
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        ' Sub category',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.red,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.all(6),
                        constraints: BoxConstraints(
                          maxWidth: wMQ * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.items['subCategory'],
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(10),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Change Images & Category',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                  ),
                  TextSpan(
                    text: ' (click)',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          collapsed: const SizedBox(),
          expanded: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: wMQ * 0.5,
                    width: wMQ * 0.5,
                    color: AppColor.grey5,
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
                              } else if (mainValue == 'Select Main Category') {
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
              imagesFileList!.isNotEmpty
                  ? MaterialButton(
                      onPressed: () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                      color: AppColor.red,
                      child: Text(
                        'Reset images',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColor.white,
                        ),
                      ),
                    )
                  : MaterialButton(
                      onPressed: () {
                        pickProductImage();
                      },
                      color: AppColor.amber,
                      child: Text(
                        'Change images',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColor.black,
                        ),
                      ),
                    ),
              const Divider(
                thickness: 2,
                color: AppColor.grey,
              ),
            ],
          ),
        ),
      ],
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
