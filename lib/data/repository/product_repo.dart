import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class ProductRepo {
  final DioClient dioClient;
  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getLatestProductList(BuildContext context, String offset, ProductType productType, String title) async {
    String endUrl;

     if(productType == ProductType.BEST_SELLING){
      endUrl = AppConstants.BEST_SELLING_PRODUCTS_URI;
      title = getTranslated('best_selling', context);
    }
    else if(productType == ProductType.NEW_ARRIVAL){
      endUrl = AppConstants.NEW_ARRIVAL_PRODUCTS_URI;
      title = getTranslated('new_arrival',context);
    }
    else if(productType == ProductType.TOP_PRODUCT){
      endUrl = AppConstants.TOP_PRODUCTS_URI;
      title = getTranslated('top_product', context);
    }else if(productType == ProductType.DISCOUNTED_PRODUCT){
       endUrl = AppConstants.DISCOUNTED_PRODUCTS_URI;
       title = getTranslated('discounted_product', context);
     }

    try {
      final response = await dioClient.get(
        endUrl+offset);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //Seller Products
  Future<ApiResponse> getSellerProductList(String sellerId, String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.SELLER_PRODUCT_URI+sellerId+'/products?limit=10&&offset='+offset);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getQtyBranch(String code) async {
    try {
      final response = await dioClient.get(
          'http://18.133.209.188:89/'+AppConstants.BRANCH_QTY+'?key=123&code='+code);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandOrCategoryProductList(bool isBrand, String id,String page) async {
    try {
      String uri;
      if(isBrand){
        uri = '${AppConstants.BRAND_PRODUCT_URI}$id';
      }else {
        uri = '${AppConstants.CATEGORY_PRODUCT_URI}$id'+'&limit=10&offset='+page;
      }
      final response = await dioClient.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getRelatedProductList(String id) async {
    try {
      final response = await dioClient.get(
        AppConstants.RELATED_PRODUCT_URI+id);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getFeaturedProductList(String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.FEATURED_PRODUCTS_URI+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getLProductList(String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.LATEST_PRODUCTS_URI+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getLProductOffer(String offset) async {
    try {
      final response = await dioClient.get(
        AppConstants.OFFER_LIST+offset,);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRecommendedProduct() async {
    try {
      final response = await dioClient.get(AppConstants.DEAL_OF_THE_DAY_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}