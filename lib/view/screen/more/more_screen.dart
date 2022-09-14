import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/category/all_category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/web_view_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/html_view_Screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/offer/offers_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/profile_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/setting/settings_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'faq_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isGuestMode;
  String version;
  bool singleVendor = false;
  String imgUrl = '';

  Future<void> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imgUrl = prefs.getString('logoimg');
    });
  }

  @override
  void initState() {
    getImage();
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context)
          .then((value) async => {
                if (value == '-1')
                  {
                    await Provider.of<ProfileProvider>(context, listen: false)
                        .getUserInfoBusiness(context, '2')
                  }
                else
                  {}
              });
      Provider.of<WishListProvider>(context, listen: false).initWishList(
        context,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .countryCode,
      );
      setState(() {
        version = Provider.of<SplashProvider>(context, listen: false)
                    .configModel
                    .version !=
                null
            ? Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .version
            : '';
      });
    }
    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .businessMode ==
        "single";
    setState(() {
      version = Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .version !=
              null
          ? Provider.of<SplashProvider>(context, listen: false)
              .configModel
              .version
          : '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            Images.more_page_header,
            height: 120,
            fit: BoxFit.fill,
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Theme.of(context).primaryColor,
          ),
        ),

        // AppBar
        Provider.of<SplashProvider>(context, listen: false)
                    .langDefault
                    .toString() ==
                'ar'
            ? Directionality(
                textDirection: TextDirection.ltr,
                child: Positioned(
                  top: 40,
                  left: Dimensions.PADDING_SIZE_SMALL,
                  right: Dimensions.PADDING_SIZE_SMALL,
                  child: Consumer<ProfileProvider>(
                    builder: (context, profile, child) {
                      return Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_LARGE),
                          child: Image.network(
                              Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .baseUrls
                                  .CompanyMobileLogoUrl,
                              height: 35,
                              color: Colors.transparent),
                        ),
                        Expanded(child: SizedBox.shrink()),
                        InkWell(
                          onTap: () {
                            if (isGuestMode) {
                              showAnimatedDialog(context, GuestDialog(context),
                                  isFlip: true);
                            } else {
                              if (Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .userInfoModel !=
                                  null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileScreen('1')));
                              }
                            }
                          },
                          child: Row(children: [
                            Text(
                                !isGuestMode
                                    ? profile.userInfoModel != null
                                        ? '${profile.userInfoModel.fName} ${profile.userInfoModel.lName}'
                                        : 'Full Name'
                                    : 'Guest',
                                style: titilliumRegular.copyWith(
                                    color: Color(int.parse('0xFF' +
                                        Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .configModel
                                            .font_color
                                            .split('#')[1])))),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            isGuestMode
                                ? CircleAvatar(
                                    child: Icon(Icons.person, size: 35))
                                : profile.userInfoModel == null
                                    ? CircleAvatar(
                                        child: Icon(Icons.person, size: 35))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: imgUrl,
                                          width: 35,
                                          height: 35,
                                          fit: BoxFit.fill,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModel.image}',
                                          imageErrorBuilder: (c, o, s) =>
                                              CircleAvatar(
                                                  child: Icon(Icons.person,
                                                      size: 35)),
                                        ),
                                      ),
                          ]),
                        ),
                      ]);
                    },
                  ),
                ))
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Positioned(
                  top: 40,
                  left: Dimensions.PADDING_SIZE_SMALL,
                  right: Dimensions.PADDING_SIZE_SMALL,
                  child: Consumer<ProfileProvider>(
                    builder: (context, profile, child) {
                      return Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_LARGE),
                          child: Image.network(
                              Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .baseUrls
                                  .CompanyMobileLogoUrl,
                              height: 35,
                              color: Colors.transparent),
                        ),
                        Expanded(child: SizedBox.shrink()),
                        InkWell(
                          onTap: () {
                            if (isGuestMode) {
                              showAnimatedDialog(context, GuestDialog(context),
                                  isFlip: true);
                            } else {
                              if (Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .userInfoModel !=
                                  null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileScreen('1')));
                              }
                            }
                          },
                          child: Row(children: [
                            Text(
                                !isGuestMode
                                    ? profile.userInfoModel != null
                                        ? '${profile.userInfoModel.fName} ${profile.userInfoModel.lName}'
                                        : 'Full Name'
                                    : 'Guest',
                                style: titilliumRegular.copyWith(
                                    color: Color(int.parse('0xFF' +
                                        Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .configModel
                                            .font_color
                                            .split('#')[1])))),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            isGuestMode
                                ? CircleAvatar(
                                    child: Icon(Icons.person, size: 35))
                                : profile.userInfoModel == null
                                    ? CircleAvatar(
                                        child: Icon(Icons.person, size: 35))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: imgUrl,
                                          width: 35,
                                          height: 35,
                                          fit: BoxFit.fill,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModel.image}',
                                          imageErrorBuilder: (c, o, s) =>
                                              CircleAvatar(
                                                  child: Icon(Icons.person,
                                                      size: 35)),
                                        ),
                                      ),
                          ]),
                        ),
                      ]);
                    },
                  ),
                )),

        Container(
          margin: EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            color: ColorResources.getIconBg(context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  // Top Row Items
                  Row(
                      mainAxisAlignment:
                          Provider.of<SplashProvider>(context, listen: false)
                                      .configModel
                                      .show_offers ==
                                  0
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        SquareButton(
                          image: Images.shopping_image,
                          title: getTranslated('orders', context),
                          navigateTo: OrderScreen(),
                          count: 1,
                          hasCount: false,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SquareButton(
                          image: Images.cart_image,
                          title: getTranslated('CART', context),
                          navigateTo: CartScreen(),
                          count:
                              Provider.of<CartProvider>(context, listen: false)
                                  .cartList
                                  .length,
                          hasCount: true,
                        ),
                        Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    .show_offers ==
                                0
                            ? Visibility(
                                child: Text(''),
                                visible: false,
                              )
                            : SizedBox(
                                width: 15,
                              ),
                        Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    .show_offers ==
                                '0'
                            ? SizedBox(
                                width: 15,
                              )
                            : SquareButton(
                                image: Images.offers,
                                title: getTranslated('offers', context),
                                navigateTo: OffersScreen(),
                                count: 0,
                                hasCount: false,
                              ),
                        Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    .show_offers ==
                                0
                            ? Visibility(
                                child: Text(''),
                                visible: false,
                              )
                            : SizedBox(
                                width: 15,
                              ),
                        SquareButton(
                          image: Images.wishlist,
                          title: getTranslated('wishlist', context),
                          navigateTo: WishListScreen(),
                          count:
                              Provider.of<AuthProvider>(context, listen: false)
                                          .isLoggedIn() &&
                                      Provider.of<WishListProvider>(context,
                                                  listen: false)
                                              .wishList !=
                                          null &&
                                      Provider.of<WishListProvider>(context,
                                                  listen: false)
                                              .wishList
                                              .length >
                                          0
                                  ? Provider.of<WishListProvider>(context,
                                          listen: false)
                                      .wishList
                                      .length
                                  : 0,
                          hasCount: false,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.fast_delivery,
                        title: getTranslated('address', context),
                        navigateTo: AddressListScreen()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.more_filled_image,
                        title: getTranslated('all_category', context),
                        navigateTo: AllCategoryScreen()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.notification_filled,
                        title: getTranslated('notification', context),
                        navigateTo: NotificationScreen()),
                  ),
                  //TODO: seller
                  singleVendor
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                          child: TitleButton(
                              image: Images.chats,
                              title: getTranslated('chats', context),
                              navigateTo: InboxScreen()),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.settings,
                        title: getTranslated('settings', context),
                        navigateTo: SettingsScreen()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.preference,
                        title: getTranslated('support_ticket', context),
                        navigateTo: SupportTicketScreen()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.term_condition,
                        title: getTranslated('terms_condition', context),
                        navigateTo: HtmlViewScreen(
                          title: getTranslated('terms_condition', context),
                          url: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .termsConditions,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.privacy_policy,
                        title: getTranslated('privacy_policy', context),
                        navigateTo: HtmlViewScreen(
                          title: getTranslated('privacy_policy', context),
                          url: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .termsConditions,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.help_center,
                        title: getTranslated('faq', context),
                        navigateTo: FaqScreen(
                          title: getTranslated('faq', context),
                          // url: Provider.of<SplashProvider>(context, listen: false).configModel.staticUrls.faq,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.about_us,
                        title: getTranslated('about_us', context),
                        navigateTo: HtmlViewScreen(
                          title: getTranslated('about_us', context),
                          url: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .aboutUs,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: TitleButton(
                        image: Images.contact_us,
                        title: getTranslated('contact_us', context),
                        navigateTo: WebViewScreen(
                          title: getTranslated('contact_us', context),
                          url: Provider.of<SplashProvider>(context,
                                  listen: false)
                              .configModel
                              .staticUrls
                              .contactUs,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                    child: ListTile(
                      leading: Icon(Icons.info_outline,
                          color: Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .font_color
                                  .split('#')[1]))),
                      title: Text(getTranslated('app_info', context),
                          style: titilliumRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE)),
                      trailing: version == ''
                          ? Text('')
                          : Text(' ( ' + version + ' ) '),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 1,
                    color: Colors.black12.withOpacity(0.1),
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  isGuestMode
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0.0),
                          child: ListTile(
                            leading: Icon(Icons.exit_to_app,
                                color: Color(int.parse('0xFF' +
                                    Provider.of<SplashProvider>(context, listen: false)
                                        .configModel
                                        .font_color
                                        .split('#')[1])),
                                size: 25),
                            title: Text(getTranslated('sign_out', context),
                                style: titilliumRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE)),
                            onTap: () => showAnimatedDialog(
                                context,
                                SignOutConfirmationDialog(
                                  con: context,
                                ),
                                isFlip: true),
                          ),
                        ),
                ]),
          ),
        ),
      ]),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;

  SquareButton(
      {@required this.image,
      @required this.title,
      @required this.navigateTo,
      @required this.count,
      @required this.hasCount});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 100;
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Container(
          width: width / 4,
          height: width / 4,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          decoration: BoxDecoration(
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
            borderRadius: BorderRadius.circular(10),
            color: ColorResources.getPrimary(context),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(image,
                  color: Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .font_color
                          .split('#')[1]))),
              hasCount
                  ? Positioned(
                      top: -4,
                      right: -4,
                      child: Consumer<CartProvider>(
                          builder: (context, cart, child) {
                        return CircleAvatar(
                          radius: 7,
                          backgroundColor: Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .secColorsGet
                                  .split('#')[1])),
                          child: Text(count.toString(),
                              style: titilliumSemiBold.copyWith(
                                color: Color(int.parse('0xFF' +
                                    Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel
                                        .font_color
                                        .split('#')[1])),
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                              )),
                        );
                      }),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Align(
          alignment: Alignment.center,
          child: Text(title, style: titilliumRegular),
        ),
      ]),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;

  TitleButton(
      {@required this.image, @required this.title, @required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(image,
              width: 25,
              height: 25,
              fit: BoxFit.fill,
              color: Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .font_color
                      .split('#')[1]))),
          title: Text(title,
              style: titilliumRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE)),
          trailing: Icon(Icons.keyboard_arrow_left_sharp),
          onTap: () => Navigator.push(
            context,
            /*PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
              return ScaleTransition(scale: animation, child: child, alignment: Alignment.center);
            },
          ),*/
            MaterialPageRoute(builder: (_) => navigateTo),
          ),
          /*onTap: () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: Duration(milliseconds: 500),
      )),*/
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 1,
          color: Colors.black12.withOpacity(0.1),
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
