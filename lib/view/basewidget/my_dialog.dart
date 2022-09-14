import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:provider/provider.dart';

class MyDialog extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String title;
  final String description;
  final BuildContext con;
  MyDialog({this.isFailed = false, this.rotateAngle = 0, @required this.icon, @required this.title, @required this.description,@required this.con});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Stack(clipBehavior: Clip.none, children: [

          Positioned(
            left: 0, right: 0, top: -55,
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isFailed ? ColorResources.getRed(context) :  Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .primayColorsGet
                      .split('#')[1])), shape: BoxShape.circle),
              child: Transform.rotate(angle: rotateAngle, child: Icon(icon, size: 40, color:Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .font_color
                      .split('#')[1])))),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(description, textAlign: TextAlign.center, style: titilliumRegular),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: CustomButton(buttonText: getTranslated('ok', con), onTap: () => Navigator.pop(context)),
              ),
            ]),
          ),

        ]),
      ),
    );
  }
}
