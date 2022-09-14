import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class RelatedProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        return Column(children: [
          prodProvider.loadre == false
              ? prodProvider.relatedProductList != null
                  ? prodProvider.relatedProductList.length != 0
                      ? StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          itemCount: prodProvider.relatedProductList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.fit(1),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductWidget(
                                productModel:
                                    prodProvider.relatedProductList[index]);
                          },
                        )
                      : Center(child: Text('No related Product'))
                  : ProductShimmer(
                      isHomePage: false,
                      isEnabled: Provider.of<ProductProvider>(context)
                              .relatedProductList ==
                          null)
              : Text(
                  getTranslated('no_data_found', context),
                  textAlign: TextAlign.center,
                  style: titilliumRegular,
                ),
        ]);
      },
    );
  }
}
