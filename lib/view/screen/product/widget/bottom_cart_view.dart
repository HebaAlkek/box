import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_bootom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BottomCartView extends StatelessWidget {
  final Product product;
  final bool guest;
  final String type;

  BottomCartView(
      {@required this.product, @required this.guest, @required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[
                  Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
              blurRadius: 15,
              spreadRadius: 1)
        ],
      ),
      child: Row(children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Stack(children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CartScreen()));
                    },
                    child: Image.asset(Images.cart_arrow_down_image,
                        color: Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])))),
                Positioned(
                  top: 0,
                  right: 15,
                  child:
                      Consumer<CartProvider>(builder: (context, cart, child) {
                    return Container(
                      height: 17,
                      width: 17,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,     boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                          Provider.of<SplashProvider>(context, listen: false)
                              .configModel
                              .border_color
                              .split('#')[1])), spreadRadius: 1, blurRadius: 1)],
                        color: ColorResources.getPrimary(context),
                      ),
                      child: Text(
                        cart.cartList.length.toString(),
                        style: titilliumSemiBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            color:   Color(int.parse('0xFF' +
                                Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    .font_color
                                    .split('#')[1])) ),
                      ),
                    );
                  }),
                )
              ]),
            )),
        guest == true
            ? Expanded(
                flex: 11,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => CartBottomSheet(
                              product: product,
                              callback: () {
                                showCustomSnackBar(
                                    getTranslated('added_to_cart', context),
                                    context,
                                    isError: false);
                              },
                            ));
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),     boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                        Provider.of<SplashProvider>(context, listen: false)
                            .configModel
                            .border_color
                            .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                      color: ColorResources.getPrimary(context),
                    ),
                    child: Text(
                      getTranslated('add_to_cart', context),
                      style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color:  Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .font_color
                                  .split('#')[1])) ),
                    ),
                  ),
                ))
            : type == 'seller account'
                ? Expanded(
                    flex: 6,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (con) => CartBottomSheet(
                                  product: product,
                                  callback: () {
                                    showCustomSnackBar(
                                        getTranslated('added_to_cart', context),
                                        context,
                                        isError: false);
                                  },
                                ));
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(     boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .border_color
                                .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                          borderRadius: BorderRadius.circular(10),
                          color: ColorResources.getPrimary(context),
                        ),
                        child: Text(
                          getTranslated('add_to_cart', context),
                          style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color:   Color(int.parse('0xFF' +
                                  Provider.of<SplashProvider>(context, listen: false)
                                      .configModel
                                      .font_color
                                      .split('#')[1])) ),
                        ),
                      ),
                    ))
                : Expanded(
                    flex: 11,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (con) => CartBottomSheet(
                                  product: product,
                                  callback: () {
                                    showCustomSnackBar(
                                        getTranslated('added_to_cart', context),
                                        context,
                                        isError: false);
                                  },
                                ));
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(     boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .border_color
                                .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                          borderRadius: BorderRadius.circular(10),
                          color: ColorResources.getPrimary(context),
                        ),
                        child: Text(
                          getTranslated('add_to_cart', context),
                          style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color:   Color(int.parse('0xFF' +
                                  Provider.of<SplashProvider>(context, listen: false)
                                      .configModel
                                      .font_color
                                      .split('#')[1])) ),
                        ),
                      ),
                    )),
        guest == true?Visibility(child: Text(''),visible: false,):
        type == 'seller account'
            ?
        Provider.of<ProductProvider>(context, listen: true).headerList.length>0?

        Expanded(
            flex: 6,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => TableBottomSheet());
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(     boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .border_color
                        .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.getPrimary(context),
                ),
                child: Text(
                  getTranslated('amount', context),
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      color:   Color(int.parse('0xFF' +
                          Provider.of<SplashProvider>(context, listen: false)
                              .configModel
                              .font_color
                              .split('#')[1])) ),
                ),
              ),
            )):
        Expanded(
            flex: 6,
            child: InkWell(
              onTap: () {
               
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(     boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .border_color
                        .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: Text(
                  getTranslated('amount', context),
                  style: titilliumSemiBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      color:  Color(int.parse('0xFF' +
                          Provider.of<SplashProvider>(context, listen: false)
                              .configModel
                              .font_color
                              .split('#')[1])) ),
                ),
              ),
            )):

        Visibility(child: Text(''),visible: false,),
      ]),
    );
  }
}
