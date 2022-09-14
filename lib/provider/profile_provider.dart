import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/buisness_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/profile_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'order_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider({@required this.profileRepo});

  List<String> _addressTypeList = [];
  String _addressType = '';
  UserInfoModel _userInfoModel;
  BuisnessModel _userInfoModelBuisness;
  bool complete = false;
  String bala = '';
  String limit = '';

  bool _isLoading = false;
  List<AddressModel> _addressList = [];
  List<AddressModel> _billingAddressList = [];
  List<AddressModel> _shippingAddressList = [];
  bool _hasData;
  bool _isHomeAddress = true;
  String _addAddressErrorText;

  List<String> get addressTypeList => _addressTypeList;

  String get addressType => _addressType;

  UserInfoModel get userInfoModel => _userInfoModel;

  BuisnessModel get userInfoModelBuisness => _userInfoModelBuisness;

  bool get isLoading => _isLoading;

  List<AddressModel> get addressList => _addressList;

  List<AddressModel> get billingAddressList => _billingAddressList;

  List<AddressModel> get shippingAddressList => _shippingAddressList;

  bool get hasData => _hasData;

  bool get isHomeAddress => _isHomeAddress;

  String get addAddressErrorText => _addAddressErrorText;

  void setAddAddressErrorText(String errorText) {
    _addAddressErrorText = errorText;
    // notifyListeners();
  }

  void updateAddressCondition(bool value) {
    _isHomeAddress = value;
    notifyListeners();
  }

  bool _checkHomeAddress = false;

  bool get checkHomeAddress => _checkHomeAddress;

  bool _checkOfficeAddress = false;

  bool get checkOfficeAddress => _checkOfficeAddress;

  void setHomeAddress() {
    _checkHomeAddress = true;
    _checkOfficeAddress = false;
    notifyListeners();
  }
void deleteUser(){
    _userInfoModel=null;
}
  void setOfficeAddress() {
    _checkHomeAddress = false;
    _checkOfficeAddress = true;
    notifyListeners();
  }

  updateCountryCode(String value) {
    _addressType = value;
    notifyListeners();
  }

  Future<void> initAddressList(BuildContext context) async {
    ApiResponse apiResponse = await profileRepo.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _addressList = [];
      _billingAddressList = [];
      _shippingAddressList = [];
      apiResponse.response.data.forEach((address) {
        AddressModel addressModel = AddressModel.fromJson(address);
        if (addressModel.isBilling == 1) {
          _billingAddressList.add(addressModel);
        } else if (addressModel.isBilling == 0) {
          _addressList.add(addressModel);
        }
        _shippingAddressList.add(addressModel);
      });
      // apiResponse.response.data.forEach((address) => _addressList.add(AddressModel.fromJson(address)));
    } else {
      ApiChecker.checkApi(context, apiResponse,'0');
    }
    notifyListeners();
  }

  void removeAddressById(int id, int index, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo.removeAddressByID(id);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _addressList.removeAt(index);
      Map map = apiResponse.response.data;
      String message = map["message"];
      initAddressList(context);
      Provider.of<OrderProvider>(context, listen: false).shippingAddressNull();
      Provider.of<OrderProvider>(context, listen: false).billingAddressNull();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));

      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi(context, apiResponse,'0');
    }
    notifyListeners();
  }

  Future<String> getUserInfo(BuildContext context) async {
    String userID = '-1';
    ApiResponse apiResponse = await profileRepo.getUserInfo();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response.data);
      if (_userInfoModel.user_role.toString() == 'business account') {
        userID = '-1';
      } else {
        userID = _userInfoModel.id.toString();
      }
    } else {
      ApiChecker.checkApi(context, apiResponse,'0');
    }
    notifyListeners();
    return userID;
  }

  Future<String> refreshData(BuildContext context) async {
    ApiResponse apiResponse =
        await profileRepo.refreshData(_userInfoModel.financial_code);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (apiResponse.response.data['data'] != '') {
        userInfoModelBuisness.open_balancing =
            apiResponse.response.data['data'][0]['Balance'].toString();
        userInfoModelBuisness.limit_amount =
            apiResponse.response.data['data'][0]['CreditLimit'].toString();
        limit = apiResponse.response.data['data'][0]['CreditLimit'].toString();
        bala = apiResponse.response.data['data'][0]['Balance'].toString();
      }

      addDataBala(bala,limit);
    } else {
      ApiChecker.checkApi(context, apiResponse,'0');
    }
    notifyListeners();
  }

  Future addDataBala(String bala, String limit) async {
    notifyListeners();
    Map<String, dynamic> data = {
      "id": _userInfoModel.id,
      "limit_amount":limit==""?0: limit,
      "open_balancing":bala==""?0: bala
    };
    ApiResponse apiResponse = await profileRepo.addDataBala(data);

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
    } else {}
    notifyListeners();
  }

  Future<String> getUserInfoBusiness(BuildContext context, String type) async {
    String userID = '-1';
    ApiResponse apiResponse = await profileRepo.getUserInfoBuisness();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _userInfoModelBuisness =
          BuisnessModel.fromJson(apiResponse.response.data[0]);
      userID = _userInfoModelBuisness.user_id.toString();
      if (_userInfoModelBuisness.company_name == null ||
          _userInfoModelBuisness.commerical_number == null ||
          _userInfoModelBuisness.vat_number == null ||
          _userInfoModelBuisness.commerical_photo == null ||
          _userInfoModelBuisness.vat_certificate_photo == null ||
          _userInfoModelBuisness.natinal_photo == null) {
        complete = true;
      } else {
        complete = false;
      }
      if (type == '1') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);
      }
    } else {
      ApiChecker.checkApi(context, apiResponse,'0');
    }
    notifyListeners();
    return userID;
  }

  void initAddressTypeList(BuildContext context) async {
    if (_addressTypeList.length == 0) {
      ApiResponse apiResponse = await profileRepo.getAddressTypeList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _addressTypeList.clear();
        _addressTypeList.addAll(apiResponse.response.data);
        _addressType = apiResponse.response.data[0];
      } else {
        ApiChecker.checkApi(context, apiResponse,'0');
      }
      notifyListeners();
    }
  }

  Future addAddress(AddressModel addressModel, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo.addAddress(addressModel);
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      if (_addressList == null) {
        _addressList = [];
      }
      _addressList.add(addressModel);
      String message = map["message"];
      callback(true, message);
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel,
      String pass, File file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateUserInfoComm(
      BuildContext com,
      UserInfoModel updateUserModel,
      String pass,
      File file,
      String token,
      String comname,
      String comnum,
      String vatnum,
      File comphoto,
      File vatphoto,
      File natphoto) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo.updateProfileComm(
        updateUserModel,
        pass,
        file,
        token,
        comname,
        comnum,
        vatnum,
        comphoto,
        vatphoto,
        natphoto);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      print(message);
      complete = true;
      getUserInfoBusiness(com, '2');
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  // save office and home address
  void saveHomeAddress(String homeAddress) {
    profileRepo.saveHomeAddress(homeAddress).then((_) {
      notifyListeners();
    });
  }

  void saveOfficeAddress(String officeAddress) {
    profileRepo.saveOfficeAddress(officeAddress).then((_) {
      notifyListeners();
    });
  }

  // for home Address Section
  String getHomeAddress() {
    return profileRepo.getHomeAddress();
  }

  Future<bool> clearHomeAddress() async {
    return await profileRepo.clearHomeAddress();
  }

  // for office Address Section
  String getOfficeAddress() {
    return profileRepo.getOfficeAddress();
  }

  Future<bool> clearOfficeAddress() async {
    return await profileRepo.clearOfficeAddress();
  }
}
