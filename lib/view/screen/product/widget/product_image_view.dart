import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/favourite_button.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductImageView extends StatelessWidget {
  final Product productModel;
  ProductImageView({@required this.productModel});

  final PageController _controller = PageController();
  bool isGuestMode;

  @override
  Widget build(BuildContext context) {
    isGuestMode =
    !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductImageScreen(imageList: productModel.images, title: productModel.name))),
          child: productModel.images !=null ?Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
              gradient: Provider.of<ThemeProvider>(context).darkTheme ? null : LinearGradient(
                colors: [ColorResources.WHITE, ColorResources.IMAGE_BG],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(children: [
              Container(
                color:Colors.white,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: productModel.images != null?PageView.builder(
                    controller: _controller,
                    itemCount: productModel.images.length,
                    itemBuilder: (context, index) {
                      return FadeInImage.assetNetwork(
                        placeholder: Images.placeholder, height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productImageUrl}/${productModel.images[index]}',
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.placeholder, height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,fit: BoxFit.cover,
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      Provider.of<ProductDetailsProvider>(context, listen: false).setImageSliderSelectedIndex(index);
                    },
                  ):SizedBox(),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: 30,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _indicators(context),
                    ),
                    Spacer(),
                    Provider.of<ProductDetailsProvider>(context).imageSliderIndex != null?
                    Padding(
                      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT,bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Text('${Provider.of<ProductDetailsProvider>(context).imageSliderIndex+1}'+'/'+'${productModel.images.length.toString()}'),
                    ):SizedBox(),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Column(
                  children: [
                    FavouriteButton(
                      backgroundColor: ColorResources.getImageBg(context),
                      favColor: Colors.redAccent,
                      isSelected: Provider.of<WishListProvider>(context,listen: false).isWish,
                      productId: productModel.id,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                    InkWell(
                      onTap: () {
                        if(Provider.of<ProductDetailsProvider>(context, listen: false).sharableLink != null) {
                          Share.share(Provider.of<ProductDetailsProvider>(context, listen: false).sharableLink);
                        }
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.share, color:   Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .font_color
                                  .split('#')[1])) , size: Dimensions.ICON_SIZE_SMALL),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              productModel.discountvalue.toString()=='0'?Visibility(child: Text(''),visible: false,):
              productModel.discountvalue.toString()=='0.0'?Visibility(child: Text(''),visible: false,):
              !isGuestMode?
              Provider.of<ProfileProvider>(context, listen: false).userInfoModel.user_role.toString()=='business account' ?
              productModel.wholesale_price !=null && productModel.discountvalue != 0 ?
              Positioned(
                left: 0,top: 0,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .border_color
                                  .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL))
                      ),
                      child:productModel.discounttype == 'percent' || productModel.discounttype == 'percentage'?
                      Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          double.parse(  productModel.discountvalue), productModel.discounttype)}'+' % '+getTranslated('off', context)+' ',
                        style: titilliumRegular.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) , fontSize: 12),
                      ):
                      Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          double.parse(  productModel.discountvalue), productModel.discounttype)}'+getTranslated('off', context)+' ',
                        style: titilliumRegular.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) , fontSize: 12),
                      ),
                    ),

                  ],
                ),
              ) : SizedBox.shrink():
              productModel.unitPrice !=null && productModel.discountvalue != 0 ?
              Positioned(
                left: 0,top: 0,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .border_color
                                  .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL))
                      ),
                      child: productModel.discounttype == 'percent' || productModel.discounttype == 'percentage'?
                      Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          double.parse(  productModel.discountvalue), productModel.discounttype)}'+' % '+getTranslated('off', context)+' ',
                        style: titilliumRegular.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) , fontSize: 12),
                      ):
                      Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          double.parse(  productModel.discountvalue), productModel.discounttype)}'+getTranslated('off', context)+' ',
                        style: titilliumRegular.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) , fontSize: 12),
                      ),
                    ),

                  ],
                ),
              ) : SizedBox.shrink():

              productModel.unitPrice !=null && productModel.discountvalue != 0 ?
              Positioned(
                left: 0,top: 0,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color:Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .border_color
                                  .split('#')[1])), spreadRadius: 1, blurRadius: 5)],
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.PADDING_SIZE_SMALL))
                      ),
                      child:productModel.discounttype == 'percent' || productModel.discounttype == 'percentage'?
                      Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          double.parse(  productModel.discountvalue), productModel.discounttype)}'+' % '+getTranslated('off', context)+' ',
                        style: titilliumRegular.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) , fontSize: 12),
                      ):
                      Text('${PriceConverter.percentageCalculation(context, productModel.unitPrice,
                          double.parse(  productModel.discountvalue), productModel.discounttype)}'+getTranslated('off', context)+' ',
                        style: titilliumRegular.copyWith(color:  Color(int.parse('0xFF' +
                            Provider.of<SplashProvider>(context, listen: false)
                                .configModel
                                .font_color
                                .split('#')[1])) , fontSize: 12),
                      ),
                    ),

                  ],
                ),
              ) : SizedBox.shrink(),
              SizedBox.shrink(),


            ]),
          ):SizedBox(),
        ),

      ],
    );
  }

  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0; index < productModel.images.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == Provider.of<ProductDetailsProvider>(context).imageSliderIndex ?
        Theme.of(context).primaryColor : ColorResources.WHITE,
        borderColor: ColorResources.WHITE,
        size: 10,
      ));
    }
    return indicators;
  }

}
