import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';

import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class AllProductScreen extends StatefulWidget {
  final ScrollController _scrollController = ScrollController();
  final ProductType productType;
  AllProductScreen({@required this.productType});
  @override
  State<AllProductScreen> createState() => _AllProductScreen();
}

class _AllProductScreen extends State<AllProductScreen> {

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
int page=1;
  // Future<void> _loadData(BuildContext context, bool reload) async {
  //   String _languageCode = Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode;
  //   await Provider.of<BrandProvider>(context, listen: false).getBrandList(reload, context);
  //   await Provider.of<ProductProvider>(context, listen: false).getLatestProductList('1', context, _languageCode, reload: reload);
  //
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    // _loadData(context, false);


    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color:   Color(int.parse('0xFF' +
              Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .font_color
                  .split('#')[1]))),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.productType == ProductType.FEATURED_PRODUCT ? 'Featured Product':'Latest Product', style: titilliumRegular.copyWith(fontSize: 20, color:   Color(int.parse('0xFF' +
            Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .font_color
                .split('#')[1])))),

      ),

      body: SafeArea(
        child:SmartRefresher(
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
          child: CustomScrollView(
            controller: widget._scrollController,
            slivers: [
              SliverToBoxAdapter(

                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ProductView(isHomePage: false , productType: widget.productType, scrollController:widget._scrollController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoading() async {
    page=page+1;
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Provider.of<ProductProvider>(context, listen: false)
        .getLProductListMore(page.toString(), context, reload: false);
    print('lolo');

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
  void _onrefresh() async {
    page=1;
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Provider.of<ProductProvider>(context, listen: false)
        .getLProductList('1', context, reload: true);
    print('lolo');

    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }
}
