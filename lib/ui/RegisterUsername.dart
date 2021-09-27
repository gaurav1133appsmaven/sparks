import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/bloc/RegisterationBloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/models/RegisterModel.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:sparks/ui/onboarding/SetUpName.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterUsername extends StatelessWidget {
  String email;
  String password;
  final _registerationBloc = RegisterationBloc();
  TextEditingController _questionnaire = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  RegisterUsername(this.email, this.password);

  @override
  Widget build(BuildContext context) {
    _registerationBloc.emailChanged(email);
    _registerationBloc.passwordChanged(password);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: ImageIcon(
                            AssetImage("assets/images/ic_close.png"),
                            color: AppColors.colorPrimary)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(60)),
                      child: Text(
                        AppStrings.REGISTER,
                        style: TextStyle(
                            color: AppColors.colorAccent,
                            fontSize: ScreenUtil()
                                .setSp(60)),
                      ),
                    ),


            StreamBuilder(
              stream: _registerationBloc.username,
              builder: (context, snapshot) {
                return
                  TextField(
                      controller: _questionnaire,


                      onChanged: _registerationBloc.usernameChanged,
                      cursorHeight: 20,
                      onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        new BlacklistingTextInputFormatter(new RegExp('[ ]')),
                      ],
                      style: TextStyle(
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO
                      ),

                      decoration: new InputDecoration(
                        errorText: snapshot.error,

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColors.colorPrimary, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColors.colorPrimary, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColors.colorPrimary, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColors.colorPrimary, width: 2.0),
                        ),
                        hintStyle: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO
                        ),
                        errorStyle: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO
                        ),
                        hintText: AppStrings.USERNAME_HINT,
                      ));
              },
            ),

                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding: EdgeInsets.all(18),
                        onPressed: () async {
                          if (_registerationBloc.validateUsername() == null) {
                            print(
                                "user name.........${_registerationBloc.username}");

                           RegisterModel result= await _registerationBloc.registerUser();
                           if(result.status!=200)
                             {
                               ReusableWidgets.showInfo(_scaffoldKey, context,
                                  result.message);
                             }
                           else{
                             Navigator.of(context).pushAndRemoveUntil(
                                 MaterialPageRoute(
                                     builder: (context) => SetUpName()),
                                 (Route<dynamic> route) => true);
                           }


                          } else {

                            ReusableWidgets.showInfo(_scaffoldKey, context,
                                _registerationBloc.validateUsername());
                          }
                        },
                        color: AppColors.colorPrimaryDark,
                        child: Text(
                          AppStrings.SIGNUP,
                          style: TextStyle(
                              color: AppColors.white,
                              fontFamily: AppFonts.Comfortaa_SemiBold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "By signing up, you agree to Spark's ",
                          style: TextStyle(
                              color: AppColors.black,
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                          children: [
                            TextSpan(
                                text: "Terms of Service",
                                recognizer: new TapGestureRecognizer()..onTap = () async{
                                  Helpers.openUrl(ApiEndpoints.TERMS_OF_SERVICE);

                                },
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.black,
                                )),
                            TextSpan(
                                text: " and ",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                            TextSpan(
                                text: "Privacy Policy",
                                recognizer: new TapGestureRecognizer()..onTap = () async{
                               Helpers.openUrl(ApiEndpoints.PRIVACY_POLICY);

                                },
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.black,

                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                          ]),
                    )
                  ],
                ),
                Positioned(
                    child: Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: StreamBuilder(
                      stream: _registerationBloc.showLoader,
                      builder: (context, snapshot) {

                        return snapshot.data
                            ? CircularProgressIndicator(
                                backgroundColor: AppColors.colorPrimary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.colorAccent))
                            : SizedBox();
                      },
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
