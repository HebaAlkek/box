import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductTitleView extends StatelessWidget {
  final Product productModel;

  ProductTitleView({@required this.productModel});

  bool isGuestMode;

  @override
  Widget build(BuildContext context) {
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    double _startingPrice = 0;
    double _endingPrice;
    if (productModel.variation != null && productModel.variation.length != 0) {
      List<double> _priceList = [];
      productModel.variation
          .forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      if (!isGuestMode) {
        if (Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel
                .user_role
                .toString() ==
            'business account') {
          _startingPrice = productModel.wholesale_price;
        } else {
          _startingPrice = productModel.unitPrice;
        }
      } else {
        _startingPrice = productModel.unitPrice;
      }
    }

    return productModel != null
        ? Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<ProductDetailsProvider>(
              builder: (context, details, child) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(productModel.name ?? '',
                                style: titleRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                                maxLines: 2)),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Column(
                          children: [
                            productModel.discountvalue != null &&
                                    int.parse(productModel.discountvalue) > 0
                                ? Text(
                                    '${PriceConverter.convertPrice(context, _startingPrice)}'
                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                    style: titilliumRegular.copyWith(
                                        color: Theme.of(context).hintColor,
                                        decoration: TextDecoration.lineThrough),
                                  )
                                : SizedBox(),
                            SizedBox(
                                height:
                                    Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                            Text(
                              '${_startingPrice != null ? PriceConverter.convertPrice(context, _startingPrice, discount: double.parse(productModel.discountvalue), discountType: productModel.discounttype) : ''}'
                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: double.parse(productModel.discountvalue), discountType: productModel.discounttype)}' : ''}',
                              style: titilliumBold.copyWith(
                                  color: Color(int.parse('0xFF' +
                                      Provider.of<SplashProvider>(context,
                                              listen: false)
                                          .configModel
                                          .font_color
                                          .split('#')[1])),
                                  fontSize: Dimensions.FONT_SIZE_LARGE),
                            ),
                          ],
                        ),
                      ]),

                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                      Row(children: [
                        Text(
                            '${details.reviewList != null ? details.reviewList.length : 0}  '+getTranslated('reviews', context) + ' | ',
                            style: titilliumRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            )),
                        Text('${details.orderCount} ' + getTranslated('ordersL', context) + ' | ',
                            style: titilliumRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            )),
                        Text('${details.wishCount}'+getTranslated('wish', context),
                            style: titilliumRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            )),
                        Expanded(child: SizedBox.shrink()),
                        SizedBox(width: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(
                                '${productModel.rating != null ? productModel.rating.length > 0 ? double.parse(productModel.rating[0].average) : 0.0 : 0.0}')
                          ],
                        ),
                      ]),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      // Variant

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      productModel.colors.length > 0
                          ? Row(children: [
                              Text(
                                  '${getTranslated('select_variant', context)} : ',
                                  style: titilliumRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  itemCount: productModel.colors.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    String colorString = '0xff' +
                                        productModel.colors[index].code
                                            .substring(1, 7);
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Color(int.parse(colorString)),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          //child: details.variantIndex == index ? Icon(Icons.done_all, color: ColorResources.WHITE, size: 12) : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])
                          : Provider.of<ProductProvider>(context, listen: true)
                                      .relatedProductListColor ==
                                  null
                              ? Visibility(
                                  child: Text(''),
                                  visible: false,
                                )
                              : Row(children: [
                                  SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                      itemCount: Provider.of<ProductProvider>(
                                              context,
                                              listen: false)
                                          .colorList
                                          .length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        String colorString = '0xff' +
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .colorList[index]
                                                .substring(1, 7);
                                        return InkWell(
                                          onTap: () {
                                            Provider.of<ProductProvider>(
                                                    context,
                                                    listen: false)
                                                .setSizeList(context, index);

                                            if (Provider.of<ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .sizeListSelect
                                                    .length ==
                                                1) {
                                              for (int o = 0;
                                                  o <
                                                      Provider.of<ProductProvider>(
                                                              context,
                                                              listen: false)
                                                          .relatedProductListColor
                                                          .length;
                                                  o++) {
                                                if (Provider.of<ProductProvider>(
                                                            context,
                                                            listen: false)
                                                        .relatedProductListColor[
                                                            o]
                                                        .id
                                                        .toString() ==
                                                    Provider.of<ProductProvider>(
                                                            context,
                                                            listen: false)
                                                        .sizeListSelect[0]
                                                        .id
                                                        .toString()) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        pageBuilder: (context,
                                                                anim1, anim2) =>
                                                            ProductDetails(
                                                                product: Provider.of<
                                                                            ProductProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .relatedProductListColor[o]),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          true).then((value) {
                                                    print('delayed execution');
                                                  });
                                                  Provider.of<ProductProvider>(
                                                          context,
                                                          listen: false)
                                                      .sizeListSelect
                                                      .clear();
                                                  Provider.of<ProductProvider>(
                                                          context,
                                                          listen: false)
                                                      .sizeList
                                                      .clear();
                                                  Provider.of<ProductProvider>(
                                                          context,
                                                          listen: false)
                                                      .sizeItem = null;
                                                }
                                              }
                                            } else {
                                              for (int o = 0;
                                                  o <
                                                      Provider.of<ProductProvider>(
                                                              context,
                                                              listen: false)
                                                          .relatedProductListColor
                                                          .length;
                                                  o++) {
                                                for (int r = 0;
                                                    r <
                                                        Provider.of<ProductProvider>(
                                                                context,
                                                                listen: false)
                                                            .sizeListSelect
                                                            .length;
                                                    r++) {
                                                  if (Provider.of<ProductProvider>(
                                                              context,
                                                              listen: false)
                                                          .relatedProductListColor[
                                                              o]
                                                          .id
                                                          .toString() ==
                                                      Provider.of<ProductProvider>(
                                                              context,
                                                              listen: false)
                                                          .sizeListSelect[r]
                                                          .id
                                                          .toString()) {
                                                    Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pageBuilder: (context,
                                                                  anim1,
                                                                  anim2) =>
                                                              ProductDetails(
                                                                  product: Provider.of<
                                                                              ProductProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .relatedProductListColor[o]),
                                                        )).then((value) {});
                                                    Provider.of<ProductProvider>(
                                                            context,
                                                            listen: false)
                                                        .sizeListSelect
                                                        .clear();
                                                    Provider.of<ProductProvider>(
                                                            context,
                                                            listen: false)
                                                        .sizeList
                                                        .clear();
                                                    Provider.of<ProductProvider>(
                                                            context,
                                                            listen: false)
                                                        .sizeItem = null;
                                                  }
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                padding: EdgeInsets.all(Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                      int.parse(colorString)),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                //child: details.variantIndex == index ? Icon(Icons.done_all, color: ColorResources.WHITE, size: 12) : null,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Provider.of<ProductProvider>(context, listen: true)
                                  .sizeListSelect ==
                              null
                          ? Text(getTranslated('select_size', context),
                              style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE))
                          : Visibility(
                              child: Text(''),
                              visible: false,
                            ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      productModel.colors.length > 0
                          ? Visibility(
                              child: Text(''),
                              visible: false,
                            )
                          : Provider.of<ProductProvider>(context, listen: true)
                                      .relatedProductListColor ==
                                  null
                              ? Visibility(
                                  child: Text(''),
                                  visible: false,
                                )
                              : Provider.of<ProductProvider>(context,
                                              listen: true)
                                          .colorList ==
                                      null
                                  ? Visibility(
                                      child: Text(''),
                                      visible: false,
                                    )
                                  : Provider.of<ProductProvider>(context,
                                                  listen: true)
                                              .colorList
                                              .length ==
                                          0
                                      ? Visibility(
                                          child: Text(''),
                                          visible: false,
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(int.parse('0xFF' +
                                                        Provider.of<SplashProvider>(
                                                                context,
                                                                listen: false)
                                                            .configModel
                                                            .border_color
                                                            .split('#')[1])),
                                                    spreadRadius: 1,
                                                    blurRadius: 5)
                                              ],
                                              color: Colors.white),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: DropdownButtonHideUnderline(
                                                child: DropdownButton<sizeMode>(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                              value:
                                                  Provider.of<ProductProvider>(
                                                          context,
                                                          listen: true)
                                                      .sizeItem,
                                              underline: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10, top: 10),
                                                  height: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              items:
                                                  Provider.of<ProductProvider>(
                                                          context,
                                                          listen: true)
                                                      .sizeListSelect
                                                      .map((sizeMode value) {
                                                return DropdownMenuItem<
                                                    sizeMode>(
                                                  value: value,
                                                  child: new Text(
                                                    value.size,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'NeoSansArabicLight'),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (val) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                Provider.of<ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .sizeItem = val;
                                                for (int i = 0;
                                                    i <
                                                        Provider.of<ProductProvider>(
                                                                context,
                                                                listen: false)
                                                            .relatedProductListColor
                                                            .length;
                                                    i++) {
                                                  if (Provider.of<ProductProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .relatedProductListColor[
                                                                  i]
                                                              .product_size ==
                                                          Provider.of<ProductProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .sizeItem
                                                              .size &&
                                                      Provider.of<ProductProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .relatedProductListColor[
                                                                  i]
                                                              .product_color ==
                                                          Provider.of<ProductProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .sizeItem
                                                              .color) {
                                                    Provider.of<ProductProvider>(
                                                            context,
                                                            listen: false)
                                                        .sizeItem = null;
                                                    Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          transitionDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pageBuilder: (context,
                                                                  anim1,
                                                                  anim2) =>
                                                              ProductDetails(
                                                                  product: Provider.of<
                                                                              ProductProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .relatedProductListColor[i]),
                                                        ));
                                                  }
                                                }
                                              },
                                              isExpanded: true,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              dropdownColor: Colors.white,
                                              iconEnabledColor: Colors.black,
                                              hint: Text(
                                                getTranslated(
                                                    'select_size', context),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'NeoSansArabicLight'),
                                              ),
                                            )),
                                          )),
                      productModel.colors.length > 0
                          ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                          : SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      // Variation
                      productModel.choiceOptions != null &&
                              productModel.choiceOptions.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: productModel.choiceOptions.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${getTranslated('available', context)}' +
                                              ' ' +
                                              '${productModel.choiceOptions[index].title} :',
                                          style: titilliumRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)),
                                      SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Expanded(
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: (1 / .7),
                                          ),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: productModel
                                              .choiceOptions[index]
                                              .options
                                              .length,
                                          itemBuilder: (context, i) {
                                            return Center(
                                              child: Text(
                                                  productModel
                                                      .choiceOptions[index]
                                                      .options[i],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      titilliumRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_DEFAULT,
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    ]);
                              },
                            )
                          : SizedBox(),
                    ]);
              },
            ),
          )
        : SizedBox();
  }
}
