import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final int index;
  CustomCheckBox({@required this.title, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setPaymentMethod(index),
          child: Row(children: [
            Checkbox(
              shape: CircleBorder(),
              value: order.paymentMethodIndex == index,
              activeColor: Color(int.parse('0xFF' +
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel
                      .font_color
                      .split('#')[1])),
              onChanged: (bool isChecked) => order.setPaymentMethod(index),
            ),
            Expanded(
              child: Text(title, style: titilliumRegular.copyWith(
                color: order.paymentMethodIndex == index ? Theme.of(context).textTheme.bodyText1.color : ColorResources.getGainsBoro(context),
              )),
            ),
          ]),
        );
      },
    );
  }
}
