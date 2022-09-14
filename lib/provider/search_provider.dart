import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/search_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo searchRepo;

  SearchProvider({@required this.searchRepo});

  int _filterIndex = 0;
  List<String> historyListd = [];

  int get filterIndex => _filterIndex;

  List<String> get historyList => historyListd;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void sortSearchList(
      BuildContext context, double startingPrice, double endingPrice) {
    _searchProductList = [];
    bool isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (startingPrice > 0 && endingPrice > startingPrice) {
      if (!isGuestMode) {
        if (Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel
                .user_role
                .toString() ==
            'business account') {
          _searchProductList.addAll(_filterProductList
              .where((product) =>
                  (product.wholesale_price) > startingPrice &&
                  (product.wholesale_price) < endingPrice)
              .toList());
        } else {
          _searchProductList.addAll(_filterProductList
              .where((product) =>
                  (product.unitPrice) > startingPrice &&
                  (product.unitPrice) < endingPrice)
              .toList());
        }
      } else {
        _searchProductList.addAll(_filterProductList
            .where((product) =>
                (product.unitPrice) > startingPrice &&
                (product.unitPrice) < endingPrice)
            .toList());
      }
    } else {
      _searchProductList.addAll(_filterProductList);
    }

    if (_filterIndex == 0) {
    } else if (_filterIndex == 1) {
      _searchProductList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_filterIndex == 2) {
      _searchProductList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList();
    } else if (_filterIndex == 3) {
      bool isGuestMode =
          !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
      if (!isGuestMode) {
        if (Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel
                .user_role
                .toString() ==
            'business account') {
          _searchProductList
              .sort((a, b) => a.wholesale_price.compareTo(b.wholesale_price));
        } else {
          _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
        }
      } else {
        _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
      }
    } else if (_filterIndex == 4) {
      bool isGuestMode =
          !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
      if (!isGuestMode) {
        if (Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel
                .user_role
                .toString() ==
            'business account') {
          _searchProductList.sort((a, b) => a.wholesale_price.compareTo(b.wholesale_price));

        } else {
          _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));

        }
      } else {
        _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));

      }

      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList();
    }

    notifyListeners();
  }

  List<Product> _searchProductList;
  List<Product> _filterProductList;
  bool _isClear = true;
  String _searchText = '';

  List<Product> get searchProductList => _searchProductList;

  List<Product> get filterProductList => _filterProductList;

  bool get isClear => _isClear;

  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void searchProduct(String query, BuildContext context) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    notifyListeners();

    ApiResponse apiResponse = await searchRepo.getSearchProductList(query);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _filterProductList = [];
        _filterProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
      }
    } else {
      ApiChecker.checkApi(context, apiResponse,'0');
    }
    notifyListeners();
  }

  void initHistoryList() {
    historyListd = [];
    historyListd.addAll(searchRepo.getSearchAddress());
    notifyListeners();
  }

  void saveSearchAddress(String searchAddress) async {
    searchRepo.saveSearchAddress(searchAddress);
    if (!historyListd.contains(searchAddress)) {
      historyListd.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchAddress();
    historyListd = [];
    notifyListeners();
  }
}
