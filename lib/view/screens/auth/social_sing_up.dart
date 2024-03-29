import 'dart:convert';

import 'package:country_code_picker/country_code.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/auth/widget/code_picker_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/condition_check_box.dart';
import 'package:efood_multivendor/view/screens/auth/widget/guest_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SocialSingUp extends StatefulWidget {
  String mail;
  String name;
  String social_id;
  String tel;
  SocialSingUp({this.mail,this.tel,this.name,this.social_id});
  @override
  _SocialSingUpState createState() => _SocialSingUpState();
}

class _SocialSingUpState extends State<SocialSingUp> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _firstNameController.text=widget.name;
    _emailController.text=widget.mail;
    _countryDialCode = CountryCode.fromCountryCode(
        Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Container(
                  width: context.width > 700 ? 700 : context.width,
                  padding: context.width > 700
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                      : null,
                  decoration: context.width > 700
                      ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                    BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[Get.isDarkMode ? 700 : 300],
                          blurRadius: 5,
                          spreadRadius: 1)
                    ],
                  )
                      : null,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Column(children: [
                      Image.asset(Images.logo, width: 100),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      Text('sign_up'.tr.toUpperCase(),
                          style: robotoBlack.copyWith(fontSize: 30)),
                      SizedBox(height: 50),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 800 : 200],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Column(children: [
                          CustomTextField(
                            hintText: 'first_name'.tr,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _emailFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            prefixIcon: Images.user,
                            divider: true,
                          ),
                          CustomTextField(
                            hintText: 'email'.tr,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _phoneFocus,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: Images.mail,
                            divider: true,
                          ),
                          Row(children: [
                            CodePickerWidget(
                              onChanged: (CountryCode countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              initialSelection: _countryDialCode,
                              favorite: [_countryDialCode],
                              showDropDownButton: true,
                              padding: EdgeInsets.zero,
                              showFlagMain: true,
                              textStyle: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context).textTheme.bodyText1.color,
                              ),
                            ),
                            Expanded(
                                child: CustomTextField(
                                  hintText: 'phone'.tr,
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  inputType: TextInputType.phone,
                                  divider: false,
                                )),
                          ]),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Divider(height: 1)),
                        ]),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      ConditionCheckBox(authController: authController),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      !authController.isLoading
                          ? Row(children: [
                        Expanded(
                            child: CustomButton(
                              buttonText: 'sign_in'.tr,
                              transparent: true,
                              onPressed: () => Get.toNamed(
                                  RouteHelper.getSignInRoute(RouteHelper.signUp)),
                            )),
                        Expanded(
                            child: CustomButton(
                              buttonText: 'sign_up'.tr,
                              onPressed: authController.acceptTerms
                                  ? () =>
                                  _register(authController, _countryDialCode)
                                  : null,
                            )),
                      ])
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: 30),
                      GuestButton(),
                    ]);
                  }),
                ),
              ),
            ),
          )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();

    String _numberWithCountryCode = countryCode + _number;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
        await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_name'.tr);
    }  else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }  else {
      String isim = _firstName.replaceAll(_firstName.split(" ").last, "");
      SignUpBody signUpBody = SignUpBody(
          fName: isim,
          lName: _firstName.split(" ").last,
          email: _email,
          social_id: widget.social_id,
          phone: _numberWithCountryCode,);
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(widget.social_id);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode,
                status.message, RouteHelper.signUp, _data,_email,widget.social_id));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      }).onError((error, stackTrace) {
        print("hataa: ${error}");
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: Text(
              "${error}",
            ),
          ),
          barrierDismissible: true,
        );
      });
    }
  }
}
