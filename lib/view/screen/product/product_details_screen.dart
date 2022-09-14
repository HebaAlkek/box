import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_widget.dart';
import 'package:provider/provider.dart';

import 'faq_and_review_screen.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({
    @required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isGuestMode;

  _loadData(BuildContext context) async {
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    Provider.of<ProductProvider>(context, listen: false)
        .getQtyBranch(widget.product.slug.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.product, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false).initRelatedProductList(
        widget.product.id.toString(), context, widget.product);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.product.id.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.product.slug.toString(), context);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false)
          .checkWishList(widget.product.id.toString(), context);
    }
    Provider.of<ProductProvider>(context, listen: false)
        .initSellerProductList(widget.product.userId.toString(), 1, context);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    String ratting =
        widget.product.rating != null && widget.product.rating.length != 0
            ? widget.product.rating[0].average.toString()
            : "0";
    _loadData(context);
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    double _startingPrice = 0;
    double _endingPrice;
    if (widget.product.variation != null &&
        widget.product.variation.length != 0) {
      List<double> _priceList = [];
      widget.product.variation
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
          _startingPrice = widget.product.wholesale_price;
        } else {
          _startingPrice = widget.product.unitPrice;
        }
      } else {
        _startingPrice = widget.product.unitPrice;
      }
    }
    return Consumer<ProductDetailsProvider>(
      builder: (context, details, child) {
        return details.hasConnection
            ? WillPopScope(
                onWillPop: () {
                  Navigator.pop(context, context);
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).cardColor,
                  appBar: AppBar(
                    title: Row(children: [
                      InkWell(
                        child: Icon(Icons.arrow_back_ios,
                            color: Color(int.parse('0xFF' +
                                Provider.of<SplashProvider>(context,
                                        listen: false)
                                    .configModel
                                    .font_color
                                    .split('#')[1])),
                            size: 20),
                        onTap: () => Navigator.pop(context, context),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(getTranslated('product_details', context),
                          style: robotoRegular.copyWith(
                              fontSize: 20,
                              color: Color(int.parse('0xFF' +
                                  Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel
                                      .font_color
                                      .split('#')[1])))),
                    ]),
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor:
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? Colors.black
                            : Theme.of(context).primaryColor,
                  ),
                  bottomNavigationBar: BottomCartView(
                      product: widget.product,
                      guest: isGuestMode,
                      type: isGuestMode == true
                          ? ''
                          : Provider.of<ProfileProvider>(context, listen: false)
                              .userInfoModel
                              .user_role
                              .toString()),
                  body: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        widget.product != null
                            ? ProductImageView(productModel: widget.product)
                            : SizedBox(),
                        Container(
                          transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                          padding: EdgeInsets.only(
                              top: Dimensions.FONT_SIZE_DEFAULT),
                          decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                topRight: Radius.circular(
                                    Dimensions.PADDING_SIZE_EXTRA_LARGE)),
                          ),
                          child: Column(
                            children: [
                              //  ProductTitleView(widget.product: widget.product),
                              widget.product != null
                                  ? Container(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      child: Consumer<ProductDetailsProvider>(
                                        builder: (context, details, child) {
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  Expanded(
                                                      child: Text(
                                                          widget.product.name ??
                                                              '',
                                                          style: titleRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .FONT_SIZE_LARGE),
                                                          maxLines: 2)),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  Column(
                                                    children: [
                                                      widget.product.discountvalue !=
                                                                  null &&
                                                              int.parse(widget
                                                                      .product
                                                                      .discountvalue) >
                                                                  0
                                                          ? Text(
                                                              '${PriceConverter.convertPrice(context, _startingPrice)}'
                                                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                                              style: titilliumRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough),
                                                            )
                                                          : SizedBox(),
                                                      SizedBox(
                                                          height: Dimensions
                                                              .PADDING_SIZE_EXTRA_EXTRA_SMALL),
                                                      Text(
                                                        '${_startingPrice != null ? PriceConverter.convertPrice(context, _startingPrice, discount: double.parse(widget.product.discountvalue), discountType: widget.product.discounttype) : ''}'
                                                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: double.parse(widget.product.discountvalue), discountType: widget.product.discounttype)}' : ''}',
                                                        style: titilliumBold.copyWith(
                                                            color: Color(int.parse('0xFF' +
                                                                Provider.of<SplashProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .configModel
                                                                    .font_color
                                                                    .split(
                                                                        '#')[1])),
                                                            fontSize: Dimensions.FONT_SIZE_LARGE),
                                                      ),
                                                    ],
                                                  ),
                                                ]),

                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_DEFAULT),

                                                Row(children: [
                                                  Text(
                                                      '${details.reviewList != null ? details.reviewList.length : 0} '+getTranslated('reviews', context) + ' | ',
                                                      style: titilliumRegular
                                                          .copyWith(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                      )),
                                                  Text(
                                                      '${details.orderCount} '+ getTranslated('ordersL', context) + ' | ',
                                                      style: titilliumRegular
                                                          .copyWith(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                      )),
                                                  Text(
                                                      '${details.wishCount} '+getTranslated('wish', context),
                                                      style: titilliumRegular
                                                          .copyWith(
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                      )),
                                                  Expanded(
                                                      child: SizedBox.shrink()),
                                                  SizedBox(width: 5),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.orange,
                                                      ),
                                                      Text(
                                                          '${widget.product.rating != null ? widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0 : 0.0}')
                                                    ],
                                                  ),
                                                ]),

                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                // Variant

                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                widget.product.colors.length > 0
                                                    ? Row(children: [
                                                        Text(
                                                            '${getTranslated('select_variant', context)} : ',
                                                            style: titilliumRegular
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_LARGE)),
                                                        SizedBox(
                                                          height: 40,
                                                          child:
                                                              ListView.builder(
                                                            itemCount: widget
                                                                .product
                                                                .colors
                                                                .length,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              String colorString = '0xff' +
                                                                  widget
                                                                      .product
                                                                      .colors[
                                                                          index]
                                                                      .code
                                                                      .substring(
                                                                          1, 7);
                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimensions
                                                                              .PADDING_SIZE_EXTRA_SMALL),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .all(
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    padding: EdgeInsets.all(
                                                                        Dimensions
                                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          int.parse(
                                                                              colorString)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    //child: details.variantIndex == index ? Icon(Icons.done_all, color: ColorResources.WHITE, size: 12) : null,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ])
                                                    : Provider.of<ProductProvider>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .relatedProductListColor ==
                                                            null
                                                        ? Visibility(
                                                            child: Text(''),
                                                            visible: false,
                                                          )
                                                        : Row(children: [
                                                            SizedBox(
                                                              height: 40,
                                                              child: ListView
                                                                  .builder(
                                                                itemCount: Provider.of<
                                                                            ProductProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .colorList
                                                                    .length,
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  String colorString = '0xff' +
                                                                      Provider.of<ProductProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .colorList[
                                                                              index]
                                                                          .substring(
                                                                              1,
                                                                              7);
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      Provider.of<ProductProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setSizeList(
                                                                              context,
                                                                              index);

                                                                      if (Provider.of<ProductProvider>(context, listen: false)
                                                                              .sizeListSelect
                                                                              .length ==
                                                                          1) {
                                                                        for (int o =
                                                                                0;
                                                                            o < Provider.of<ProductProvider>(context, listen: false).relatedProductListColor.length;
                                                                            o++) {
                                                                          if (Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[o].id.toString() ==
                                                                              Provider.of<ProductProvider>(context, listen: false).sizeListSelect[0].id.toString()) {
                                                                            Navigator.pushAndRemoveUntil(
                                                                                context,
                                                                                PageRouteBuilder(
                                                                                  transitionDuration: Duration(milliseconds: 1000),
                                                                                  pageBuilder: (context, anim1, anim2) => ProductDetails(product: Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[o]),
                                                                                ),
                                                                                (Route<dynamic> route) => true).then((value) {
                                                                              print('delayed execution');
                                                                              _loadData(value);
                                                                            });
                                                                            Provider.of<ProductProvider>(context, listen: false).sizeListSelect.clear();
                                                                            Provider.of<ProductProvider>(context, listen: false).sizeList.clear();
                                                                            Provider.of<ProductProvider>(context, listen: false).sizeItem =
                                                                                null;
                                                                          }
                                                                        }
                                                                      } else {
                                                                        for (int o =
                                                                                0;
                                                                            o < Provider.of<ProductProvider>(context, listen: false).relatedProductListColor.length;
                                                                            o++) {
                                                                          for (int r = 0;
                                                                              r < Provider.of<ProductProvider>(context, listen: false).sizeListSelect.length;
                                                                              r++) {
                                                                            if (Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[o].id.toString() ==
                                                                                Provider.of<ProductProvider>(context, listen: false).sizeListSelect[r].id.toString()) {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  PageRouteBuilder(
                                                                                    transitionDuration: Duration(milliseconds: 1000),
                                                                                    pageBuilder: (context, anim1, anim2) => ProductDetails(product: Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[o]),
                                                                                  )).then((value) {});
                                                                              Provider.of<ProductProvider>(context, listen: false).sizeListSelect.clear();
                                                                              Provider.of<ProductProvider>(context, listen: false).sizeList.clear();
                                                                              Provider.of<ProductProvider>(context, listen: false).sizeItem = null;
                                                                            }
                                                                          }
                                                                        }
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              30,
                                                                          padding:
                                                                              EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color(int.parse(colorString)),
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

                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                Provider.of<ProductProvider>(
                                                                context,
                                                                listen: true)
                                                            .sizeListSelect ==
                                                        null
                                                    ? Text(
                                                        getTranslated(
                                                            'select_size',
                                                            context),
                                                        style: titilliumRegular
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .FONT_SIZE_LARGE))
                                                    : Visibility(
                                                        child: Text(''),
                                                        visible: false,
                                                      ),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                widget.product.colors.length > 0
                                                    ? Visibility(
                                                        child: Text(''),
                                                        visible: false,
                                                      )
                                                    : Provider.of<ProductProvider>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .relatedProductListColor ==
                                                            null
                                                        ? Visibility(
                                                            child: Text(''),
                                                            visible: false,
                                                          )
                                                        : Provider.of<ProductProvider>(
                                                                        context,
                                                                        listen:
                                                                            true)
                                                                    .colorList ==
                                                                null
                                                            ? Visibility(
                                                                child: Text(''),
                                                                visible: false,
                                                              )
                                                            : Provider.of<ProductProvider>(
                                                                            context,
                                                                            listen:
                                                                                true)
                                                                        .colorList
                                                                        .length ==
                                                                    0
                                                                ? Visibility(
                                                                    child: Text(
                                                                        ''),
                                                                    visible:
                                                                        false,
                                                                  )
                                                                : Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              color: Color(int.parse('0xFF' + Provider.of<SplashProvider>(context, listen: false).configModel.border_color.split('#')[1])),
                                                                              spreadRadius: 1,
                                                                              blurRadius: 5)
                                                                        ],
                                                                        color: Colors.white),
                                                                    child: Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              15,
                                                                              0,
                                                                              15,
                                                                              0),
                                                                      child: DropdownButtonHideUnderline(
                                                                          child: DropdownButton<sizeMode>(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .keyboard_arrow_down,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        value: Provider.of<ProductProvider>(context,
                                                                                listen: true)
                                                                            .sizeItem,
                                                                        underline:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 20),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 10, top: 10),
                                                                            height:
                                                                                1,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        items: Provider.of<ProductProvider>(context,
                                                                                listen: true)
                                                                            .sizeListSelect
                                                                            .map((sizeMode value) {
                                                                          return DropdownMenuItem<
                                                                              sizeMode>(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                new Text(
                                                                              value.size,
                                                                              style: TextStyle(color: Colors.black, fontFamily: 'NeoSansArabicLight'),
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (val) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(new FocusNode());
                                                                          Provider.of<ProductProvider>(context, listen: false).sizeItem =
                                                                              val;
                                                                          for (int i = 0;
                                                                              i < Provider.of<ProductProvider>(context, listen: false).relatedProductListColor.length;
                                                                              i++) {
                                                                            if (Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[i].product_size == Provider.of<ProductProvider>(context, listen: false).sizeItem.size &&
                                                                                Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[i].product_color == Provider.of<ProductProvider>(context, listen: false).sizeItem.color) {
                                                                              Provider.of<ProductProvider>(context, listen: false).sizeItem = null;
                                                                              Navigator.push(
                                                                                  context,
                                                                                  PageRouteBuilder(
                                                                                    transitionDuration: Duration(milliseconds: 1000),
                                                                                    pageBuilder: (context, anim1, anim2) => ProductDetails(product: Provider.of<ProductProvider>(context, listen: false).relatedProductListColor[i]),
                                                                                  ));
                                                                            }
                                                                          }
                                                                        },
                                                                        isExpanded:
                                                                            true,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                        dropdownColor:
                                                                            Colors.white,
                                                                        iconEnabledColor:
                                                                            Colors.black,
                                                                        hint:
                                                                            Text(
                                                                          getTranslated(
                                                                              'select_size',
                                                                              context),
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'NeoSansArabicLight'),
                                                                        ),
                                                                      )),
                                                                    )),
                                                widget.product.colors.length > 0
                                                    ? SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL)
                                                    : SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_SMALL),

                                                // Variation
                                                widget.product.choiceOptions !=
                                                            null &&
                                                        widget
                                                                .product
                                                                .choiceOptions
                                                                .length >
                                                            0
                                                    ? ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: widget
                                                            .product
                                                            .choiceOptions
                                                            .length,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    '${getTranslated('available', context)}' +
                                                                        ' ' +
                                                                        '${widget.product.choiceOptions[index].title} :',
                                                                    style: titilliumRegular.copyWith(
                                                                        fontSize:
                                                                            Dimensions.FONT_SIZE_LARGE)),
                                                                SizedBox(
                                                                    width: Dimensions
                                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                                Expanded(
                                                                  child: GridView
                                                                      .builder(
                                                                    gridDelegate:
                                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          4,
                                                                      crossAxisSpacing:
                                                                          5,
                                                                      mainAxisSpacing:
                                                                          5,
                                                                      childAspectRatio:
                                                                          (1 /
                                                                              .7),
                                                                    ),
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemCount: widget
                                                                        .product
                                                                        .choiceOptions[
                                                                            index]
                                                                        .options
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      return Center(
                                                                        child: Text(
                                                                            widget.product.choiceOptions[index].options[
                                                                                i],
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: titilliumRegular.copyWith(
                                                                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
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
                                  : SizedBox(),

                              // Specification
                              (widget.product.details != null &&
                                      widget.product.details.isNotEmpty)
                                  ? Container(
                                      height: 158,
                                      margin: EdgeInsets.only(
                                          top: Dimensions.PADDING_SIZE_SMALL),
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      child: ProductSpecification(
                                          productSpecification:
                                              widget.product.details ?? ''),
                                    )
                                  : SizedBox(),

                              //promise
                              Provider.of<ProfileProvider>(context,
                                              listen: false)
                                          .userInfoModel ==
                                      null
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimensions
                                              .PADDING_SIZE_DEFAULT,
                                          horizontal:
                                              Dimensions.FONT_SIZE_DEFAULT),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor),
                                      child: PromiseScreen())
                                  : Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .userInfoModel
                                              .user_role
                                              .toString() ==
                                          'normal'
                                      ? Container(
                                          padding:
                                              EdgeInsets.symmetric(
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_DEFAULT,
                                                  horizontal: Dimensions
                                                      .FONT_SIZE_DEFAULT),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor))
                                      : Visibility(child: Text(''), visible: false),

                              widget.product.addedBy == 'seller'
                                  ? SellerView(
                                      sellerId:
                                          widget.product.userId.toString())
                                  : SizedBox.shrink(),
                              //widget.product.addedBy == 'admin' ? SellerView(sellerId: '0') : SizedBox.shrink(),

                              // Reviews
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: Dimensions.PADDING_SIZE_SMALL),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                color: Theme.of(context).cardColor,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated(
                                            'customer_reviews', context),
                                        style: titilliumSemiBold.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE),
                                      ),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),
                                      Container(
                                        width: 230,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color:
                                              ColorResources.visitShop(context),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .PADDING_SIZE_EXTRA_LARGE),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            RatingBar(
                                              rating: double.parse(ratting),
                                              size: 18,
                                            ),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_DEFAULT),
                                            Text('${double.parse(ratting).toStringAsFixed(1)}' +
                                                ' ' +
                                                '${getTranslated('out_of_5', context)}'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                      Text('${details.reviewList != null ? details.reviewList.length : 0}' +
                                          ' ' +
                                          '${getTranslated('reviews', context)}'),
                                      details.reviewList != null
                                          ? details.reviewList.length != 0
                                              ? ReviewWidget(
                                                  reviewModel:
                                                      details.reviewList[0])
                                              : SizedBox()
                                          : ReviewShimmer(),
                                      details.reviewList != null
                                          ? details.reviewList.length > 1
                                              ? ReviewWidget(
                                                  reviewModel:
                                                      details.reviewList[1])
                                              : SizedBox()
                                          : ReviewShimmer(),
                                      details.reviewList != null
                                          ? details.reviewList.length > 2
                                              ? ReviewWidget(
                                                  reviewModel:
                                                      details.reviewList[2])
                                              : SizedBox()
                                          : ReviewShimmer(),
                                      InkWell(
                                          onTap: () {
                                            if (details.reviewList != null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ReviewScreen(
                                                              reviewList: details
                                                                  .reviewList)));
                                            }
                                          },
                                          child: details.reviewList != null &&
                                                  details.reviewList.length > 3
                                              ? Text(
                                                  getTranslated(
                                                      'view_more', context),
                                                  style:
                                                      titilliumRegular.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                )
                                              : SizedBox())
                                    ]),
                              ),

                              //saller more product
                              widget.product.addedBy == 'seller'
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_DEFAULT),
                                      child: TitleRow(
                                          title: getTranslated(
                                              'more_from_the_shop', context),
                                          isDetailsPage: true),
                                    )
                                  : SizedBox(),

                              widget.product.addedBy == 'seller'
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      child: ProductView(
                                          isHomePage: false,
                                          productType:
                                              ProductType.SELLER_PRODUCT,
                                          scrollController: _scrollController,
                                          sellerId:
                                              widget.product.userId.toString()),
                                    )
                                  : SizedBox(),

                              // Related Products
                              Container(
                                margin: EdgeInsets.only(
                                    top: Dimensions.PADDING_SIZE_SMALL),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL,
                                          vertical: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: TitleRow(
                                          title: getTranslated(
                                              'related_products', context),
                                          isDetailsPage: true),
                                    ),
                                    SizedBox(height: 5),
                                    RelatedProductView(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: NoInternetOrDataScreen(
                    isNoInternet: true,
                    child: ProductDetails(product: widget.product)));
      },
    );
  }
}
