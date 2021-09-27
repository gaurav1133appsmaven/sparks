import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _textEditingController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/images/ic_close.png",color: AppColors.white,),),
        backgroundColor: AppColors.colorPrimary,
        title: Text(
          "Forgot Password",
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(20)),
                  child: Text(
                    "Enter email",
                    style: TextStyle(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                        fontSize: ScreenUtil().setSp(36)),
                  ),
                ),
                TextField(
                    controller: _textEditingController,

                    cursorHeight: 20,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                    decoration: new InputDecoration(
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
                      hintText:"Enter your email",
                      hintStyle:
                          TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                      errorStyle:
                          TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                    )),
                SizedBox(
                  height: ScreenUtil().setHeight(40),
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: AppColors.colorPrimaryDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.all(18),
                    onPressed: () {
                      if (_textEditingController.text == "") {
                        ReusableWidgets.showInfo(
                            _scaffoldKey, context, "Please enter an email.");
                      } else {
                        setState(() {
                          showProgress = true;
                        });
                        sendForgetEmail(_textEditingController.text)
                            .then((value) {





                          setState(() {
                            showProgress = false;
                          });


                          if(value.status==201)
                            {
                              ReusableWidgets.showInfo(_scaffoldKey, context,
                                  value.message);
                              return;
                            }

           Future.delayed(Duration(seconds: 2),(){

             Navigator.pop(context);
           });
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              value.message);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: null))
                        });
                      }
                    },
                    child: Text(
                      "SEND",
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(30),
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showProgress)
            Align(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: AppColors.colorPrimary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
              ),
            ),
        ],
      ),
    );
  }

  Future<SimpleResponse> sendForgetEmail(String email) async {
    // var id = await prefs.getUserid();
    var data = {"email": email};

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.FORGOT_PASSWORD,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.data.toString());

      return SimpleResponse.fromJson(response.data);
    }
  }
}
