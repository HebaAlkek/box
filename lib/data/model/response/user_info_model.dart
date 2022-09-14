class UserInfoModel {
  int id;
  String name;
  String method;
  String fName;
  String lName;
  String phone;
  String image;
  String email;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String user_role;
  String financial_code;

  UserInfoModel(
      {this.id,this.financial_code,this.user_role, this.name, this.method, this.fName, this.lName, this.phone, this.image, this.email, this.emailVerifiedAt, this.createdAt, this.updatedAt});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    user_role = json['user_role'];
    method = json['_method'];
    financial_code=json['financial_code']!=null?json['financial_code']:'';
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['_method'] = this.method;
    data['f_name'] = this.fName;
    data['user_role'] =this.user_role;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['financial_code']=this.financial_code;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
