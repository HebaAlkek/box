import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class OffersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .getOfferList('1', context,);

    return CustomExpandedAppBar(title: getTranslated('offers', context), child: Consumer<ProductProvider>(
      builder: (context, banner, child) {
        return banner.loadOffer == true ?
        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
:
        banner.lProductListOffer.length != 0 ? RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Provider.of<BannerProvider>(context, listen: false).getFooterBannerList( context);
          },
          child:   StaggeredGridView.countBuilder(
            itemCount: banner.lProductListOffer.length,
            crossAxisCount: 2,
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: banner.lProductListOffer[index]);
            },
          ),
        ) : NoInternetOrDataScreen(isNoInternet: false);
      },
    ));
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class OfferShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<BannerProvider>(context).footerBannerList == null,
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResources.WHITE),
          ),
        );
      },
    );
  }
}

