import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreenHome extends StatefulWidget {
  String type;

  ProfileScreenHome(this.type);

  @override
  _ProfileScreenHomeState createState() => _ProfileScreenHomeState();
}

class _ProfileScreenHomeState extends State<ProfileScreenHome> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  String types = '0';
  final FocusNode _comFocus = FocusNode();
  final FocusNode _comnFoucs = FocusNode();
  final FocusNode _vatFocus = FocusNode();

  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _comName = TextEditingController();
  final TextEditingController _vatNum = TextEditingController();
  final TextEditingController _comNun = TextEditingController();

  File file;
  File fileCom;
  File fileVAt;
  File fileNat;

  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _chooseCom() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        fileCom = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _chooseVat() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        fileVAt = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _chooseNAt() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        fileNat = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _updateUserAccountComm() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _firstNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

/*    if (Provider.of<ProfileProvider>(context, listen: false)
        .userInfoModel
        .fName ==
        _firstNameController.text &&
        Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel
            .lName ==
            _lastNameController.text &&
        Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel
            .phone ==
            _phoneController.text &&
        file == null &&
        _passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
      //showCustomSnackBar('Change something to update', context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Change something to update'),
          backgroundColor: ColorResources.RED));
    } else*/

    if (_firstName.isEmpty || _lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if ((_password.isNotEmpty && _password.length < 6) ||
        (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('sixcpass', context)),
          backgroundColor: ColorResources.RED));
    } else if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)),
          backgroundColor: ColorResources.RED));
    } else {
      UserInfoModel updateUserInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      updateUserInfoModel.method = 'put';
      updateUserInfoModel.fName = _firstNameController.text ?? "";
      updateUserInfoModel.lName = _lastNameController.text ?? "";
      updateUserInfoModel.phone = _phoneController.text ?? '';
      String pass = _passwordController.text ?? '';
      String comn;
      if (_comName.text == '') {
        comn = Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModelBuisness
            .company_name;
      } else {
        comn = _comName.text;
      }

      String comnu;

      if (_comNun.text == '') {
        comnu = Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModelBuisness
            .commerical_number;
      } else {
        comnu = _comNun.text;
      }
      String vatn;

      if (_vatNum.text == '') {
        vatn = Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModelBuisness
            .vat_number;
      } else {
        vatn = _vatNum.text;
      }

      await Provider.of<ProfileProvider>(context, listen: false)
          .updateUserInfoComm(
          context,
          updateUserInfoModel,
          pass,
          file,
          Provider.of<AuthProvider>(context, listen: false).getUserToken(),
          comn,
          comnu,
          vatn,
          fileCom,
          fileVAt,
          fileNat)
          .then((response) {
        if (response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(getTranslated('updates', context)),
              backgroundColor: Colors.green));
          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.message), backgroundColor: Colors.red));
        }
      });
    }
  }

  _updateUserAccount() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _firstNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (Provider.of<ProfileProvider>(context, listen: false)
        .userInfoModel
        .fName ==
        _firstNameController.text &&
        Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel
            .lName ==
            _lastNameController.text &&
        Provider.of<ProfileProvider>(context, listen: false)
            .userInfoModel
            .phone ==
            _phoneController.text &&
        file == null &&
        _passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
      //showCustomSnackBar('Change something to update', context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Change something to update'),
          backgroundColor: ColorResources.RED));
    } else if (_firstName.isEmpty || _lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if ((_password.isNotEmpty && _password.length < 6) ||
        (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('sixcpass', context)),
          backgroundColor: ColorResources.RED));
    } else if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)),
          backgroundColor: ColorResources.RED));
    } else {
      UserInfoModel updateUserInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      updateUserInfoModel.method = 'put';
      updateUserInfoModel.fName = _firstNameController.text ?? "";
      updateUserInfoModel.lName = _lastNameController.text ?? "";
      updateUserInfoModel.phone = _phoneController.text ?? '';
      String pass = _passwordController.text ?? '';

      await Provider.of<ProfileProvider>(context, listen: false)
          .updateUserInfo(
        updateUserInfoModel,
        pass,
        file,
        Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      )
          .then((response) {
        if (response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(getTranslated('updates', context)),
              backgroundColor: Colors.green));
          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.message), backgroundColor: Colors.red));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          _firstNameController.text = profile.userInfoModel.fName;
          _lastNameController.text = profile.userInfoModel.lName;
          _emailController.text = profile.userInfoModel.email;
          _phoneController.text = profile.userInfoModel.phone;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                Images.toolbar_background,
                fit: BoxFit.fill,
                height: 500,
                color: Color(int.parse('0xFF' +
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .primayColorsGet
                        .split('#')[1])),
              ),
              Container(
                padding: EdgeInsets.only(top: 35, left: 15),
                child: Row(children: [
             
                  Text(getTranslated('PROFILE', context),
                      style: titilliumRegular.copyWith(
                          fontSize: 20, color: Color(int.parse('0xFF' +
                          Provider.of<SplashProvider>(context, listen: false)
                              .configModel
                              .font_color
                              .split('#')[1]))),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  new Spacer(),
                  widget.type != '1'
                      ? Visibility(
                    child: Text(''),
                    visible: false,
                  )
                      : profile.userInfoModel.user_role == 'business account'
                      ? Padding(
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                        child: Icon(
                          Icons.refresh,
                          color: Color(int.parse('0xFF' +
                              Provider.of<SplashProvider>(context, listen: false)
                                  .configModel
                                  .font_color
                                  .split('#')[1])),
                        ),
                        onTap: () {
                          Provider.of<ProfileProvider>(context,
                              listen: false)
                              .refreshData(context);
                        }),
                  )
                      : Visibility(
                    child: Text(''),
                    visible: false,
                  )
                ]),
              ),
              Container(
                padding: EdgeInsets.only(top: 55),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(int.parse('0xFF' +
                                Provider.of<SplashProvider>(context, listen: false)
                                    .configModel
                                    .font_color
                                    .split('#')[1])),
                            border: Border.all(color: Colors.white, width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: file == null
                                    ? FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModel.image}',
                                  imageErrorBuilder: (c, o, s) =>
                                      Image.asset(Images.placeholder,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover),
                                )
                                    : Image.file(file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -10,
                                child: CircleAvatar(
                                  backgroundColor:
                                  ColorResources.LIGHT_SKY_BLUE,
                                  radius: 14,
                                  child: IconButton(
                                    onPressed: _choose,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.edit,
                                        color: Color(int.parse('0xFF' +
                                            Provider.of<SplashProvider>(context, listen: false)
                                                .configModel
                                                .font_color
                                                .split('#')[1])), size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${profile.userInfoModel.fName} ${profile.userInfoModel.lName}',
                          style: titilliumSemiBold.copyWith(
                              color:Color(int.parse('0xFF' +
                                  Provider.of<SplashProvider>(context, listen: false)
                                      .configModel
                                      .font_color
                                      .split('#')[1])), fontSize: 20.0),
                        )
                      ],
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    profile.userInfoModel.user_role == 'business account'
                        ? widget.type == '1'
                        ? types == '0'
                        ? Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                            ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  color: ColorResources
                                                      .getLightSkyBlue(
                                                      context),
                                                  size: 20),
                                              SizedBox(
                                                  width: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Text(
                                                  getTranslated(
                                                      'FIRST_NAME',
                                                      context),
                                                  style:
                                                  titilliumRegular)
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            textInputType:
                                            TextInputType.name,
                                            focusNode: _fNameFocus,
                                            nextNode: _lNameFocus,
                                            hintText: profile
                                                .userInfoModel
                                                .fName ??
                                                '',
                                            controller:
                                            _firstNameController,
                                          ),
                                        ],
                                      )),
                                  SizedBox(width: 15),
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  color: ColorResources
                                                      .getLightSkyBlue(
                                                      context),
                                                  size: 20),
                                              SizedBox(
                                                  width: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Text(
                                                  getTranslated(
                                                      'LAST_NAME',
                                                      context),
                                                  style:
                                                  titilliumRegular)
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            textInputType:
                                            TextInputType.name,
                                            focusNode: _lNameFocus,
                                            nextNode: _emailFocus,
                                            hintText: profile
                                                .userInfoModel.lName,
                                            controller:
                                            _lastNameController,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: ColorResources
                                                      .getLightSkyBlue(
                                                      context),
                                                  size: 20),
                                              SizedBox(
                                                  width: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Text(
                                                  getTranslated(
                                                      'creditl',
                                                      context),
                                                  style:
                                                  titilliumRegular)
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_SMALL),
                                          Container(
                                              width: double.infinity,
                                              decoration:
                                              BoxDecoration(
                                                color: Theme.of(
                                                    context)
                                                    .highlightColor,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(6),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .grey
                                                          .withOpacity(
                                                          0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(
                                                          0, 1))
                                                  // changes position of shadow
                                                ],
                                              ),
                                              child: Padding(
                                                child: Text(
                                                    Provider.of<ProfileProvider>(
                                                        context,
                                                        listen:
                                                        false)
                                                        .userInfoModelBuisness ==
                                                        null
                                                        ? '0.0'
                                                        : Provider.of<ProfileProvider>(context, listen: false)
                                                        .limit ==
                                                        ''
                                                        ? Provider.of<ProfileProvider>(context, listen: false).userInfoModelBuisness.limit_amount ==
                                                        null
                                                        ? '0.0'
                                                        : Provider.of<ProfileProvider>(context, listen: false)
                                                        .userInfoModelBuisness
                                                        .limit_amount
                                                        : Provider.of<ProfileProvider>(
                                                        context,
                                                        listen:
                                                        false)
                                                        .limit,
                                                    style:
                                                    titilliumRegular),
                                                padding: EdgeInsets
                                                    .fromLTRB(10, 15,
                                                    10, 15),
                                              )),
                                        ],
                                      )),
                                  SizedBox(width: 15),
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                  Icons
                                                      .monetization_on_outlined,
                                                  color: ColorResources
                                                      .getLightSkyBlue(
                                                      context),
                                                  size: 20),
                                              SizedBox(
                                                  width: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Text(
                                                  getTranslated(
                                                      'bala',
                                                      context),
                                                  style:
                                                  titilliumRegular)
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_SMALL),
                                          Container(
                                              width: double.infinity,
                                              decoration:
                                              BoxDecoration(
                                                color: Theme.of(
                                                    context)
                                                    .highlightColor,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(6),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .grey
                                                          .withOpacity(
                                                          0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: Offset(
                                                          0, 1))
                                                  // changes position of shadow
                                                ],
                                              ),
                                              child: Padding(
                                                child: Text(
                                                    Provider.of<ProfileProvider>(
                                                        context,
                                                        listen:
                                                        false)
                                                        .userInfoModelBuisness ==
                                                        null
                                                        ? '0.0'
                                                        : Provider.of<ProfileProvider>(context, listen: false)
                                                        .bala ==
                                                        ''
                                                        ? Provider.of<ProfileProvider>(context, listen: false).userInfoModelBuisness.open_balancing ==
                                                        null
                                                        ? '0.0'
                                                        : Provider.of<ProfileProvider>(context, listen: false)
                                                        .userInfoModelBuisness
                                                        .open_balancing
                                                        : Provider.of<ProfileProvider>(
                                                        context,
                                                        listen:
                                                        false)
                                                        .bala,
                                                    style:
                                                    titilliumRegular),
                                                padding: EdgeInsets
                                                    .fromLTRB(10, 15,
                                                    10, 15),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                            ),

                            // for Email
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.alternate_email,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                        width: Dimensions
                                            .MARGIN_SIZE_EXTRA_SMALL,
                                      ),
                                      Text(
                                          getTranslated(
                                              'EMAIL', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType
                                        .emailAddress,
                                    focusNode: _emailFocus,
                                    nextNode: _phoneFocus,
                                    hintText: profile
                                        .userInfoModel
                                        .email ??
                                        '',
                                    controller: _emailController,
                                  ),
                                ],
                              ),
                            ),

                            // for Phone No
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.dialpad,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'PHONE_NO',
                                              context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType:
                                    TextInputType.number,
                                    focusNode: _phoneFocus,
                                    hintText: profile
                                        .userInfoModel
                                        .phone ??
                                        "",
                                    nextNode: _addressFocus,
                                    controller: _phoneController,
                                    isPhoneNumber: true,
                                  ),
                                ],
                              ),
                            ),

                            // for Password
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.lock_open,
                                          color: ColorResources
                                              .getPrimary(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'PASSWORD',
                                              context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller:
                                    _passwordController,
                                    focusNode: _passwordFocus,
                                    nextNode:
                                    _confirmPasswordFocus,
                                    textInputAction:
                                    TextInputAction.next,
                                  ),
                                ],
                              ),
                            ),

                            // for  re-enter Password
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.lock_open,
                                          color: ColorResources
                                              .getPrimary(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'RE_ENTER_PASSWORD',
                                              context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller:
                                    _confirmPasswordController,
                                    focusNode:
                                    _confirmPasswordFocus,
                                    textInputAction:
                                    TextInputAction.done,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                            ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
//company Name
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_balance,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'comna', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    focusNode: _comFocus,
                                    hintText: profile
                                        .userInfoModelBuisness
                                        .company_name ??
                                        "",
                                    nextNode: _vatFocus,
                                    controller: _comName,
                                    isPhoneNumber: false,
                                  ),
                                ],
                              ),
                            ),
                            //vat number
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                          Icons.elevator_outlined,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'vatn', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    focusNode: _vatFocus,
                                    hintText: profile
                                        .userInfoModelBuisness
                                        .vat_number ??
                                        "",
                                    nextNode: _comnFoucs,
                                    controller: _vatNum,
                                    isPhoneNumber: false,
                                  ),
                                ],
                              ),
                            ),
                            //com number
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                          Icons.category_outlined,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'comn', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    focusNode: _comnFoucs,
                                    hintText: profile
                                        .userInfoModelBuisness
                                        .commerical_number ??
                                        "",
                                    controller: _comNun,
                                    isPhoneNumber: false,
                                    textInputAction:
                                    TextInputAction.done,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.photo,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'comph', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: _chooseCom,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(0),
                                          child: fileCom == null
                                              ? FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholder,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit
                                                .cover,
                                            image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModelBuisness.commerical_photo}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholder,
                                                    width:
                                                    100,
                                                    height:
                                                    100,
                                                    fit: BoxFit
                                                        .cover),
                                          )
                                              : Image.file(
                                              fileCom,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit
                                                  .fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.photo,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'natph', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: _chooseNAt,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(0),
                                          child: fileNat == null
                                              ? FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholder,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit
                                                .cover,
                                            image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModelBuisness.natinal_photo}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholder,
                                                    width:
                                                    100,
                                                    height:
                                                    100,
                                                    fit: BoxFit
                                                        .cover),
                                          )
                                              : Image.file(
                                              fileNat,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit
                                                  .fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  left: Dimensions
                                      .MARGIN_SIZE_DEFAULT,
                                  right: Dimensions
                                      .MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.photo,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'vatph', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: _chooseVat,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(0),
                                          child: fileVAt == null
                                              ? FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholder,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit
                                                .cover,
                                            image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModelBuisness.vat_certificate_photo}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholder,
                                                    width:
                                                    100,
                                                    height:
                                                    100,
                                                    fit: BoxFit
                                                        .cover),
                                          )
                                              : Image.file(
                                              fileVAt,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit
                                                  .fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
//company Name
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left:
                                  Dimensions.MARGIN_SIZE_DEFAULT,
                                  right:
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_balance,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'comna', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    focusNode: _comFocus,
                                    hintText: profile
                                        .userInfoModelBuisness
                                        .company_name ??
                                        "",
                                    nextNode: _vatFocus,
                                    controller: _comName,
                                    isPhoneNumber: false,
                                  ),
                                ],
                              ),
                            ),
                            //vat number
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left:
                                  Dimensions.MARGIN_SIZE_DEFAULT,
                                  right:
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.elevator_outlined,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'vatn', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    focusNode: _vatFocus,
                                    hintText: profile
                                        .userInfoModelBuisness
                                        .vat_number ??
                                        "",
                                    nextNode: _comnFoucs,
                                    controller: _vatNum,
                                    isPhoneNumber: false,
                                  ),
                                ],
                              ),
                            ),
                            //com number
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left:
                                  Dimensions.MARGIN_SIZE_DEFAULT,
                                  right:
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.category_outlined,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'comn', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    focusNode: _comnFoucs,
                                    hintText: profile
                                        .userInfoModelBuisness
                                        .commerical_number ??
                                        "",
                                    controller: _comNun,
                                    isPhoneNumber: false,
                                    textInputAction:
                                    TextInputAction.done,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left:
                                  Dimensions.MARGIN_SIZE_DEFAULT,
                                  right:
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.photo,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'comph', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: _chooseCom,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(
                                              0),
                                          child: fileCom == null
                                              ? FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholder,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModelBuisness.commerical_photo}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholder,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit
                                                        .cover),
                                          )
                                              : Image.file(fileCom,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left:
                                  Dimensions.MARGIN_SIZE_DEFAULT,
                                  right:
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.photo,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'natph', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: _chooseNAt,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(
                                              0),
                                          child: fileNat == null
                                              ? FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholder,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModelBuisness.natinal_photo}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholder,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit
                                                        .cover),
                                          )
                                              : Image.file(fileNat,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left:
                                  Dimensions.MARGIN_SIZE_DEFAULT,
                                  right:
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.photo,
                                          color: ColorResources
                                              .getLightSkyBlue(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'vatph', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions
                                          .MARGIN_SIZE_SMALL),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      InkWell(
                                        onTap: _chooseVat,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(
                                              0),
                                          child: fileVAt == null
                                              ? FadeInImage
                                              .assetNetwork(
                                            placeholder: Images
                                                .placeholder,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModelBuisness.vat_certificate_photo}',
                                            imageErrorBuilder: (c,
                                                o, s) =>
                                                Image.asset(
                                                    Images
                                                        .placeholder,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit
                                                        .cover),
                                          )
                                              : Image.file(fileVAt,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  color: ColorResources
                                                      .getLightSkyBlue(
                                                      context),
                                                  size: 20),
                                              SizedBox(
                                                  width: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Text(
                                                  getTranslated(
                                                      'FIRST_NAME', context),
                                                  style: titilliumRegular)
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            textInputType: TextInputType.name,
                                            focusNode: _fNameFocus,
                                            nextNode: _lNameFocus,
                                            hintText:
                                            profile.userInfoModel.fName ??
                                                '',
                                            controller: _firstNameController,
                                          ),
                                        ],
                                      )),
                                  SizedBox(width: 15),
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  color: ColorResources
                                                      .getLightSkyBlue(
                                                      context),
                                                  size: 20),
                                              SizedBox(
                                                  width: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Text(
                                                  getTranslated(
                                                      'LAST_NAME', context),
                                                  style: titilliumRegular)
                                            ],
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            textInputType: TextInputType.name,
                                            focusNode: _lNameFocus,
                                            nextNode: _emailFocus,
                                            hintText:
                                            profile.userInfoModel.lName,
                                            controller: _lastNameController,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),

                            // for Email
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.alternate_email,
                                          color: ColorResources
                                              .getLightSkyBlue(context),
                                          size: 20),
                                      SizedBox(
                                        width: Dimensions
                                            .MARGIN_SIZE_EXTRA_SMALL,
                                      ),
                                      Text(
                                          getTranslated('EMAIL', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                      Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType:
                                    TextInputType.emailAddress,
                                    focusNode: _emailFocus,
                                    nextNode: _phoneFocus,
                                    hintText:
                                    profile.userInfoModel.email ?? '',
                                    controller: _emailController,
                                  ),
                                ],
                              ),
                            ),

                            // for Phone No
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.dialpad,
                                          color: ColorResources
                                              .getLightSkyBlue(context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'PHONE_NO', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                      Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.number,
                                    focusNode: _phoneFocus,
                                    hintText:
                                    profile.userInfoModel.phone ?? "",
                                    nextNode: _addressFocus,
                                    controller: _phoneController,
                                    isPhoneNumber: true,
                                  ),
                                ],
                              ),
                            ),

                            // for Password
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.lock_open,
                                          color:
                                          ColorResources.getPrimary(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'PASSWORD', context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                      Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    nextNode: _confirmPasswordFocus,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ],
                              ),
                            ),

                            // for  re-enter Password
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.lock_open,
                                          color:
                                          ColorResources.getPrimary(
                                              context),
                                          size: 20),
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text(
                                          getTranslated(
                                              'RE_ENTER_PASSWORD',
                                              context),
                                          style: titilliumRegular)
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                      Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller:
                                    _confirmPasswordController,
                                    focusNode: _confirmPasswordFocus,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    profile.userInfoModel.user_role == 'business account'
                        ? widget.type == '2'
                        ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<ProfileProvider>(context)
                          .isLoading
                          ? CustomButton(
                          onTap: () {
                            if (Provider.of<ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .company_name ==
                                null &&
                                _comName.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'insert_com', context)),
                                  backgroundColor:
                                  ColorResources.RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .vat_number ==
                                null &&
                                _vatNum.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'insert_vat', context)),
                                  backgroundColor:
                                  ColorResources.RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .commerical_number ==
                                null &&
                                _comNun.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'insert_com_num',
                                      context)),
                                  backgroundColor:
                                  ColorResources.RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .commerical_photo ==
                                null &&
                                fileCom == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'insert_com_photo',
                                      context)),
                                  backgroundColor:
                                  ColorResources.RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .natinal_photo ==
                                null &&
                                fileNat == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'insert_nat_photo',
                                      context)),
                                  backgroundColor:
                                  ColorResources.RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .vat_certificate_photo ==
                                null &&
                                fileVAt == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'insert_vat_photo',
                                      context)),
                                  backgroundColor:
                                  ColorResources.RED));
                            } else {
                              _updateUserAccountComm();
                            }
                          },
                          buttonText: getTranslated(
                              'UPDATE_ACCOUNT', context))
                          : Center(
                          child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Theme.of(context)
                                      .primaryColor))),
                    )
                        : types == '0'
                        ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                            Dimensions.MARGIN_SIZE_LARGE,
                            vertical: Dimensions.MARGIN_SIZE_SMALL),
                        child: CustomButton(
                            onTap: () {
                              setState(() {
                                widget.type = '2';
                                types = '1';
                              });
                            },
                            buttonText:
                            getTranslated('NEXT', context)))
                        : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                          Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<ProfileProvider>(
                          context)
                          .isLoading
                          ? CustomButton(
                          onTap: () {
                            if (Provider.of<ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .company_name ==
                                null &&
                                _comName.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      getTranslated(
                                          'insert_com',
                                          context)),
                                  backgroundColor:
                                  ColorResources
                                      .RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .vat_number ==
                                null &&
                                _vatNum.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      getTranslated(
                                          'insert_vat',
                                          context)),
                                  backgroundColor:
                                  ColorResources
                                      .RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .commerical_number ==
                                null &&
                                _comNun.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      getTranslated(
                                          'insert_com_num',
                                          context)),
                                  backgroundColor:
                                  ColorResources
                                      .RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .commerical_photo ==
                                null &&
                                fileCom == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      getTranslated(
                                          'insert_com_photo',
                                          context)),
                                  backgroundColor:
                                  ColorResources
                                      .RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .natinal_photo ==
                                null &&
                                fileNat == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      getTranslated(
                                          'insert_nat_photo',
                                          context)),
                                  backgroundColor:
                                  ColorResources
                                      .RED));
                            } else if (Provider.of<
                                ProfileProvider>(
                                context,
                                listen: false)
                                .userInfoModelBuisness
                                .vat_certificate_photo ==
                                null &&
                                fileVAt == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(
                                      getTranslated(
                                          'insert_vat_photo',
                                          context)),
                                  backgroundColor:
                                  ColorResources
                                      .RED));
                            } else {
                              _updateUserAccountComm();
                            }
                          },
                          buttonText: getTranslated(
                              'UPDATE_ACCOUNT', context))
                          : Center(
                          child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<
                                  Color>(
                                  Theme.of(context)
                                      .primaryColor))),
                    )
                        : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child:
                      !Provider.of<ProfileProvider>(context).isLoading
                          ? CustomButton(
                          onTap: _updateUserAccount,
                          buttonText: getTranslated(
                              'UPDATE_ACCOUNT', context))
                          : Center(
                          child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Theme.of(context)
                                      .primaryColor))),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
