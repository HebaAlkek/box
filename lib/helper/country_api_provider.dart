import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/city_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/country_response.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class CountryApiProvider {
  Dio _dio = Dio();

  CountryApiProvider() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      options.headers["Content-Type"] = "application/json";
      return handler.next(options);
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response);
    }, onError: (DioError e, handler) {
      // Do something with response error
      return handler.next(e);
    }));
  }

  Future<CountryResponse> getCountryList() async {
    Response response;
    try {
      _dio.interceptors.clear();
      _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        // Do something before request is sent
        //   options.headers["Authorization"] ='Bearer a896fe45932abe8d1674e304f5dc448a4997bdba';
        options.headers["Content-Type"] = 'application/json';

        return handler.next(options);
      }, onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response);
      }, onError: (DioError e, handler) {
        // Do something with response error
        return handler.next(e);
      }));
      String url = AppConstants.BASE_URL + '/api/v1/countries';
      print(url);
      response = await _dio.get(url);
      print(response);

      return CountryResponse.fromJson(
          response.data, response.statusCode.toString());
    } on DioError catch (e) {
      print(e.response.data);
      return CountryResponse.withError(e.response.data);
    }
  }

  Future<CityResponse> getCityList(FormData data) async {
    Response response;
    try {
      _dio.interceptors.clear();
      _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        // Do something before request is sent
        //   options.headers["Authorization"] ='Bearer a896fe45932abe8d1674e304f5dc448a4997bdba';
        options.headers["Content-Type"] = 'application/json';

        return handler.next(options);
      }, onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response);
      }, onError: (DioError e, handler) {
        // Do something with response error
        return handler.next(e);
      }));
      String url = AppConstants.BASE_URL + '/api/v1/cities';
      print(url);
      response = await _dio.post(url,data: data);
      print(response);
      return CityResponse.fromJson(
          response.data, response.statusCode.toString());
    } on DioError catch (e) {
      print(e.response.data);
      return CityResponse.withError(e.response.data);
    }
  }


}
