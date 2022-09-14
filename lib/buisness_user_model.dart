class BuisnessUserModel {
  int _id;
  String _f_name;
  String _l_name;

  BuisnessUserModel(this._id, this._f_name, this._l_name);

  int get id => _id;

  String get f_name => _f_name;

  String get l_name => _l_name;

  BuisnessUserModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _f_name = json['f_name'];
    _l_name = json['f_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._f_name;
    data['l_name'] = this._l_name;

    return data;
  }
}
