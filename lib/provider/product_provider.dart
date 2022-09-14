import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/product_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({@required this.productRepo});

  // Latest products
  List<Product> _latestProductList = [];
  List<Product> _lProductList = [];
  List<Map<String, dynamic>> listdash = [];
  List<dynamic> valuList = [];
  List<String> keysTitla = [];
  List<Product> _lProductListOffer = [];

  List<String> titles = [];
  List<DataCell> cellList = [];

  List<DataColumn> headerList = [];
  List<int> indexxList = [];

  List<Product> get lProductList => _lProductList;

  List<Product> get lProductListOffer => _lProductListOffer;

  bool loadOffer = false;
  List<Product> _featuredProductList = [];

  ProductType _productType = ProductType.NEW_ARRIVAL;
  String _title = 'xyz';

  bool _filterIsLoading = false;
  bool _filterFirstLoading = true;

  bool _isLoading = false;
  bool _isFeaturedLoading = false;

  bool get isFeaturedLoading => _isFeaturedLoading;
  bool _firstFeaturedLoading = true;
  bool _firstLoading = true;
  int _latestPageSize;
  int _lOffset = 1;
  int _sellerOffset = 1;
  int _lPageSize;

  int get lPageSize => _lPageSize;
  int _featuredPageSize;

  ProductType get productType => _productType;

  String get title => _title;

  int get lOffset => _lOffset;
  bool isGuestMode;
  bool load = false;

  int get sellerOffset => _sellerOffset;

  List<int> _offsetList = [];
  List<String> _lOffsetList = [];

  List<String> get lOffsetList => _lOffsetList;
  List<String> _featuredOffsetList = [];

  List<Product> get latestProductList => _latestProductList;

  List<Product> get featuredProductList => _featuredProductList;

  Product _recommendedProduct;

  Product get recommendedProduct => _recommendedProduct;

  bool get filterIsLoading => _filterIsLoading;

  bool get filterFirstLoading => _filterFirstLoading;

  bool get isLoading => _isLoading;

  bool get firstFeaturedLoading => _firstFeaturedLoading;

  bool get firstLoading => _firstLoading;

  int get latestPageSize => _latestPageSize;

  int get featuredPageSize => _featuredPageSize;

  //latest product
  Future<void> getLatestProductList(int offset, BuildContext context,
      {bool reload = false}) async {
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (reload) {
      _offsetList = [];
      _latestProductList = [];
    }
    _lOffset = offset;
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLatestProductList(
          context, offset.toString(), productType, title);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _latestProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _latestPageSize =
            ProductModel.fromJson(apiResponse.response.data).totalSize;

        _filterFirstLoading = false;
        _filterIsLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse, '0');
      }
      notifyListeners();
    } else {
      if (_filterIsLoading) {
        _filterIsLoading = false;
        notifyListeners();
      }
    }
  }

  //getQtyBranch
  Future<void> getQtyBranch(String code, BuildContext context) async {
    load = true;
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    headerList.clear();
    indexxList.clear();
    listdash.clear();
    keysTitla.clear();
    valuList.clear();
    cellList.clear();
    ApiResponse apiResponse = await productRepo.getQtyBranch(code);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (apiResponse.response.data['data'] != "") {
        apiResponse.response.data['data']
            .forEach((product) => listdash.add(product));
        keysTitla = listdash[0].keys.toList();

        for (int i = 0; i < listdash.length; i++) {
          valuList.add(listdash[i].values.toList());
        }
        for (int i = 0; i < keysTitla.length; i++) {
          headerList.add(DataColumn(
            label: Align(
                alignment: Alignment.center,
                child: Center(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(keysTitla[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            fontStyle: FontStyle.italic)),
                  ],
                ))),
          ));
          indexxList.add(i);
        }

        // cellList.add(DataCell(Text(valuList[0][0].toString())));

//DataCell
        //headerList
        print('headerList' + headerList.toString());

        print('keysTitla' + keysTitla.toString());
        print('keysTitla' + valuList.toString());

        //titles.addAll(models);
        print(listdash);
        print(titles);
        load = false;
      } else {
        load = false;
      }
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
    notifyListeners();
  }

  //latest product
  Future<void> getLProductList(String offset, BuildContext context,
      {bool reload = false}) async {
    if (reload) {
      _lOffsetList = [];
      _lProductList = [];
    }
    if (!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLProductList(offset);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _lProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _lPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse, '0');
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // latest product more
  Future<void> getLProductListMore(String offset, BuildContext context,
      {bool reload = false}) async {
    if (reload) {}
    if (!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLProductList(offset);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _lProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _lPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse, '0');
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getOfferList(String offset, BuildContext context,
      {bool reload = false}) async {
    loadOffer = true;
    _lProductListOffer.clear();
    if (reload) {
      _lProductListOffer = [];
    }
    ApiResponse apiResponse = await productRepo.getLProductOffer(offset);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _lProductListOffer
          .addAll(ProductModel.fromJson(apiResponse.response.data).products);
      loadOffer = false;
    } else {
      loadOffer = false;

      ApiChecker.checkApi(context, apiResponse, '0');
    }
    notifyListeners();
  }

  Future<int> getLatestOffset(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getLatestProductList(
        context, '1', productType, title);
    return ProductModel.fromJson(apiResponse.response.data).totalSize;
  }

  void changeTypeOfProduct(ProductType type, String title) {
    _productType = type;
    _title = title;
    _latestProductList = null;
    _latestPageSize = 0;
    _filterFirstLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  // Seller products
  List<Product> _sellerAllProductList = [];
  List<Product> _sellerProductList = [];
  int _sellerPageSize;

  List<Product> get sellerProductList => _sellerProductList;

  int get sellerPageSize => _sellerPageSize;

  void initSellerProductList(String sellerId, int offset, BuildContext context,
      {bool reload = false}) async {
    _firstLoading = true;
    if (reload) {
      _offsetList = [];
      _sellerProductList = [];
    }
    _sellerOffset = offset;

    ApiResponse apiResponse =
        await productRepo.getSellerProductList(sellerId, offset.toString());
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _sellerProductList
          .addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _sellerAllProductList
          .addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _sellerPageSize =
          ProductModel.fromJson(apiResponse.response.data).totalSize;
      _firstLoading = false;
      _filterIsLoading = false;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
    notifyListeners();
  }

  void filterData(String newText) {
    _sellerProductList.clear();
    if (newText.isNotEmpty) {
      _sellerAllProductList.forEach((product) {
        if (product.name.toLowerCase().contains(newText.toLowerCase())) {
          _sellerProductList.add(product);
        }
      });
    } else {
      _sellerProductList.clear();
      _sellerProductList.addAll(_sellerAllProductList);
    }
    notifyListeners();
  }

  void clearSellerData() {
    _sellerProductList = [];
    //notifyListeners();
  }

  // Brand and category products
  List<Product> _brandOrCategoryProductList = [];
  bool _hasData;

  List<Product> get brandOrCategoryProductList => _brandOrCategoryProductList;

  bool get hasData => _hasData;
  int page = 1;

  void initBrandOrCategoryProductList(
      bool isBrand, String id, BuildContext context) async {
    page = 1;
    _brandOrCategoryProductList.clear();
    _hasData = true;
    ApiResponse apiResponse = await productRepo.getBrandOrCategoryProductList(
        isBrand, id, page.toString());
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (isBrand) {
        apiResponse.response.data.forEach((product) {
          _brandOrCategoryProductList.add(Product.fromJson(product));
        });
      } else {
        apiResponse.response.data['products'].forEach((product) {
          _brandOrCategoryProductList.add(Product.fromJson(product));
        });
      }

      _hasData = _brandOrCategoryProductList.length > 1;
      List<Product> _products = [];
      _products.addAll(_brandOrCategoryProductList);
      _brandOrCategoryProductList.clear();
      _brandOrCategoryProductList.addAll(_products.reversed);
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
    notifyListeners();
  }

  void initBrandOrCategoryProductListMore(
      bool isBrand, String id, BuildContext context,
      {bool reload = false}) async {
    ApiResponse apiResponse = await productRepo.getBrandOrCategoryProductList(
        isBrand, id, page.toString());
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (isBrand) {
        apiResponse.response.data.forEach((product) =>
            _brandOrCategoryProductList.add(Product.fromJson(product)));
      } else {
        apiResponse.response.data['products'].forEach((product) =>
            _brandOrCategoryProductList.add(Product.fromJson(product)));
      }
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
  }

  // Related products
  List<sizeMode> _sizeList;
  List<sizeMode> _sizeListSelect;
  sizeMode sizeItem;
  List<Product> _relatedProductList;
  List<Product> _relatedProductListColor;
  List<String> _colorList;

  List<String> get colorList => _colorList;

  List<sizeMode> get sizeList => _sizeList;

  List<sizeMode> get sizeListSelect => _sizeListSelect;

  List<Product> get relatedProductListColor => _relatedProductListColor;

  List<Product> get relatedProductList => _relatedProductList;
  bool loadre = false;

  void initRelatedProductList(
      String id, BuildContext context, Product item) async {
    ApiResponse apiResponse = await productRepo.getRelatedProductList(id);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _relatedProductList = [];
      _relatedProductListColor = [];
      _colorList = [];
      _sizeList = [];
      _sizeListSelect = [];
      apiResponse.response.data.forEach((product) {
        _relatedProductList.add(Product.fromJson(product));
        if (Product.fromJson(product).product_color != null) {
          _relatedProductListColor.add(Product.fromJson(product));
        }
      });
      for (int i = 0; i < _relatedProductListColor.length; i++) {
        _sizeList.add(sizeMode(
            _relatedProductListColor[i].id.toString(),
            _relatedProductListColor[i].product_color,
            _relatedProductListColor[i].product_size));
        if (_colorList.length != 0) {
          bool exit = false;

          for (int u = 0; u < _colorList.length; u++) {
            if (_colorList[u] == _relatedProductListColor[i].product_color) {
              exit = true;
              break;
            } else {
              exit = false;
            }
          }
          if (exit == false) {
            _colorList.add(_relatedProductListColor[i].product_color);
          }
        } else {
          _colorList.add(_relatedProductListColor[i].product_color);
        }
      }
      _sizeListSelect.add(
          sizeMode(item.id.toString(), item.product_color, item.product_size));
      sizeItem = _sizeListSelect[0];
      for (int i = 0; i < _sizeList.length; i++) {
        if (_sizeListSelect.length == 0) {
          _sizeListSelect.add(_sizeList[i]);
        } else {
          for (int u = 0; u < _sizeListSelect.length; u++) {
            if (_sizeListSelect[u].color == _sizeList[i].color) {
              _sizeListSelect.add(_sizeList[i]);
              break;
            }
          }
        }
      }
      if (_relatedProductList.length == 0) {
        loadre = true;
      } else {
        loadre = false;
      }
    }
    else {
      ApiChecker.checkApi(context, apiResponse, '0');
      if(apiResponse.error.toString()=='Not Found'){
        loadre = true;

      }

    }
    notifyListeners();
  }

  void setSizeList(BuildContext context, int index) async {
    _sizeListSelect = [];
    sizeItem = null;
    for (int i = 0; i < sizeList.length; i++) {
      if (sizeList[i].color == colorList[index]) {
        sizeListSelect.add(sizeList[i]);
      }
    }
    sizeItem = _sizeListSelect[0];

    notifyListeners();
  }

  void removePrevRelatedProduct() {
    _relatedProductList = null;
    _relatedProductListColor = null;
  }

  //featured product
  Future<void> getFeaturedProductList(String offset, BuildContext context,
      {bool reload = false}) async {
    if (reload) {
      _featuredOffsetList = [];
      _featuredProductList = [];
    }
    if (!_featuredOffsetList.contains(offset)) {
      _featuredOffsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo.getFeaturedProductList(offset);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _featuredProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _featuredPageSize =
            ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstFeaturedLoading = false;
        _isFeaturedLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse, '0');
      }
      notifyListeners();
    } else {
      if (_isFeaturedLoading) {
        _isFeaturedLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getRecommendedProduct(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getRecommendedProduct();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _recommendedProduct = Product.fromJson(apiResponse.response.data);
      print('=rex===>${recommendedProduct.toJson()}');
    } else {
      ApiChecker.checkApi(context, apiResponse, '0');
    }
    notifyListeners();
  }
}
