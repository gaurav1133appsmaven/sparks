import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/ui/onboarding/SetupProfilePhone.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';

class SetUpName extends StatefulWidget {
  @override
  _SetupProfileNameState createState() => _SetupProfileNameState();
}

class _SetupProfileNameState extends State<SetUpName> {
  TextEditingController firstnameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.onBoardingColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(40)),
                  child: Text(
                    AppStrings.SETUP_PROFILE,
                    style: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                        fontWeight: FontWeight.w900,
                        fontSize: ScreenUtil().setSp(40.0)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(50),
                      vertical: ScreenUtil().setHeight(6)),
                  child: Text(
                    "First Name",
                    style: TextStyle(color: AppColors.onboardingTextColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(50)),
                  child: TextField(
                    controller: firstnameController,
                    textCapitalization: TextCapitalization.sentences,
                    cursorHeight: 20,
                    style: TextStyle(
                      fontFamily: AppFonts.FONTFAMILY_ROBOTO
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: AppStrings.FIRST_NAME_HINT,

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        hintStyle: TextStyle(color: AppColors.backgoundLight,  fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(50),
                      vertical: ScreenUtil().setHeight(6)),
                  child: Text("Last Name",
                      style: TextStyle(color: AppColors.onboardingTextColor,  fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(50)),
                  child: TextField(
                    controller: lastNameController,
                    textCapitalization: TextCapitalization.sentences,
                    cursorHeight: 20,
                    style: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: AppStrings.LAST_NAME_HINT,

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 2.0),
                        ),
                        hintStyle: TextStyle(color: AppColors.backgoundLight,  fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(40),
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    if (firstnameController.text == "") {
                    } else if (lastNameController.text == "") {
                    } else {
                      Helpers.prefrences.setString(
                          AppStrings.T_FirstName, firstnameController.text);
                      Helpers.prefrences.setString(
                          AppStrings.T_LastName, lastNameController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetupProfilePhone()));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: AppColors.NextButton_color,
                          fontWeight: FontWeight.w900,
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                          fontSize: ScreenUtil().setSp(44.0)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
