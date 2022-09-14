import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/splash_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  SplashProvider({@required this.splashRepo});

  ConfigModel _configModel;
  BaseUrls _baseUrls;
  CurrencyList _myCurrency;
  CurrencyList _usdCurrency;
  CurrencyList _defaultCurrency;
  int _currencyIndex;
  PackageInfo _packageInfo;
  bool _hasConnection = true;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _onOff = true;
  bool get onOff => _onOff;
  bool success=false;
  bool get succConfig => success;

  ConfigModel get configModel => _configModel;
  BaseUrls get baseUrls => _baseUrls;
  CurrencyList get myCurrency => _myCurrency;
  CurrencyList get usdCurrency => _usdCurrency;
  CurrencyList get defaultCurrency => _defaultCurrency;
  int get currencyIndex => _currencyIndex;
  PackageInfo get packageInfo => _packageInfo;
  bool get hasConnection => _hasConnection;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  List<CurrencyList>  currencyListFirst=[];
  String  langDefault='';
  String  langDefaultChange='';

  String  countryCodei='';
  Future<bool> initConfig(BuildContext context) async {
    currencyListFirst.clear();
    _hasConnection = true;
    ApiResponse apiResponse = await splashRepo.getConfig();
    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response.data);
      _baseUrls = ConfigModel.fromJson(apiResponse.response.data).baseUrls;

      for(int i=0;i<_configModel.listangModelFirst.length;i++){
        if(_configModel.listangModelFirst[i].defaultLang==true){
          if(langDefaultChange=='') {
            langDefault = AppConstants.languages[i].languageCode;
          }else{
            langDefault=langDefaultChange;
          }
        }
      }
      for(int i=0;i<AppConstants.languages.length;i++){
        if(AppConstants.languages[i].languageCode.toString()==langDefault){
          countryCodei =AppConstants.languages[i].countryCode;

        }
      }
      Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
        langDefault,
        countryCodei,
      ),context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      success= true;
      prefs.setString('logoimg',_configModel.baseUrls.CompanyMobileLogoUrl);
      _baseUrls = ConfigModel.fromJson(apiResponse.response.data).baseUrls;
      String _currencyCode = splashRepo.getCurrency();
      for(int i=0;i<_configModel.currencyList.length;i++){
        if(_configModel.currencyList[i].status==1){
          currencyListFirst.add(_configModel.currencyList[i]);
        }
      }


      for(CurrencyList currencyList in currencyListFirst) {
        if(currencyList.id == _configModel.systemDefaultCurrency) {
          if(_currencyCode == null || _currencyCode.isEmpty) {
            _currencyCode = currencyList.code;
          }
          _defaultCurrency = currencyList;
        }
        if(currencyList.code == 'USD') {
          _usdCurrency = currencyList;
        }
      }
      getCurrencyData(_currencyCode);
      _packageInfo = await PackageInfo.fromPlatform();
      isSuccess = true;
    } else {
      isSuccess = false;
      ApiChecker.checkApi(context, apiResponse,'0');
      if(apiResponse.error.toString() == 'Connection to API server failed due to internet connection') {
        _hasConnection = false;
      }
    }
    notifyListeners();
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void getCurrencyData(String currencyCode) {
    _configModel.currencyList.forEach((currency) {
      if(currencyCode == currency.code) {
        _myCurrency = currency;
        _currencyIndex = _configModel.currencyList.indexOf(currency);
        return;
      }
    });
  }

  void setCurrency(int index) {
    splashRepo.setCurrency(_configModel.currencyList[index].code);
    getCurrencyData(_configModel.currencyList[index].code);
    notifyListeners();
  }

  void initSharedPrefData() {
    splashRepo.initSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  bool showIntro() {
    return splashRepo.showIntro();
  }

  void disableIntro() {
    splashRepo.disableIntro();
  }

  void changeAnnouncementOnOff(bool on){
    _onOff = !_onOff;
    notifyListeners();
  }


}
