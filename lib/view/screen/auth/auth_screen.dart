import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_in_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget{
  final int initialPage;
  AuthScreen({this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<AuthProvider>(context, listen: false).isRemember;
    PageController _pageController = PageController(initialPage: initialPage);

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          
          // background
          Provider.of<ThemeProvider>(context).darkTheme ? SizedBox() 
              : Image.asset(Images.background, fit: BoxFit.fill, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),

          Consumer<AuthProvider>(
            builder: (context, auth, child) => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),

                  // for logo with text
                  Image.network(Provider.of<SplashProvider>(context, listen: false)
                      .configModel.baseUrls.CompanyMobileLogoUrl, height: 150, width: 200),

                  // for decision making section like sign in or register section
                  Padding(
                    padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_LARGE),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: 0,
                          right: Dimensions.MARGIN_SIZE_EXTRA_SMALL,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //margin: EdgeInsets.only(right: Dimensions.FONT_SIZE_LARGE),
                            height: 1,
                            color: ColorResources.getGainsBoro(context),
                          ),
                        ),
                        Consumer<AuthProvider>(
                          builder: (context,authProvider,child)=>Row(
                            children: [
                              InkWell(
                                onTap: () => _pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                child: Column(
                                  children: [
                                    Text(getTranslated('SIGN_IN', context), style: authProvider.selectedIndex == 0 ? titilliumSemiBold : titilliumRegular),
                                    Container(
                                      height: 1,
                                      width: 40,
                                      margin: EdgeInsets.only(top: 8),
                                      color: authProvider.selectedIndex == 0 ? Color(int.parse('0xFF' +
                                          Provider.of<SplashProvider>(
                                              context,
                                              listen: false)
                                              .configModel
                                              .border_color
                                              .split('#')[1])) : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 25),
                              InkWell(
                                onTap: () => _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                child: Column(
                                  children: [
                                    Text(getTranslated('SIGN_UP', context), style: authProvider.selectedIndex == 1 ? titilliumSemiBold : titilliumRegular),
                                    Container(
                                        height: 1,
                                        width: 50,
                                        margin: EdgeInsets.only(top: 8),
                                        color: authProvider.selectedIndex == 1 ? Color(int.parse('0xFF' +
                                            Provider.of<SplashProvider>(
                                                context,
                                                listen: false)
                                                .configModel
                                                .border_color
                                                .split('#')[1])) : Colors.transparent
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // show login or register widget
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context,authProvider,child)=>PageView.builder(
                        itemCount: 2,
                        controller: _pageController,

                        itemBuilder: (context, index) {
                          if (authProvider.selectedIndex == 0) {
                            return SignInWidget('0');
                          } else {
                            return SignUpWidget('0');
                          }
                        },
                        onPageChanged: (index) {
                          authProvider.updateSelectedIndex(index);
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

