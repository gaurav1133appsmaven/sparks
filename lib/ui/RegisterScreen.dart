import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/bloc/RegisterationBloc.dart';
import 'package:sparks/models/RegisterModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:sparks/utils/SparksTextField.dart';
import 'package:dio/dio.dart';
import 'RegisterUsername.dart';


import 'package:rxdart/src/streams/value_stream.dart';




class RegisterScreen extends StatefulWidget {


  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerationBloc = RegisterationBloc();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscuretext = true;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
bool showloader=false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        body:
        Stack(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ImageIcon(AssetImage("assets/images/ic_close.png"),color: AppColors.colorPrimary)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(60)),
                        child: Text(
                          AppStrings.REGISTER,
                          style: TextStyle(
                              color: AppColors.colorAccent,

                              fontSize:
                              ScreenUtil().setSp(70)),
                        ),
                      ),
                      SparksTextField(
                          _registerationBloc.email,
                          _emailController,
                          _registerationBloc.emailChanged,
                          AppStrings.EMAIL_HINT,
                          TextInputType.emailAddress),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),

                      StreamBuilder(
                        stream: _registerationBloc.password,
                        builder: (context, snapshot) {
                          return TextField(
                              controller: _passwordController,
                              onChanged: _registerationBloc.passwordChanged,
                              obscureText: _obscuretext,
                              cursorHeight: 20,
                              style: TextStyle(  fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD,),
                              inputFormatters: [
                                new BlacklistingTextInputFormatter(
                                    new RegExp(' ')),
                              ],
                              onEditingComplete: () =>
                                  FocusScope.of(context).nextFocus(),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: new InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _obscuretext
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.backgoundLight,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _obscuretext = !_obscuretext;
                                      });
                                    },
                                  ),
                                  errorText: snapshot.error,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.colorPrimary, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.colorPrimary, width: 2.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.colorPrimary, width: 2.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.colorPrimary, width: 2.0),
                                  ),
                                  hintText: AppStrings.PASSWORD_HINT,
                                  hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(30),
                                      fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD,



                                      fontWeight: FontWeight.w900
                                  )
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
                          onPressed: () {

                            moveToNext(context);
                          },
                          color: AppColors.colorPrimaryDark,
                          child: Text(
                            AppStrings.NEXT,
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if(showloader)Align(alignment: Alignment.center,


            child: CircularProgressIndicator(
                backgroundColor: AppColors.colorPrimary,
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colorAccent)),
            )
          ],


        ),
      ),
    );
  }
  Future<SimpleResponse> validateEmail(String email) async {
    var data = {"email": email};
    //   "device_token": Helpers.prefrences.getString(AppStrings.DEVICE_TOKEN)};
    //   "device_token": Helpers.prefrences.getString(AppStrings.DEVICE_TOKEN)};



    var response =
    await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.VALIDATE_EMAIL,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data));
    if (response.statusCode == 200) {

      debugPrint("!!!!"+response.data.toString());


      return SimpleResponse.fromJson(response.data);
    }
  }

  void moveToNext(BuildContext contxt) {
    if (_registerationBloc.validateFields() == null) {
      Helpers.checkInternet().then((value) {
        if (value) {
          setState(() {
            showloader=true;
          });
          validateEmail(_registerationBloc.m_email.value).then((value) {

            setState(() {
              showloader=false;
            });
if(value.status!=200)
  {

    ReusableWidgets.showInfo(_scaffoldkey, context, value.message);
    return;
  }
            Navigator.push(
                contxt,
                MaterialPageRoute(
                    builder: (ctxt) => RegisterUsername(
                        _registerationBloc.m_email.value,
                        _registerationBloc.m_password.value)));

          });



        } else {
          ReusableWidgets.showInfo(
              _scaffoldkey, contxt, AppStrings.INTERNET_NOT_CONNECTED);
        }
      });
    } else {
      ReusableWidgets.showInfo(
          _scaffoldkey, contxt, _registerationBloc.validateFields());
    }
  }
}



