import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/brand_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class BrandProvider extends ChangeNotifier {
  final BrandRepo brandRepo;

  BrandProvider({@required this.brandRepo});

  List<BrandModel> _brandList = [];

  List<BrandModel> get brandList => _brandList;
  double percent=50;

  List<BrandModel> _originalBrandList = [];
bool load=false;

  Future<void> getBrandList(bool reload, BuildContext context) async {
    _brandList.clear();
percent = 50;
    if (_brandList.length == 0 || reload) {
      load=true;
      ApiResponse apiResponse = await brandRepo.getBrandList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _originalBrandList.clear();
        apiResponse.response.data.forEach((brand) {
          BrandModel item = BrandModel.fromJson(brand);
          if (item.brandProductsCount > 0) {
            _originalBrandList.add(BrandModel.fromJson(brand));
          }
        });
        _brandList.clear();
        apiResponse.response.data.forEach(( brand) {
          if (BrandModel.fromJson(brand).brandProductsCount > 0) {
            _brandList.add(BrandModel.fromJson(brand));
          }
        });
        load=false;

      } else {
        ApiChecker.checkApi(context, apiResponse,'0');
        load=false;

      }
      notifyListeners();
    }
  }


  bool isAZ = false;
  bool isZA = false;

  void sortBrandLis(int value) {
 if (value == 0) {
      _brandList.clear();
      _brandList.addAll(_originalBrandList);
      _brandList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      isAZ = true;
      isZA = false;
    } else if (value == 1) {
      _brandList.clear();
      _brandList.addAll(_originalBrandList);
      _brandList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      Iterable iterable = _brandList.reversed;
      _brandList = iterable.toList();
      isAZ = false;
      isZA = true;
    }

    notifyListeners();
  }
}
