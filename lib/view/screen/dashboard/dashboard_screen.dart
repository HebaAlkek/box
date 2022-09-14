import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/login_page.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/more_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/profile_home.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController _pageController = PageController();
  int _pageIndex = 0;

  List<Widget> _screens ;

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel.businessMode == "single";


    _screens = [
      HomePage(),
      Provider.of<AuthProvider>(context, listen: false).isLoggedIn()?ProfileScreenHome('1'): LoginPage() ,
      singleVendor? NotificationScreen(isBacButtonExist: false): OrderScreen(isBacButtonExist: false),
      singleVendor? MoreScreen(): NotificationScreen(isBacButtonExist: false),
      singleVendor?SizedBox(): MoreScreen(),
    ];

    NetworkInfo.checkConnectivity(context);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:   Color(int.parse('0xFF' +
              Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .font_color
                  .split('#')[1])) ,
          unselectedItemColor: Theme.of(context).textTheme.bodyText1.color,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: _getBottomWidget(singleVendor),
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String label, int index) {
    return BottomNavigationBarItem(

      icon: Image.asset(
        icon, color: index == _pageIndex ?   Color(int.parse('0xFF' +
          Provider.of<SplashProvider>(context, listen: false)
              .configModel
              .font_color
              .split('#')[1])) : Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
        height: 25, width: 25,
      ),
      label: label,

    );
  }

  void _setPage(int pageIndex) {
    Provider.of<BrandProvider>(context, listen: false)
        .percent = 50;
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> _list = [];
    _list.add(_barItem(Images.home_image, getTranslated('home', context), 0));
    if(!isSingleVendor) {
      _list.add(_barItem(Images.message_image, getTranslated('inbox', context), 0));
    }
    _list.add(_barItem(Images.person, getTranslated('profile', context), 1));
    _list.add(_barItem(Images.notification, getTranslated('notification', context), 2));
    _list.add(_barItem(Images.more_image, getTranslated('more', context), 3));
    return _list;
  }

}