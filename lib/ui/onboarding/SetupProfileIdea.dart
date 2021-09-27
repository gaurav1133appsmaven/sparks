import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/models/RegisterationModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/LoginScreen.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'dart:io';
import 'package:sparks/utils/Helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetupProfileIdea extends StatefulWidget {
  @override
  _SetupProfileIdeaState createState() => _SetupProfileIdeaState();
}

class _SetupProfileIdeaState extends State<SetupProfileIdea> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool firstStatechecked = true;
  bool secondStatechecked = false;
  bool thirdStatechecked = false;
  bool fourthStatechecked = false;
  bool fifthStatechecked = false;
  double lowerbound = 1.0;
  double upperBound = 12.0;
  String no_ideas = "0";

  var showloader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.onBoardingColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
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
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Last one!",
                                      style: TextStyle(
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                          fontWeight: FontWeight.w900,
                                          fontSize: ScreenUtil().setSp(40.0)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(50),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(40)),
                                    child: Text(
                                      "Time frame you have the most free time?",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(26),
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setHeight(20),
                                        horizontal: ScreenUtil().setWidth(10)),
                                    child: Stack(
                                      children: [
                                        FlutterSlider(
                                          values: [lowerbound, upperBound],
                                          max: 24,
                                          min: 1,
                                          trackBar: FlutterSliderTrackBar(
                                            activeTrackBarHeight: 5,
                                            inactiveTrackBar: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: AppColors.colorPrimary,
                                              border: Border.all(
                                                  width: 3,
                                                  color: Colors.black54),
                                            ),
                                            activeTrackBar: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: AppColors.colorAccent),
                                          ),
                                          tooltip: FlutterSliderTooltip(
                                              custom: (value) {
                                                return Text(
                                                    value.round().toString());
                                              },
                                              alwaysShowTooltip: true),
                                          rangeSlider: true,
                                          onDragCompleted: (_, lower, upper) {
                                            print("~~~" + lower.toString());
                                            print("###" + upper.toString());
                                            setState(() {
                                              lowerbound = lower;
                                              upperBound = upper;
                                            });
                                          },
                                          rightHandler: FlutterSliderHandler(
                                              decoration: BoxDecoration(),
                                              child: Image.asset(
                                                  "assets/images/ic_slidermarker.png")),
                                          handler: FlutterSliderHandler(
                                              decoration: BoxDecoration(),
                                              child: Image.asset(
                                                  "assets/images/ic_slidermarker.png")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Text("0",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                              Spacer(),
                                              Text("24",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(10),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(40)),
                                    child: Text(
                                      AppStrings.TITLE_NO_OF_IDEAS,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(26),
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    AppColors.colorPrimary,
                                                value: firstStatechecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    no_ideas = "0";
                                                    firstStatechecked = true;
                                                    secondStatechecked = false;
                                                    thirdStatechecked = false;
                                                    fourthStatechecked = false;
                                                    fifthStatechecked = false;
                                                  });
                                                }),
                                             Text("0",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    AppColors.colorPrimary,
                                                value: secondStatechecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    no_ideas = "1-3";
                                                    firstStatechecked = false;
                                                    secondStatechecked = true;
                                                    thirdStatechecked = false;
                                                    fourthStatechecked = false;
                                                    fifthStatechecked = false;
                                                  });
                                                }),
                                             Text("1-3",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    AppColors.colorPrimary,
                                                value: thirdStatechecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    no_ideas = "4-7";
                                                    firstStatechecked = false;
                                                    secondStatechecked = false;
                                                    thirdStatechecked = true;
                                                    fourthStatechecked = false;
                                                    fifthStatechecked = false;
                                                  });
                                                }),
                                             Text("4-7",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    AppColors.colorPrimary,
                                                value: fourthStatechecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    no_ideas = "8-14";
                                                    firstStatechecked = false;
                                                    secondStatechecked = false;
                                                    thirdStatechecked = false;
                                                    fourthStatechecked = true;
                                                    fifthStatechecked = false;
                                                  });
                                                }),
                                             Text("8-14",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    AppColors.colorPrimary,
                                                value: fifthStatechecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    no_ideas = "15+";
                                                    firstStatechecked = false;
                                                    secondStatechecked = false;
                                                    thirdStatechecked = false;
                                                    fourthStatechecked = false;
                                                    fifthStatechecked = true;
                                                  });
                                                }),
                                             Text("15+",style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
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
                                              fontFamily:
                                                  AppFonts.FONTFAMILY_ROBOTO,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  ScreenUtil().setSp(44.0)),
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
                                        if (false) {
                                        } else {
                                          Helpers.checkInternet().then((value) {
                                            if (value) {
                                              setState(() {
                                                showloader = true;
                                              });
                                              submitData(
                                                  no_ideas,
                                                  lowerbound.round().toString(),
                                                  upperBound.round().toString(),
                                                  context);
                                            } else {
                                              ReusableWidgets.showInfo(
                                                  _scaffoldKey,
                                                  context,
                                                  AppStrings
                                                      .INTERNET_NOT_CONNECTED);
                                            }
                                          });

                                          //
                                          //
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => HomeScreen()));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Finished",
                                          style: TextStyle(
                                              color: AppColors.NextButton_color,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: AppFonts
                                                  .FONTFAMILY_ROBOTO_BOLD,
                                              fontSize:
                                                  ScreenUtil().setSp(44.0)),
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
                      // if (showloader)
                      //   Align(
                      //     alignment: Alignment.center,
                      //     child: Center(
                      //       child:    CircularProgressIndicator(
                      //           backgroundColor: AppColors.colorPrimary,
                      //           valueColor: AlwaysStoppedAnimation<Color>(
                      //               AppColors.colorAccent)),
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ),
            ),
            if (showloader)
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppColors.colorPrimary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                ),
              )
          ],
        ));
  }

  void submitData(String no_ideas, String lowerTimeBound, String upperTimeBound,
      BuildContext context) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "first_name": Helpers.prefrences.getString(AppStrings.T_FirstName),
      "last_name": Helpers.prefrences.getString(AppStrings.T_LastName),
      "phone_no": Helpers.prefrences.getString(AppStrings.T_Phone),
      "country": Helpers.prefrences.getString(AppStrings.T_country),
      "state": Helpers.prefrences.getString(AppStrings.T_state),
      "user_name": Helpers.prefrences.getString(AppStrings.USER_USERNAME),
      "email": Helpers.prefrences.getString(AppStrings.USER_EMAIL),
      "city": Helpers.prefrences.getString(AppStrings.T_city),
      "birth_date": Helpers.prefrences.getString(AppStrings.T_dob),
      "ethnicity": Helpers.prefrences.getString(AppStrings.T_ethnicity),
      "gender": Helpers.prefrences.getString(AppStrings.T_gender),
      "status_type": Helpers.prefrences.getString(AppStrings.T_enterprenur),
      "occupation": Helpers.prefrences.getString(AppStrings.T_occupation),
      "interests": Helpers.prefrences.getString(AppStrings.T_interest),
      "min_free_time": lowerTimeBound,
      "max_free_time": upperTimeBound,
      "ideas_for_months": no_ideas,
      "image": ""
    };

    debugPrint(data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.ONBOARDING,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    setState(() {
      showloader = false;
    });
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = RegisterationModel.fromJson(response.data);
      if (result.status == 200) {
        if (result.success == 1) {
          Helpers.prefrences.setBool(AppStrings.USER_LOGGEDIN, true);
          Helpers.prefrences.setString(AppStrings.USER_ID, result.data.id);
          Helpers.prefrences
              .setString(AppStrings.USER_EMAIL, result.data.email);
          Helpers.prefrences
              .setString(AppStrings.USER_FIRSTNAME, result.data.firstName);
          Helpers.prefrences
              .setString(AppStrings.USER_LASTNAME, result.data.lastName);
          Helpers.prefrences
              .setString(AppStrings.USER_USERNAME, result.data.username);
          Helpers.prefrences.setString(AppStrings.USER_IMAGE, result.data.image);
          Helpers.prefrences
              .setString(AppStrings.USER_PHONE, result.data.phoneNo);
          //  Helpers.prefrences.setString(AppStrings.USER_PASSWORD, r.data.);
          Helpers.prefrences
              .setString(AppStrings.USER_COUNTRY, result.data.country);
          Helpers.prefrences
              .setString(AppStrings.USER_STATE, result.data.state);
          Helpers.prefrences.setString(AppStrings.USER_CITY, result.data.city);
          Helpers.prefrences
              .setString(AppStrings.USER_BIRTHDAY, result.data.birthDate);
          Helpers.prefrences
              .setString(AppStrings.USER_ETHNICITY, result.data.ethnicity);
          Helpers.prefrences
              .setString(AppStrings.USER_GENDER, result.data.gender);
          Helpers.prefrences
              .setString(AppStrings.USER_STATUS, result.data.statusType);
          Helpers.prefrences.setString(
              AppStrings.USER_MONTHLY_IDEAS, result.data.ideasForMonths);
          Helpers.prefrences
              .setString(AppStrings.USER_MINFREETIME, result.data.minFreeTime);
          Helpers.prefrences
              .setString(AppStrings.USER_MAXFREETIME, result.data.maxFreeTime);
          Helpers.prefrences
              .setString(AppStrings.USER_OCCUPATION, result.data.occupation);
          Helpers.prefrences
              .setString(AppStrings.USER_INTEREST, result.data.interests);
          if (result.data.inviteStatus == "0") {
            var data = {
              "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
            };

            debugPrint(data.toString());
            var response = await Dio()
                .post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_INVITE_STATUS,
                    options: Options(headers: {
                      HttpHeaders.contentTypeHeader: "application/json",
                    }),
                    data: jsonEncode(data));

            if (response.statusCode == 200) {
              var result = RegisterationModel.fromJson(response.data);
              if (result.status == 200) {
                if (result.success == 1) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                selectPage: 0,
                              )),
                      (Route<dynamic> route) => true);
                }
              }
            }
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          selectPage: 0,
                        )),
                (Route<dynamic> route) => true);
          }
        } else {
          ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
        }
      }

      // return LoginModel.fromJson(response.data);
    } else {
      ReusableWidgets.showInfo(_scaffoldKey, context, "Something went wrong!");
    }
  }
}
