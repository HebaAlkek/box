
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/search/widget/search_product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {

@override
  void initState() {
    // TODO: implement initState
  Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
  Provider.of<SearchProvider>(context, listen: false).initHistoryList();
  }
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.getIconBg(context),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15,15,15,0.0),
          child: Column(
            children: [


              // for tool bar
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1), // changes position of shadow
                  )],
                ),
                child:Provider.of<SplashProvider>(context, listen: false)
                    .langDefault
                    .toString() ==
                    'ar'? Row(
                  children: [

                    Expanded(
                      child: Container(
                        child: Directionality(textDirection:Provider.of<SplashProvider>(context, listen: false)
                            .langDefault
                            .toString() ==
                            'ar'?TextDirection.ltr:TextDirection.rtl ,
                          child: SearchWidget(
                            hintText: getTranslated('SEARCH_HINT', context),
                            onTextChanged: (String newText) => Provider.of<ProductProvider>(context, listen: false).filterData(newText),

                            onSubmit: (String text) {
                              Provider.of<SearchProvider>(context, listen: false).searchProduct(text, context);
                              Provider.of<SearchProvider>(context, listen: false).saveSearchAddress(text);
                            },
                            onClearPressed: () {
                              Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT,right: Dimensions.PADDING_SIZE_DEFAULT),
                      child: InkWell(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(Icons.arrow_forward_ios_sharp)),
                    ),
                  ],
                ):
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT,right: Dimensions.PADDING_SIZE_DEFAULT),
                      child: InkWell(
                        onTap: ()=>Navigator.pop(context),
                          child: Icon(Icons.arrow_back_ios)),
                    ),
                    Expanded(
                      child: Container(
                        child: Directionality(textDirection:Provider.of<SplashProvider>(context, listen: false)
                            .langDefault
                            .toString() ==
                            'ar'?TextDirection.ltr:TextDirection.rtl ,
                          child: SearchWidget(
                            hintText: getTranslated('SEARCH_HINT', context),
                            onTextChanged: (String newText) => Provider.of<ProductProvider>(context, listen: false).filterData(newText),

                            onSubmit: (String text) {
                              Provider.of<SearchProvider>(context, listen: false).searchProduct(text, context);
                              Provider.of<SearchProvider>(context, listen: false).saveSearchAddress(text);
                            },
                            onClearPressed: () {
                              Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35,),

              Consumer<SearchProvider>(
                builder: (context, searchProvider, child) {
                  return !searchProvider.isClear ? searchProvider.searchProductList != null ?
                  searchProvider.searchProductList.length > 0
                      ? Expanded(child: SearchProductWidget(products: searchProvider.searchProductList, isViewScrollable: true))
                      : Expanded(child: NoInternetOrDataScreen(isNoInternet: false))
                      : Expanded(child: ProductShimmer(isHomePage: false,
                      isEnabled: Provider.of<SearchProvider>(context).searchProductList == null))
                      : Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,50.0,0,0),
                            child: Consumer<SearchProvider>(
                              builder: (context, searchProvider, child) => StaggeredGridView.countBuilder(
                                crossAxisCount: 2,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: searchProvider.historyList.length,
                                itemBuilder: (context, index) => Container(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        Provider.of<SearchProvider>(context, listen: false).searchProduct(searchProvider.historyList[index], context);
                                      },
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: ColorResources.getGrey(context)),
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            Provider.of<SearchProvider>(context, listen: false).historyList[index] ?? "",
                                            style: titilliumItalic.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                          ),
                                        ),
                                      ),
                                    )),
                                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              ),
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('SEARCH_HISTORY', context), style: robotoBold),
                                  InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Provider.of<SearchProvider>(context, listen: false).clearSearchAddress();
                                      },
                                      child: Container(

                                          child: Text(
                                            getTranslated('REMOVE', context),
                                            style: titilliumRegular.copyWith(
                                                fontSize: 20, color:   Color(int.parse('0xFF' +
                                                Provider.of<SplashProvider>(context, listen: false)
                                                    .configModel
                                                    .font_color
                                                    .split('#')[1])) ),
                                          )))
                                ],
                              ),
                            ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
