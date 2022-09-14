import '../body/country_model.dart';

class CountryResponse {
  final List<countModelList> data;
  final String code;

  CountryResponse(this.data, this.code);

  CountryResponse.fromJson(List<dynamic> json, String statusCode)
      : data = List<countModelList>.from(json.map((i) => countModelList.fromJson(i))),


        code = statusCode;

  CountryResponse.withError(Map<String, dynamic> json)
      : data = [],
        code = '0';
}
