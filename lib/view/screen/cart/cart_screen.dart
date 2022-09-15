import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/text_field_seacr.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/widget/cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/checkout_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;

  CartScreen({this.fromCheckout = false, this.sellerId = 1});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _loadData() async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
      Provider.of<CartProvider>(context, listen: false).setCartData();

      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .shippingMethod !=
          'sellerwise_shipping') {
        Provider.of<CartProvider>(context, listen: false)
            .getAdminShippingMethodList(context);
      }
    }
  }

  TextEditingController _nameBuis = TextEditingController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      double amount = 0.0;
      double shippingAmount = 0.0;
      double discount = 0.0;
      double tax = 0.0;
      List<CartModel> cartList = [];
      cartList.addAll(cart.cartList);

      //TODO: seller

      List<String> orderTypeShipping = [];
      List<String> sellerList = [];
      List<CartModel> sellerGroupList = [];
      List<List<CartModel>> cartProductList = [];
      List<List<int>> cartProductIndexList = [];
      cartList.forEach((cart) {
        if (!sellerList.contains(cart.cartGroupId)) {
          sellerList.add(cart.cartGroupId);
          sellerGroupList.add(cart);
        }
      });

      sellerList.forEach((seller) {
        List<CartModel> cartLists = [];
        List<int> indexList = [];
        cartList.forEach((cart) {
          if (seller == cart.cartGroupId) {
            cartLists.add(cart);
            indexList.add(cartList.indexOf(cart));
          }
        });
        cartProductList.add(cartLists);
        cartProductIndexList.add(indexList);
      });

      sellerGroupList.forEach((seller) {
        if (seller.shippingType == 'order_wise') {
          orderTypeShipping.add(seller.shippingType);
        }
      });

      if (cart.getData &&
          Provider.of<AuthProvider>(context, listen: false).isLoggedIn() &&
          Provider.of<SplashProvider>(context, listen: false)
              .configModel
              .shippingMethod ==
              'sellerwise_shipping') {
        Provider.of<CartProvider>(context, listen: false)
            .getShippingMethod(context, cartProductList);
      }

      for (int i = 0; i < cart.cartList.length; i++) {
        amount += (cart.cartList[i].price - cart.cartList[i].discount) *
            cart.cartList[i].quantity;
        discount += cart.cartList[i].discount * cart.cartList[i].quantity;
        tax += cart.cartList[i].tax * cart.cartList[i].quantity;
      }
      for (int i = 0; i < cart.chosenShippingList.length; i++) {
        shippingAmount += cart.chosenShippingList[i].shippingCost;
      }
      for (int j = 0; j < cartList.length; j++) {
        shippingAmount += cart.cartList[j].shippingCost ?? 0;
      }

      return Scaffold(
        bottomNavigationBar: (!widget.fromCheckout && !cart.isLoading)
            ? Container(
          height: 80,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE,
              vertical: Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10)),
          ),
          child: cartList.isNotEmpty
              ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Center(
                        child: Row(
                          children: [
                            Text(
                              '${getTranslated('total_price', context)}',
                              style: titilliumSemiBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE),
                            ),
                            Text(
                              PriceConverter.convertPrice(
                                  context, amount + shippingAmount),
                              style: titilliumSemiBold.copyWith(
                                  color: Color(int.parse('0xFF' +
                                      Provider.of<SplashProvider>(context,
                                          listen: false)
                                          .configModel
                                          .font_color
                                          .split('#')[1])),
                                  fontSize: Dimensions.FONT_SIZE_LARGE),
                            ),
                          ],
                        ))),
                Builder(
                  builder: (context) => InkWell(
                    onTap: () {
                      if (Provider.of<ProfileProvider>(context,
                          listen: false)
                          .userInfoModel ==
                          null) {
                        print(
                            '===asd=>${orderTypeShipping.length}');
                        if (Provider.of<AuthProvider>(context,
                            listen: false)
                            .isLoggedIn()) {
                          if (cart.cartList.length == 0) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(getTranslated(
                                  'select_at_least_one_product',
                                  context)),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CheckoutScreen(
                                      cartList: cartList,
                                      totalOrderAmount: amount,
                                      shippingFee:
                                      shippingAmount,
                                      discount: discount,
                                      tax: tax,
                                    )));
                          }
                        } else {
                          showAnimatedDialog(
                              context, GuestDialog(context),
                              isFlip: true);
                        }
                      } else {
                        if (Provider.of<ProfileProvider>(context,
                            listen: false)
                            .userInfoModel
                            .user_role
                            .toString() ==
                            'buisness account') {
                          String bala =
                              Provider.of<ProfileProvider>(context,
                                  listen: false)
                                  .userInfoModelBuisness
                                  .open_balancing;
                          String amcount =
                              Provider.of<ProfileProvider>(context,
                                  listen: false)
                                  .userInfoModelBuisness
                                  .limit_amount;

                          print(
                              (amount + shippingAmount).toString());

                          double totals = double.parse(
                              (amount + shippingAmount)
                                  .toString()) +
                              double.parse(amcount);
                          print(totals.toString());
                          if (totals > double.parse(bala)) {
                            showCustomSnackBar(
                                getTranslated('recharge', context),
                                context);
                          } else {
                            print(
                                '===asd=>${orderTypeShipping.length}');
                            if (Provider.of<AuthProvider>(context,
                                listen: false)
                                .isLoggedIn()) {
                              if (cart.cartList.length == 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'select_at_least_one_product',
                                      context)),
                                  backgroundColor: Colors.red,
                                ));
                              } else if (cart.chosenShippingList
                                  .length <
                                  orderTypeShipping.length &&
                                  Provider.of<SplashProvider>(
                                      context,
                                      listen: false)
                                      .configModel
                                      .shippingMethod ==
                                      'sellerwise_shipping') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(getTranslated(
                                        'select_all_shipping_method',
                                        context)),
                                    backgroundColor:
                                    Colors.red));
                              } else if (cart.chosenShippingList
                                  .length <
                                  1 &&
                                  Provider.of<SplashProvider>(
                                      context,
                                      listen: false)
                                      .configModel
                                      .shippingMethod !=
                                      'sellerwise_shipping' &&
                                  Provider.of<SplashProvider>(
                                      context,
                                      listen: false)
                                      .configModel
                                      .inHouseSelectedShippingType ==
                                      'order_wise') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(getTranslated(
                                        'select_all_shipping_method',
                                        context)),
                                    backgroundColor:
                                    Colors.red));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            CheckoutScreen(
                                              cartList: cartList,
                                              totalOrderAmount:
                                              amount,
                                              shippingFee:
                                              shippingAmount,
                                              discount: discount,
                                              tax: tax,
                                            )));
                              }
                            } else {
                              showAnimatedDialog(
                                  context, GuestDialog(context),
                                  isFlip: true);
                            }
                          }
                        } else {
                          //amount
                          if (Provider.of<ProfileProvider>(context,
                              listen: false)
                              .userInfoModel
                              .user_role
                              .toString() ==
                              'seller account') {
                            if (double.parse(amount.toString()) >
                                double.parse(
                                    Provider.of<CartProvider>(
                                        context,
                                        listen: false)
                                        .amountLimit
                                        .toString())) {
                              showCustomSnackBar(
                                  getTranslated(
                                      'recharge', context),
                                  context);
                            } else {
                              print(
                                  '===asd=>${orderTypeShipping.length}');
                              if (Provider.of<AuthProvider>(context,
                                  listen: false)
                                  .isLoggedIn()) {
                                if (cart.cartList.length == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(getTranslated(
                                        'select_at_least_one_product',
                                        context)),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CheckoutScreen(
                                                cartList: cartList,
                                                totalOrderAmount:
                                                amount,
                                                shippingFee:
                                                shippingAmount,
                                                discount: discount,
                                                tax: tax,
                                                buinessId: cart
                                                    .buinessItem.id,
                                              )));
                                }
                              } else {
                                showAnimatedDialog(
                                    context, GuestDialog(context),
                                    isFlip: true);
                              }
                            }
                          } else {
                            print(
                                '===asd=>${orderTypeShipping.length}');
                            if (Provider.of<AuthProvider>(context,
                                listen: false)
                                .isLoggedIn()) {
                              if (cart.cartList.length == 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'select_at_least_one_product',
                                      context)),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                if(Provider.of<CartProvider>(context, listen: false).shippingList.length==0 ||
                                    Provider.of<CartProvider>(context, listen: false).shippingList[0].shippingIndex==-1){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(getTranslated(
                                        'select_ship',
                                        context)),
                                    backgroundColor: Colors.red,
                                  ));
                                }else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CheckoutScreen(
                                                cartList: cartList,
                                                totalOrderAmount:
                                                amount,
                                                shippingFee:
                                                shippingAmount,
                                                discount: discount,
                                                tax: tax,
                                              )));
                                }
                              }
                            } else {
                              showAnimatedDialog(
                                  context, GuestDialog(context),
                                  isFlip: true);
                            }
                          }
                        }
                      }
                    },
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
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
                        borderRadius: BorderRadius.circular(
                            Dimensions.PADDING_SIZE_SMALL),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions
                                  .PADDING_SIZE_EXTRA_LARGE,
                              vertical: Dimensions.FONT_SIZE_SMALL),
                          child: Text(
                              getTranslated('proceed', context),
                              style: titilliumSemiBold.copyWith(
                                fontSize:
                                Dimensions.FONT_SIZE_DEFAULT,
                                color: Color(int.parse('0xFF' +
                                    Provider.of<SplashProvider>(
                                        context,
                                        listen: false)
                                        .configModel
                                        .font_color
                                        .split('#')[1])),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ])
              : SizedBox(),
        )
            : null,
        body: Column(children: [
          CustomAppBar(title: getTranslated('CART', context)),
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel ==
              null
              ? Visibility(child: Text(''), visible: false)
              : Provider.of<ProfileProvider>(context, listen: false)
              .userInfoModel
              .user_role
              .toString() ==
              'seller account'
              ? Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 0, top: 0),
                      child: TextFieldSearch(
                        label: getTranslated('selectbui', context),
                        controller: _nameBuis,
                        minStringLength: 0,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                          border: InputBorder.none,
                          labelText:
                          getTranslated('selectbui', context),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        textStyle: TextStyle(color: Colors.black),
                        future: () {
                          return Provider.of<CartProvider>(context,
                              listen: false)
                              .GetBuisnessUser(context, _nameBuis.text);
                        },
                        getSelectedValue: (item) {
                          print(item);
                          cart.buinessItem = item;
                          _nameBuis.text = cart.buinessItem.f_name +
                              ' ' +
                              cart.buinessItem.l_name;
                          Provider.of<CartProvider>(context,
                              listen: false)
                              .GetLimitAmount(context,
                              cart.buinessItem.id.toString());
                        },
                      )

                    /*DropdownButtonHideUnderline(
                              child: DropdownButton<BuisnessUserModel>(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                            value: cart.buinessItem,
                            underline: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10, top: 10),
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                            items: cart.buinessUsers
                                .map((BuisnessUserModel value) {
                              return DropdownMenuItem<BuisnessUserModel>(
                                value: value,
                                child: new Text(
                                  value.f_name + ' ' + value.l_name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NeoSansArabicLight'),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              setState(() {
                                cart.buinessItem = val;
                              });
                              Provider.of<CartProvider>(context, listen: false)
                                  .GetLimitAmount(context,cart.buinessItem.id.toString());
                            },
                            isExpanded: true,
                            style: TextStyle(color: Colors.black),
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.black,
                            hint: Text(
                              getTranslated('selectbui', context),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'NeoSansArabicLight'),
                            ),
                          ))*/

                  )))
              : Visibility(child: Text(''), visible: false),
          SizedBox(
            height: 10,
          ),
          cart.isLoading
              ? Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
              : sellerList.length != 0
              ? Expanded(
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (Provider.of<AuthProvider>(context,
                            listen: false)
                            .isLoggedIn()) {
                          await Provider.of<CartProvider>(context,
                              listen: false)
                              .getCartDataAPI(context);
                        }
                      },
                      child: ListView.builder(
                        itemCount: sellerList.length,
                        padding: EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                Dimensions.PADDING_SIZE_SMALL),
                            child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  sellerGroupList[index]
                                      .shopInfo
                                      .isNotEmpty
                                      ? Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        8.0),
                                    child: Text(
                                        sellerGroupList[index]
                                            .shopInfo,
                                        textAlign:
                                        TextAlign.end,
                                        style: titilliumSemiBold
                                            .copyWith(
                                          fontSize: Dimensions
                                              .FONT_SIZE_LARGE,
                                        )),
                                  )
                                      : SizedBox(),
                                  Card(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: Dimensions
                                              .PADDING_SIZE_LARGE),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .highlightColor,
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding:
                                            EdgeInsets.all(0),
                                            itemCount:
                                            cartProductList[index]
                                                .length,
                                            itemBuilder:
                                                (context, i) {
                                              return CartWidget(
                                                cartModel:
                                                cartProductList[
                                                index][i],
                                                index:
                                                cartProductIndexList[
                                                index][i],
                                                fromCheckout: widget
                                                    .fromCheckout,
                                              );
                                            },
                                          ),

                                          //Provider.of<SplashProvider>(context,listen: false).configModel.shippingMethod =='sellerwise_shipping'?
                                          Provider.of<SplashProvider>(
                                              context,
                                              listen:
                                              false)
                                              .configModel
                                              .shippingMethod ==
                                              'sellerwise_shipping' &&
                                              sellerGroupList[
                                              index]
                                                  .shippingType ==
                                                  'order_wise'
                                              ? Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                Dimensions
                                                    .PADDING_SIZE_DEFAULT),
                                            child: InkWell(
                                              onTap: () {
                                                if (Provider.of<
                                                    AuthProvider>(
                                                    context,
                                                    listen:
                                                    false)
                                                    .isLoggedIn()) {
                                                  showModalBottomSheet(
                                                    context:
                                                    context,
                                                    isScrollControlled:
                                                    true,
                                                    backgroundColor:
                                                    Colors
                                                        .transparent,
                                                    builder: (context) => ShippingMethodBottomSheet(
                                                        groupId:
                                                        sellerGroupList[index]
                                                            .cartGroupId,
                                                        sellerIndex:
                                                        index,
                                                        sellerId:
                                                        sellerGroupList[index].id),
                                                  );
                                                } else {
                                                  showCustomSnackBar(
                                                      'not_logged_in',
                                                      context);
                                                }
                                              },
                                              child: Container(
                                                decoration:
                                                BoxDecoration(
                                                  border: Border.all(
                                                      width:
                                                      0.5,
                                                      color: Colors
                                                          .grey),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(
                                                      8.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                            getTranslated('SHIPPING_PARTNER',
                                                                context),
                                                            style:
                                                            titilliumRegular),
                                                        Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                (cart.shippingList == null || cart.shippingList[index].shippingMethodList == null || cart.chosenShippingList.length == 0 || cart.shippingList[index].shippingIndex == -1) ? '' : '${cart.shippingList[index].shippingMethodList[cart.shippingList[index].shippingIndex].title.toString()}',
                                                                style: titilliumSemiBold.copyWith(color: Color(int.parse('0xFF' +
                                                                    Provider.of<SplashProvider>(context, listen: false)
                                                                        .configModel
                                                                        .font_color
                                                                        .split('#')[1]))),
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                              Icon(Icons.keyboard_arrow_down, color: Color(int.parse('0xFF' +
                                                                  Provider.of<SplashProvider>(context, listen: false)
                                                                      .configModel
                                                                      .font_color
                                                                      .split('#')[1]))),
                                                            ]),
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          );
                        },
                      ),
                    ),
                  ),
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .shippingMethod !=
                      'sellerwise_shipping' &&
                      Provider.of<SplashProvider>(context,
                          listen: false)
                          .configModel
                          .inHouseSelectedShippingType ==
                          'order_wise'
                      ? Provider.of<ProfileProvider>(context,
                      listen: false)
                      .userInfoModel ==
                      null
                      ? SizedBox()
                      : Provider.of<ProfileProvider>(context,
                      listen: false)
                      .userInfoModel
                      .user_role
                      .toString() !=
                      'normal'
                      ? SizedBox()
                      : InkWell(
                    onTap: () {
                      if (Provider.of<AuthProvider>(
                          context,
                          listen: false)
                          .isLoggedIn()) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor:
                          Colors.transparent,
                          builder: (context) =>
                              ShippingMethodBottomSheet(
                                  groupId:
                                  'all_cart_group',
                                  sellerIndex: 0,
                                  sellerId: 1),
                        );
                      } else {
                        showCustomSnackBar(
                            'not_logged_in', context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5,
                            color: Colors.grey),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                  getTranslated(
                                      'SHIPPING_PARTNER',
                                      context),
                                  style:
                                  titilliumRegular),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .end,
                                  children: [
                                    Text(
                                      (cart.shippingList == null ||
                                          cart.chosenShippingList
                                              .length ==
                                              0 ||
                                          cart.shippingList
                                              .length ==
                                              0 ||
                                          cart.shippingList[0].shippingMethodList ==
                                              null ||
                                          cart.shippingList[0]
                                              .shippingIndex ==
                                              -1)
                                          ? ''
                                          : '${cart.shippingList[0].shippingMethodList[cart.shippingList[0].shippingIndex].title.toString()}',
                                      style: titilliumSemiBold.copyWith(
                                          color: Color(int.parse('0xFF' +
                                              Provider.of<SplashProvider>(context, listen: false)
                                                  .configModel
                                                  .font_color
                                                  .split('#')[1]))),
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                    SizedBox(
                                        width: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Icon(
                                        Icons
                                            .keyboard_arrow_down,
                                        color:Color(int.parse('0xFF' +
                                            Provider.of<SplashProvider>(context, listen: false)
                                                .configModel
                                                .font_color
                                                .split('#')[1]))),
                                  ]),
                            ]),
                      ),
                    ),
                  )
                      : SizedBox(),
                ],
              ),
            ),
          )
              : Expanded(
              child: NoInternetOrDataScreen(isNoInternet: false)),
        ]),
      );
    });
  }
}
