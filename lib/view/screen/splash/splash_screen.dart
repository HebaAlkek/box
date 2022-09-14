import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/maintenance/maintenance_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/onboarding/onboarding_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/splash/widget/splash_painter.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;

    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

         Provider.of<ProfileProvider>(context, listen: false).getUserInfoBusiness(context,'2');




    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)
                : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  String urlImg = '';

  void _route() {
    if (Provider.of<SplashProvider>(context, listen: false).succConfig ==
        true) {
      urlImg = Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .baseUrls
          .CompanyMobileLogoUrl;
      Provider.of<SplashProvider>(context, listen: false).initSharedPrefData();
      Timer(Duration(seconds: 1), () {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .maintenanceMode) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MaintenanceScreen()));
        } else {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false)
                .updateToken(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoardScreen()));
          } else {
            if (Provider.of<SplashProvider>(context, listen: false)
                .showIntro()) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => DashBoardScreen()));
            } else {
              Provider.of<AuthProvider>(context, listen: false)
                  .updateToken(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => DashBoardScreen()));
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Provider.of<ThemeProvider>(context).darkTheme
                      ? Colors.black
                      : ColorResources.getPrimary(context),
                  child: CustomPaint(
                    painter: SplashPainter(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        Provider.of<SplashProvider>(context, listen: false)
                            .configModel
                            .baseUrls
                            .CompanyMobileLogoUrl,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : NoInternetOrDataScreen(isNoInternet: true, child: SplashScreen()),
    );
  }
}
