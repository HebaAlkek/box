import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/city_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/country_response.dart';
import 'package:flutter_sixvalley_ecommerce/helper/country_api_provider.dart';

class CountryRepository {
  CountryApiProvider _apiProvider = CountryApiProvider();

  Future<CountryResponse> getCountryList() {
    return _apiProvider.getCountryList();
  }

  Future<CityResponse> getCityList(FormData data) {
    return _apiProvider.getCityList(data);
  }
}
