import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:furniture_shop/Constants/style.dart';
import 'package:furniture_shop/Objects/address.dart';
import 'package:furniture_shop/Objects/customer.dart';
import 'package:furniture_shop/Objects/supplier.dart';
import 'package:furniture_shop/Providers/customer_provider.dart';
import 'package:furniture_shop/Providers/supplier_provider.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/my_store_address/components/my_store_address_card.dart';
import 'package:furniture_shop/Screen/16.%20ProfileRoutes/my_store_address/add_store_address.dart';
import 'package:furniture_shop/localization/app_localization.dart';
import 'package:provider/provider.dart';

class MyStoreAddress extends StatefulWidget {
  final Supplier currentCustomer;
  const MyStoreAddress({super.key, required this.currentCustomer});
  @override
  State<MyStoreAddress> createState() => _MyStoreAddressState();
}

class _MyStoreAddressState extends State<MyStoreAddress> {
  late List<Address> myAddress = [];
  bool _isLoading = false;
  @override
  void initState() {
    myAddress = widget.currentCustomer.storeAddress;
    super.initState();
  }

  _addAddress(Address address) {
    //If there is no address in address list, the new address will be the default
    address.isDefault = myAddress.isEmpty;
    myAddress.add(address);
    context
        .read<SupplierProvider>()
        .updateCurrentSupplier(storeAddress: myAddress);
    setState(() {});
  }

  _editAddress(Address address, int index) {
    setState(() {
      myAddress[index] = address;
    });
    context
        .read<SupplierProvider>()
        .updateCurrentSupplier(storeAddress: myAddress);
    setState(() {});
  }

  _getAddress() async {
    myAddress = await context
        .read<SupplierProvider>()
        .getCurrentSupplier()
        .then((value) {
      return value.storeAddress;
    });
    setState(() {
      _isLoading = false;
    });
  }

  _setAsMainAddress(int index) async {
    setState(() {
      myAddress[index].isDefault = true;
      for (int i = 0; i < myAddress.length; i++) {
        if (i != index) myAddress[i].isDefault = false;
      }
    });
    context
        .read<SupplierProvider>()
        .updateCurrentSupplier(storeAddress: myAddress);
  }

  _deleteAddress(int index) {
    setState(() {
      myAddress.removeAt(index);
    });
    context
        .read<SupplierProvider>()
        .updateCurrentSupplier(storeAddress: myAddress);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blur_grey,
        foregroundColor: AppColor.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 40,
          ),
        ),
        centerTitle: true,
        title: Text(
          context.localize('shipping_address_app_bar_title'),
          style: AppStyle.app_bar_title_text_style,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddShipingAddress(
                      onTap: _addAddress,
                    )),
          );
        },
        child: const Icon(
          Icons.add,
          size: 24,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _getAddress();
          setState(() {});
          return Future.value();
        },
        child: (_isLoading == true)
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColor.black,
              ))
            : myAddress.isEmpty
                ? Center(
                    child: Text(
                      context.localize('message_no_address'),
                      style: AppStyle.tab_title_text_style,
                    ),
                  )
                : ListView.builder(
                    itemCount: myAddress.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10),
                      child: MyStoreAddressCard(
                        index: index,
                        address: myAddress[index],
                        setAsDefaultOnTap: (value) => _setAsMainAddress(index),
                        deleteAddressOnTap: (value) => _deleteAddress(value),
                        editAddressOnTap: (Address address) =>
                            _editAddress(address, index),
                      ),
                    ),
                  ),
      ),
    );
  }
}
