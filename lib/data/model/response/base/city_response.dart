import 'package:flutter_sixvalley_ecommerce/data/model/body/citr_model.dart';

class CityResponse {
  final List<cityModelList> data;
  final String code;

  CityResponse(this.data, this.code);

  CityResponse.fromJson(List<dynamic> json, String statusCode)
      : data = List<cityModelList>.from(
            json.map((i) => cityModelList.fromJson(i))),
        code = statusCode;

  CityResponse.withError(Map<String, dynamic> json)
      : data = [],
        code = '0';
}
