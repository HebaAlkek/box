import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/featured_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

import '../../home/home_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  final BuildContext con;

  SignOutConfirmationDialog({this.con});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child:
      Provider.of<SplashProvider>(context, listen: false)
          .langDefault
          .toString() ==
          'ar'?Directionality(textDirection: TextDirection.rtl, child:  Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text(getTranslated('want_to_sign_out', con), style: robotoBold, textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(mainAxisAlignment: MainAxisAlignment.start,

            children: [

              Expanded(child: InkWell(
                onTap: () {
                  Provider.of<AuthProvider>(con, listen: false).clearSharedData().then((condition) {
                    Navigator.pop(context);
                    Provider.of<ProfileProvider>(con,listen: false).clearHomeAddress();
                    Provider.of<ProfileProvider>(con,listen: false).clearOfficeAddress();
                    Provider.of<AuthProvider>(con,listen: false).clearSharedData();

                    Provider.of<ProfileProvider>(context, listen: false)
                        .deleteUser();
                    Provider.of<BrandProvider>(con, listen: false).brandList.clear();
                    Navigator.of(con).pushReplacement(MaterialPageRoute(builder: (con) => AuthScreen()));
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: Text(getTranslated('YES', con), style: titilliumBold.copyWith(color: Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .font_color
                          .split('#')[1])))),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .primayColorsGet
                          .split('#')[1])), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('NO', con), style: titilliumBold.copyWith(color: Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .font_color
                          .split('#')[1])))),
                ),
              )),

            ]),
      ])):
      Directionality(textDirection: TextDirection.ltr, child:  Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text(getTranslated('want_to_sign_out', con), style: robotoBold, textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(mainAxisAlignment: MainAxisAlignment.start,

            children: [

              Expanded(child: InkWell(
                onTap: () {
                  Provider.of<AuthProvider>(con, listen: false).clearSharedData().then((condition) {
                    Navigator.pop(context);
                    Provider.of<ProfileProvider>(con,listen: false).clearHomeAddress();
                    Provider.of<ProfileProvider>(con,listen: false).clearOfficeAddress();
                    Provider.of<AuthProvider>(con,listen: false).clearSharedData();
                    Provider.of<ProfileProvider>(context, listen: false)
                        .deleteUser();
                    Provider.of<BrandProvider>(con, listen: false).brandList.clear();
                    Navigator.of(con).pushReplacement(MaterialPageRoute(builder: (con) => AuthScreen()));
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('YES', con), style: titilliumBold.copyWith(color: Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .font_color
                          .split('#')[1])))),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .primayColorsGet
                          .split('#')[1])), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: Text(getTranslated('NO', con), style: titilliumBold.copyWith(color:Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .font_color
                          .split('#')[1])))),
                ),
              )),

            ]),
      ]))

     ,
    );
  }

}
