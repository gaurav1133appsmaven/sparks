import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/ui/onboarding/SetupProfileIdea.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';

class SetupProfileOccupation extends StatefulWidget {
  @override
  _SetupProfileOccupationState createState() => _SetupProfileOccupationState();
}

class _SetupProfileOccupationState extends State<SetupProfileOccupation> {
  var aspiringSelected = true;

  TextEditingController interestController = TextEditingController();
  TextEditingController occupationController = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var status = AppStrings.Aspiring_Enterpreneur;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.onBoardingColor,
                borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(40),
                                horizontal: ScreenUtil().setWidth(10)),
                            child: Text(
                              AppStrings.ALMOST_DONE,
                              style: TextStyle(
                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                  fontWeight: FontWeight.w900,
                                  fontSize: ScreenUtil().setSp(40.0)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(6)),
                            child: Text(
                              "Status",
                              style: TextStyle(color: AppColors.onboardingTextColor ,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: ScreenUtil().setHeight(60),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      status = AppStrings.Aspiring_Enterpreneur;
                                      aspiringSelected = !aspiringSelected;
                                    });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: aspiringSelected
                                              ? Colors.white
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                          AppStrings.Aspiring_Enterpreneur,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(26),
                                              fontFamily: AppFonts
                                                  .FONTFAMILY_ROBOTO_MEDIUM,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center)),
                                )),
                                Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            status = AppStrings.Entrepreneur;
                                            aspiringSelected =
                                                !aspiringSelected;
                                          });
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: aspiringSelected
                                                    ? null
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              AppStrings.Entrepreneur,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(26),
                                                  fontFamily: AppFonts
                                                      .FONTFAMILY_ROBOTO_MEDIUM,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ))))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(6)),
                            child: Text("Occupation",
                                style:
                                    TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                          ),
                          TextField(
                            controller: occupationController,
                            textCapitalization: TextCapitalization.sentences,
                            cursorHeight: 20,
                            style:
                            TextStyle(color: AppColors.black,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter occupation",
                              hintStyle:
                                  TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(6)),
                            child: Text("Interests",
                                style:
                                    TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                          ),
                          TextField(
                            controller: interestController,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 4,
                            cursorHeight: 20,
                              style:
                              TextStyle(color: AppColors.black,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Photography,Hiking...",
                              hintStyle:
                                  TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.white, width: 2.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),
                        ],
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
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                      fontSize: ScreenUtil().setSp(44.0)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.black,
                            height: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (occupationController.text == "") {
                                  ReusableWidgets.showInfo(_scaffoldKey,
                                      context, "Please enter occupation");
                                } else if (interestController.text == "") {
                                  ReusableWidgets.showInfo(_scaffoldKey,
                                      context, "Please enter interests");
                                } else {
                                  Helpers.prefrences.setString(
                                      AppStrings.T_enterprenur, status);
                                  Helpers.prefrences.setString(
                                      AppStrings.T_occupation,
                                      occupationController.text);
                                  Helpers.prefrences.setString(
                                      AppStrings.T_interest,
                                      interestController.text);

                                  debugPrint("!!!!!! " + status);
                                  debugPrint(
                                      "!!!!!! " + interestController.text);
                                  debugPrint(
                                      "!!!!!! " + occupationController.text);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetupProfileIdea()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                      color: AppColors.NextButton_color,
                                      fontWeight: FontWeight.w900,
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_BOLD,
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
          ),
        ),
      ),
    );
  }
}
