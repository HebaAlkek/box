import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:provider/provider.dart';

class TableBottomSheet extends StatefulWidget {
  @override
  _TableBottomSheetState createState() => _TableBottomSheetState();
}

class _TableBottomSheetState extends State<TableBottomSheet> {
  bool isGuestMode;

  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10,
            ),

            // Close Button
            Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).highlightColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[
                                Provider.of<ThemeProvider>(context).darkTheme
                                    ? 700
                                    : 200],
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ]),
                    child: Icon(Icons.clear, size: Dimensions.ICON_SIZE_SMALL),
                  ),
                )),

            SizedBox(
              height: 10,
            ),

            Center(
              child: DataTable(
                onSelectAll: (b) {},
                sortColumnIndex: 0,
                border: TableBorder.all(color: Colors.grey.withOpacity(0.3), width: 1),
                headingRowColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.3)),
                columns: Provider.of<ProductProvider>(context, listen: false)
                    .headerList,

                rows: Provider.of<ProductProvider>(context, listen: false)
                    .valuList // accessing list from Getx controller
                    .map(
                      (user) => DataRow(
                          cells: Provider.of<ProductProvider>(context,
                                  listen: false)
                              .indexxList
                              .map((val) => DataCell(Center(
                                    child: Text(
                                      user.toList()[val].toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  )))
                              .toList()),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;

  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isIncrement && quantity > 1) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity - 1);
        } else if (isIncrement && quantity < stock) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity + 1);
        }
      },
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(width: 1, color: Theme.of(context).primaryColor)),
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          color: isIncrement
              ? quantity >= stock
                  ? ColorResources.getLowGreen(context)
                  : ColorResources.getPrimary(context)
              : quantity > 1
                  ? ColorResources.getPrimary(context)
                  : ColorResources.getTextTitle(context),
          size: isCartWidget ? 26 : 20,
        ),
      ),
    );
  }
}
