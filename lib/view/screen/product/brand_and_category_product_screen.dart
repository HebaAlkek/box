import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String name;
  final String image;
  BrandAndCategoryProductScreen({@required this.isBrand, @required this.id, @required this.name, this.image});


  @override
  State<BrandAndCategoryProductScreen> createState() => _BrandAndCategoryProductScreen();
  }

  class _BrandAndCategoryProductScreen extends State<BrandAndCategoryProductScreen> {
    RefreshController _refreshController =
    RefreshController(initialRefresh: false);
  void _onLoading() async {
    Provider.of<ProductProvider>(context, listen: false).page=Provider.of<ProductProvider>(context, listen: false).page+1;
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductListMore(widget.isBrand, widget.id, context ,reload: false);

    print('lolo');

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(widget.isBrand, widget.id, context);

  }
  void _onrefresh() async {
    Provider.of<ProductProvider>(context, listen: false).page=1;
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(widget.isBrand, widget.id, context);

    print('lolo');

    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

          CustomAppBar(title: widget.name),

          // Brand Details
          widget.isBrand ? Container(
            height: 100,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
            color: Theme.of(context).highlightColor,
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              FadeInImage.assetNetwork(
                placeholder: Images.placeholder, width: 80, height: 80, fit: BoxFit.cover,
                image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.brandImageUrl}/'+widget.image,
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, width: 80, height: 80, fit: BoxFit.cover),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Text( widget.name, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
            ]),
          ) : SizedBox.shrink(),

          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          // Products
        Container(height:widget.isBrand?MediaQuery.of(context).size.height-200:MediaQuery.of(context).size.height-100,child:
        SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context,
                  LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator(
                    color: Colors.black,
                  );
                } else if (mode == LoadStatus.failed) {
                  body =
                      Text("Load Failed!Click retry!");
                } else if (mode ==
                    LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onrefresh,
            onLoading: _onLoading,
            child: Provider.of<ProductProvider>(context, listen: false).brandOrCategoryProductList.length > 0 ?
            StaggeredGridView.countBuilder(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              itemCount: Provider.of<ProductProvider>(context, listen: false).brandOrCategoryProductList.length,
              shrinkWrap: true,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(productModel: Provider.of<ProductProvider>(context, listen: false).brandOrCategoryProductList[index]);
              },
            )
              :  Center(child: Provider.of<ProductProvider>(context, listen: false).hasData
              ? ProductShimmer(isHomePage: false,isEnabled: Provider.of<ProductProvider>(context).brandOrCategoryProductList.length == 0)
              : NoInternetOrDataScreen(isNoInternet: false),
          ))),

        ]),
    );
  }
}