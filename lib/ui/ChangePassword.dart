import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sparks/models/QuestionsModel.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:dio/dio.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var currentPass = TextEditingController();
  var newPass = TextEditingController();
  var confirmNewPass = TextEditingController();
  var obscure1 = true;
  var obscure2 = true;
  var obscure3 = true;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLoader=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/images/ic_close.png",
              color: Colors.white,
              scale: 1.4,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        Stack(
          children: [

            Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                title("Enter current Password"),
                TextField(
                  controller: currentPass,
                  obscureText: obscure1,
                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                  decoration: InputDecoration(
                      hintText: "Enter current password",
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                      hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye), onPressed: () {
                        obscure1 = !obscure1;
                        setState(() {

                        });
                      },)
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                title("Enter New Password"),
                TextField(
                  controller: newPass,
                  obscureText: obscure2,
                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                      hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                      hintText: "Enter new password",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye), onPressed: () {
                        obscure2 = !obscure2;

                        setState(() {

                        });
                      },)
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                title("Confirm New Password"),
                TextField(
                  controller: confirmNewPass,
                  obscureText: obscure3,
                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                      hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,),
                      hintText: "Confirm new password",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye), onPressed: () {
                        obscure3 = !obscure3;
                        setState(() {

                        });
                      },)
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)
                    ),
                    color: AppColors.colorAccent,
                    onPressed: () {
                      if (currentPass.text == "") {
                        ReusableWidgets.showInfo(
                            _scaffoldKey, context, "Current password is empty!");
                      } else if (newPass.text == "") {
                        ReusableWidgets.showInfo(
                            _scaffoldKey, context, "New Password is empty!");
                      } else if (confirmNewPass.text == "") {
                        ReusableWidgets.showInfo(
                            _scaffoldKey, context, "Confirm Password is empty!");
                      }
                      // else if (currentPass.text != "old pass") {
                      //   //check old password matches or not
                      //   ReusableWidgets.showInfo(_scaffoldKey, context,
                      //       "Current passwrod entered is incorrect!");
                      // }
                      else if (newPass.text != confirmNewPass.text) {
                        //check new and confirm pass is equal
                        ReusableWidgets.showInfo(_scaffoldKey, context,
                            "New password doesn't match with confirm password");
                      } else {
                        Helpers.checkInternet().then((value) {
                          if (!value) {
                            ReusableWidgets.showInfo(_scaffoldKey, context,
                                "Internet not connected!");
                            return;
                          }
                          setState(() {
                            showLoader=true;
                          });
                          FocusScope.of(
                              context)
                              .requestFocus(
                              new FocusNode());
                          changePassword(newPass.text, currentPass.text).then((
                              value) {
                            showLoader=false;
                            setState(() {

                            });
                            if (value.status != 200) {
                              ReusableWidgets.showInfo(_scaffoldKey, context,
                                  value.message);
                              return;
                            }
                            ReusableWidgets.showInfo(_scaffoldKey, context,
                                value.message);
                            Future.delayed(Duration(seconds: 2), () {

                              Navigator.pop(context);
                            });
                          });
                        });
                      }
                    },
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: ScreenUtil().setSp(36),
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
            if (showLoader)
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppColors.colorPrimary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.colorAccent)),
                ),
              ),
          ],
        )


      ),
    );
  }

  Widget title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: AppFonts.FONTFAMILY_ROBOTO,
            color: AppColors.backgoundLight,
            fontSize: ScreenUtil().setSp(32)),
      ),
    );
  }

  Future<QuestionsModel> changePassword(String newPassword,
      String oldPassword) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "old_password": oldPassword,
      "new_password": newPassword
    };

    var result =
    await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_PASSWORD,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data));

    if (result.statusCode == 200) {
      //set new password in shared prefrences
      return QuestionsModel.fromJson(result.data);
    }
  }
}
