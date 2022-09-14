import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final isBackButtonExist;
  final IconData icon;
  final Function onActionPressed;
  final Function onBackPressed;
  final String type;

  CustomAppBar({@required this.title, this.isBackButtonExist = true, this.icon, this.onActionPressed, this.onBackPressed,this.type});

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).primaryColor,
      child: Stack(children: [

        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: 50,
          alignment: Alignment.center,
          child: Row(children: [

            isBackButtonExist ? IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20,
                  color:  Color(int.parse('0xFF' +
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .font_color
                          .split('#')[1]))),
              onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.of(context).pop(),
            ) : SizedBox.shrink(),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

            Expanded(
              child: Text(
                title, style: titilliumRegular.copyWith(fontSize: 20,
                color:  Color(int.parse('0xFF' +
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .font_color
                        .split('#')[1]))),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),

            icon != null ? IconButton(
              icon: Icon(icon, size: Dimensions.ICON_SIZE_LARGE, color:Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(
                      context,
                      listen: false)
                      .configModel
                      .font_color
                      .split('#')[1]))),
              onPressed: onActionPressed,
            ) : type!='1'?SizedBox.shrink() :IconButton(
              icon: Icon(Icons.picture_as_pdf_outlined, size: Dimensions.ICON_SIZE_LARGE, color: Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(
                      context,
                      listen: false)
                      .configModel
                      .font_color
                      .split('#')[1]))),
              onPressed: onActionPressed,
            ) ,

          ]),
        ),
      ]),
    );
  }
}
