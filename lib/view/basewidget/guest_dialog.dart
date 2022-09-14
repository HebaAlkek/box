import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

class GuestDialog extends StatelessWidget {
  final BuildContext con;

  GuestDialog(this.con);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(clipBehavior: Clip.none, fit: StackFit.loose, children: [
        Positioned(
          left: 0,
          right: 0,
          top: -50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(Images.login, height: 80, width: 80),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(getTranslated('THIS_SECTION_IS_LOCK', con),
                  style: robotoBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(getTranslated('GOTO_LOGIN_SCREEN_ANDTRYAGAIN', con),
                  textAlign: TextAlign.center, style: titilliumRegular),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Divider(height: 0, color: Theme.of(con).hintColor),
              Row(children: [
                Expanded(
                    child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .border_color
                                .split('#')[1])), spreadRadius: 0, blurRadius: 1)],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10))),
                    child: Text(getTranslated('CANCEL', con),
                        style: titilliumBold.copyWith(
                            color:   Color(int.parse('0xFF' +
                                Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    .font_color
                                    .split('#')[1])) )),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        con,
                        MaterialPageRoute(builder: (_) => AuthScreen()),
                        (route) => false);
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(con).primaryColor,
                        boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .border_color
                                .split('#')[1])), spreadRadius: 0, blurRadius: 1)],
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10))),
                    child: Text(getTranslated('LOGIN', con),
                        style: titilliumBold.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) )),
                  ),
                )),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
