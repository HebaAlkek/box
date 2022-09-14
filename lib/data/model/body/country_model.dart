import 'package:flutter/material.dart';

class countryModel {
  List<countModelList> countryList;

  countryModel({this.countryList});

  factory countryModel.fromJson(List<dynamic> json) {
    return countryModel(
        countryList: json.map((i) => countModelList.fromJson(i)).toList());
  }
}

class countModelList {
  String id;
  String code,
      name,
      continent,
      region,
      surface_area,
      indep_year,
      population,
      life_expectancy,
      gnp,
      gnp_old,
      local_name,
      government_form,
      head_of_state,
      capital,
      code2;
bool select =false;
  countModelList(
      {this.name,
      this.id,
      this.code,
      this.capital,
      this.code2,
      this.continent,
      this.gnp,
      this.gnp_old,
      this.government_form,
      this.head_of_state,
      this.indep_year,
      this.life_expectancy,
      this.local_name,
      this.population,
      this.region,
      this.surface_area});

  factory countModelList.fromJson(Map<String, dynamic> json) {
    return countModelList(
      name: json['name'].toString(),
      id: json['id'].toString(),
      code: json['code'].toString(),
      capital: json['capital'].toString(),
      code2: json['code2'].toString(),
      continent: json['continent'].toString(),
      gnp: json['gnp'].toString(),
      gnp_old: json['gnp_old'].toString(),
      government_form: json['government_form'].toString(),
      head_of_state: json['head_of_state'].toString(),
      indep_year: json['indep_year'].toString(),
      life_expectancy: json['life_expectancy'].toString(),
      local_name: json['local_name'].toString(),
      region: json['region'].toString(),
      population: json['population'].toString(),
      surface_area: json['surface_area'].toString(),
    );
  }
}
