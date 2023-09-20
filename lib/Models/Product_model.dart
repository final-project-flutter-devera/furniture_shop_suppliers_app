import 'package:flutter/material.dart';
import 'package:furniture_shop/Providers/Auth_response.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/Colors.dart';
import '../Screen/4. SupplierHomeScreen/Screen/Components/Dashboard/SupStore/Edit_Product_Screen.dart';
import '../Screen/5. Product/Products_Detail_Screen.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;

  const ProductModel({super.key, required this.products});

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(
                      proList: widget.products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 225,
                      width: 185,
                      child: Image(
                        image: NetworkImage(
                          widget.products['proImages'][0],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    widget.products['proName'],
                    style: GoogleFonts.nunito(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 20,
                          ),
                          Row(
                            children: [
                              onSale != 0
                                  ? Text(
                                ((1 - (onSale / 100)) *
                                    widget.products['price'])
                                    .toString(),
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                                  : const Text(''),
                              const SizedBox(width: 5),
                              Text(
                                widget.products['price'].toStringAsFixed(2),
                                style: onSale != 0
                                    ? GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: AppColor.red,
                                  decoration: TextDecoration.lineThrough,
                                )
                                    : GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      AuthRepo.uid == widget.products['sid'] ?
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  EditProduct(items: widget.products,)));
                        },
                        child: const Icon(Icons.edit),
                      ):  const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
              top: 17,
              child: Container(
                height: 25,
                width: 90,
                decoration: const BoxDecoration(
                  color: AppColor.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Save ${onSale.toString()}%',
                    style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColor.white),
                  ),
                ),
              ),
            )
                : Container(color: Colors.transparent)
          ],
        ),
      ),
    );
  }
}
