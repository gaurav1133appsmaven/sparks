import 'package:flutter/material.dart';
import 'package:sparks/ui/onboarding/SetupProfileLocation.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';

class SetupProfilePhone extends StatefulWidget {
  @override
  _SetupProfilePhoneState createState() => _SetupProfilePhoneState();
}

class _SetupProfilePhoneState extends State<SetupProfilePhone> {
  var phoneController = new MaskedTextController(mask: '000-000-0000');
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
                      vertical: ScreenUtil().setHeight(40),
                    ),
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
                    child: Text("Phone Number",  style: TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50)),
                    child: TextField(
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      cursorHeight: 20,
                      style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "###-###-####",

                          hintStyle: TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO)
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Back",
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(44.0)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.black,
                          height: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (phoneController.text == "") {
ReusableWidgets.showInfo(_scaffoldKey, context, "Please enter phone number");
                              }
                              else if(phoneController.text.length<12)
                                {
                                  ReusableWidgets.showInfo(_scaffoldKey, context, "Mobile number is invalid");
                                }

                              else
                                {

                                  Helpers.prefrences
                                      .setString(AppStrings.T_Phone, phoneController.text);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetupProfileLocation()));
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
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
