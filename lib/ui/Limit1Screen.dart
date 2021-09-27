import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:sparks/models/QuestionsModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/ReusableWidgets.dart';

class TileData {
  TileData(this.tileName, this.tileValue);

  String tileName;
  bool tileValue;
}

class Limit1Screen extends StatefulWidget {
  @override
  _Limit1ScreenState createState() => _Limit1ScreenState();
}

class _Limit1ScreenState extends State<Limit1Screen> {
  List<TileData> inputs = new List<TileData>();
  List<TileData> inputs2 = new List<TileData>();
  String firstQuestion = "";
  String secondQuestion = "";
  String firstAnswer = "";
  String secondAnswer = "";

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getQuestions().then((value) {
      firstQuestion = value.data[0].question;

      secondQuestion = value.data[1].question;
      for (int i = 0; i < value.data[0].options.length; i++) {
        inputs.add(TileData(value.data[0].options[i], false));
      }
      for (int i = 0; i < value.data[1].options.length; i++) {
        inputs2.add(TileData(value.data[1].options[i], false));
      }

      setState(() {});
    });

    super.initState();
  }

  void ItemChange(bool val, int index) {
    for (int i = 0; i < inputs.length; i++) {
      if (index == i) {
        inputs[i].tileValue = val;
      } else {
        inputs[i].tileValue = false;
      }
    }
    setState(() {});
  }

  void ItemChange2(bool val, int index) {
    setState(() {
      inputs2[index].tileValue = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.onBoardingColor,
          body: inputs.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setHeight(20)),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Text("Idea Limit Reached",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: ScreenUtil().setSp(36),
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD)),
                      Text("Way to go!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: ScreenUtil().setSp(44),
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20)),
                        child: Text(
                            "Increase your limit to 10 ideas by answering these 2 questions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.black,
                                fontSize: ScreenUtil().setSp(36),
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Text(firstQuestion,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.colorAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(30),
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD)),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: 20, maxHeight: 300),
                        child: ListView.builder(
                            itemCount: inputs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  CheckboxListTile(
                                      value: inputs[index].tileValue,
                                      title: new Text(
                                        inputs[index].tileName,
                                        style: TextStyle(
                                            fontFamily:
                                                AppFonts.FONTFAMILY_ROBOTO),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (bool val) {
                                        ItemChange(val, index);
                                      })
                                ],
                              );
                            }),
                      ),
                      Text(
                        secondQuestion,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.colorAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(30),
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD),
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: 20, maxHeight: 330),
                        child: ListView.builder(
                            itemCount: inputs2.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return new Column(
                                children: <Widget>[
                                  new CheckboxListTile(
                                      value: inputs2[index].tileValue,
                                      title: new Text(
                                        inputs2[index].tileName,
                                        style: TextStyle(
                                            fontFamily:
                                                AppFonts.FONTFAMILY_ROBOTO),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      onChanged: (bool val) {
                                        int count = 0;
                                        for (int i = 0;
                                            i < inputs2.length;
                                            i++) {
                                          if (inputs2[i].tileValue) {
                                            count++;
                                          }
                                        }

                                        if (count >= 3) {
                                          var checkCount = 0;
                                          for (int i = 0;
                                              i < inputs2.length;
                                              i++) {
                                            if (inputs2[i].tileValue &&
                                                checkCount == 0) {
                                              {
                                                inputs2[i].tileValue = false;
                                                checkCount++;
                                              }
                                            }
                                          }
                                          setState(() {});
                                          ReusableWidgets.showInfo(
                                              _scaffoldKey,
                                              context,
                                              "You can select max 3 options");
                                        } else {
                                          ItemChange2(val, index);
                                        }
                                      })
                                ],
                              );
                            }),
                      ),
                      Divider(
                        color: AppColors.black,
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "No Thanks",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: ScreenUtil().setSp(40),
                                      fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () async {
                                  firstAnswer = "";
                                  for (int i = 0; i < inputs.length; i++) {
                                    if (inputs[i].tileValue) {
                                      firstAnswer = firstAnswer +
                                          inputs[i].tileName +
                                          ",";
                                    }
                                  }

                                  secondAnswer = "";
                                  var count = 0;
                                  for (int i = 0; i < inputs2.length; i++) {
                                    if (inputs2[i].tileValue) {
                                      count++;
                                      secondAnswer = secondAnswer +
                                          inputs2[i].tileName +
                                          ",";
                                    }
                                  }
                                  if (count < 3) {
                                    ReusableWidgets.showInfo(_scaffoldKey,
                                        context, "Please select 3 values.");
                                    return "";
                                  } else if (firstAnswer == "" ||
                                      secondAnswer == "") {
                                    ReusableWidgets.showInfo(
                                        _scaffoldKey,
                                        context,
                                        "Please select your answers before submit.");
                                    return "";
                                  }

                                  debugPrint("***" + firstAnswer);
                                  debugPrint("***2 " + secondAnswer);

                                  var data = {
                                    "user_id": Helpers.prefrences
                                        .getString(AppStrings.USER_ID),
                                    "milestone": "1",
                                    "question_1": "1",
                                    "answer_1": firstAnswer,
                                    "question_2": "2",
                                    "answer_2": secondAnswer
                                  };

                                  var response = await Dio().post(
                                      ApiEndpoints.BASE_URL +
                                          ApiEndpoints.ADD_ANSWERS,
                                      options: Options(headers: {
                                        HttpHeaders.contentTypeHeader:
                                            "application/json",
                                      }),
                                      data: jsonEncode(data));
                                  if (response.statusCode == 200) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: (context),
                                        builder: (builder) => Dialog(
                                          backgroundColor: AppColors.onBoardingColor,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: ScreenUtil()
                                                        .setHeight(20),
                                                  ),
                                                  Text(
                                                    "Thank you for your feedback!",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM,
                                                        fontSize: ScreenUtil()
                                                            .setSp(36)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "You can now add up to\n5 more ideas.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: AppFonts
                                                              .FONTFAMILY_ROBOTO,
                                                          fontSize: ScreenUtil()
                                                              .setSp(32)),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    color: AppColors
                                                        .STATUS_BACKGROUND,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    HomeScreen(
                                                                        selectPage:
                                                                            2)),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                true);
                                                      },
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .NextButton_color,
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO_MEDIUM,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(36)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
                                    // ReusableWidgets.showInfo(
                                    //     _scaffoldKey,
                                    //     context,
                                    //     "Your limit has been extended to 10 posts.");
                                    //
                                    // Future.delayed(Duration(seconds: 1), () {
                                    //   Navigator.of(context).pushAndRemoveUntil(
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               HomeScreen(selectPage: 2)),
                                    //       (Route<dynamic> route) => false);
                                    // });

                                    return SimpleResponse.fromJson(
                                        response.data);
                                  }
                                },
                                child: Text("Submit",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.NextButton_color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(40),
                                        fontFamily:
                                            AppFonts.FONTFAMILY_ROBOTO_BOLD))),
                          )
                        ],
                      )
                    ],
                  )),
                )),
    );
  }

  Future<QuestionsModel> getQuestions() async {
    // var id = await prefs.getUserid();
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "milestone": "1"
    };

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_QUESTIONS,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.data.toString());

      return QuestionsModel.fromJson(response.data);
    }
  }
}
