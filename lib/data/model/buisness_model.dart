class BuisnessModel {
  int user_id;
  String company_name;
  String commerical_number;
  String vat_number;
  String open_balancing;
  String limit_amount;
  String commerical_photo;
  String natinal_photo;
  String vat_certificate_photo;

  BuisnessModel(
      {this.user_id,
      this.company_name,
      this.commerical_number,
      this.vat_number,
      this.open_balancing,
      this.limit_amount,
      this.commerical_photo,
      this.natinal_photo,
      this.vat_certificate_photo});

  BuisnessModel.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    company_name = json['company_name'];
    commerical_number = json['commerical_number'];
    vat_number = json['vat_number'];
    open_balancing = json['open_balancing'];
    limit_amount = json['limit_amount'];
    commerical_photo = json['commerical_photo'];
    natinal_photo = json['natinal_photo'];
    vat_certificate_photo = json['vat_certificate_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['company_name'] = this.company_name;
    data['commerical_number'] = this.commerical_number;
    data['vat_number'] = this.vat_number;
    data['open_balancing'] = this.open_balancing;
    data['limit_amount'] = this.limit_amount;
    data['commerical_photo'] = this.commerical_photo;
    data['natinal_photo'] = this.natinal_photo;
    data['vat_certificate_photo'] = this.vat_certificate_photo;

    return data;
  }
}
