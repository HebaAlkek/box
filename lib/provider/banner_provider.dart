import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/banner_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;

  BannerProvider({@required this.bannerRepo});

  List<BannerModel> _footerBannerList;

  List<BannerModel> _footerBannerListB;
  List<BannerModel> _footerBannerListN;

  List<BannerModel> _mainSectionBannerList;
  Product _product;
  int _currentIndex;
  List<BannerModel> _mainBannerListB;

  List<BannerModel> _mainBannerListN;

  List<BannerModel> get mainBannerListB => _mainBannerListB;

  List<BannerModel> get mainBannerListN => _mainBannerListN;

  List<BannerModel> get footerBannerList => _footerBannerList;



  List<BannerModel> get mainSectionBannerList => _mainSectionBannerList;

  Product get product => _product;

  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload, BuildContext context) async {

    if (_mainBannerListB == null || _mainBannerListN == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        //"banner_for_user" -> "business_account_and_seller_account"

        _mainBannerListB = [];

        _mainBannerListN = [];

        apiResponse.response.data.forEach((bannerModel) {
          if (BannerModel.fromJson(bannerModel).banner_for_user.toString() ==
              'business_account_and_seller_account') {
            _mainBannerListB.add(BannerModel.fromJson(bannerModel));
          } else {
            _mainBannerListN.add(BannerModel.fromJson(bannerModel));
          }
        });
        _currentIndex = 0;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse, '0');
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> getFooterBannerList(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getFooterBannerList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _footerBannerListN = [];
      _footerBannerListB = [];
      _footerBannerList = [];
      apiResponse.response.data.forEach((bannerModel) {
        if (BannerModel.fromJson(bannerModel).banner_for_user.toString() ==
            'business_account_and_seller_account') {
          _footerBannerListB.add(BannerModel.fromJson(bannerModel));
        } else {
          _footerBannerListN.add(BannerModel.fromJson(bannerModel));
        }
      });
      if(Provider.of<ProfileProvider>(context, listen: false)
          .userInfoModel !=
          null){
        if(Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel
            .user_role
            .toString() !=
            'normal'){
          _footerBannerList.addAll(_footerBannerListB);

        }else{
          _footerBannerList.addAll(_footerBannerListN);

        }

      } else{
        _footerBannerList.addAll(_footerBannerListN);

      }
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
  }

  Future<void> getMainSectionBanner(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getMainSectionBannerList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _mainSectionBannerList = [];
      apiResponse.response.data.forEach((bannerModel) =>
          _mainSectionBannerList.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
  }

  void getProductDetails(BuildContext context, String productId) async {
    ApiResponse apiResponse = await bannerRepo.getProductDetails(productId);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _product = (Product.fromJson(apiResponse.response.data));
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
  }
}
