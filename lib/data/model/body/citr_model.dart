import 'package:flutter/material.dart';

class CityModel {
  List<cityModelList> cityList;

  CityModel({this.cityList});

  factory CityModel.fromJson(List<dynamic> json) {
    return CityModel(
        cityList: json.map((i) => cityModelList.fromJson(i)).toList());
  }
}

class cityModelList {
  String id;
  String country_code, name, district, population;
  bool select =false;

  cityModelList(
      {this.name, this.id, this.country_code, this.district, this.population});

  factory cityModelList.fromJson(Map<String, dynamic> json) {
    return cityModelList(
        name: json['name'].toString(),
        id: json['id'].toString(),
        country_code: json['country_code'].toString(),
        district: json['district'].toString(),
        population: json['population'].toString());
  }
}
