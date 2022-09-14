import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String buttonText;
  final bool isBuy;
  CustomButton({this.onTap, @required this.buttonText, this.isBuy= false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorResources.getChatIcon(context),
            boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                Provider.of<SplashProvider>(context, listen: false)
                    .configModel
                    .border_color
                    .split('#')[1])), spreadRadius: 1, blurRadius: 5)],

            gradient: (Provider.of<ThemeProvider>(context).darkTheme || onTap == null) ? null : isBuy?
            LinearGradient(colors: [
              Color(0xffFE961C),
              Color(0xffFE961C),
              Color(0xffFE961C),
            ]):
            LinearGradient(colors: [
              Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .primayColorsGet
                      .split('#')[1])),
              Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .primayColorsGet
                      .split('#')[1])),
              Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .primayColorsGet
                      .split('#')[1])),
            ]),
            borderRadius: BorderRadius.circular(10)),
        child: Text(buttonText,
            style: titilliumSemiBold.copyWith(
              fontSize: 16,
              color: Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .font_color
                      .split('#')[1])),
            )),
      ),
    );
  }
}
