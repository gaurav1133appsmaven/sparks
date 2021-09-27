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

class Limit2Screen extends StatefulWidget {
  @override
  _Limit1ScreenState createState() => _Limit1ScreenState();
}

class _Limit1ScreenState extends State<Limit2Screen> {
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
    debugPrint("valuedata " + index.toString());
    for (int i = 0; i < inputs2.length; i++) {
      if (index == i) {
        inputs2[i].tileValue = val;
      } else {
        inputs2[i].tileValue = false;
      }
    }
    setState(() {});
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
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(20),
                          top: ScreenUtil().setHeight(20)),
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
                                "Now you can go countless by answering only 2 more questions.",
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
                                  fontWeight: FontWeight.w700,
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
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Text(
                            secondQuestion,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.colorAccent,
                                fontWeight: FontWeight.w700,
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
                                            ItemChange2(val, index);
                                          })
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
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
                                    firstAnswer =
                                        firstAnswer + inputs[i].tileName + ",";
                                  }
                                }
                                debugPrint("***" + firstAnswer);

                                secondAnswer = "";
                                for (int i = 0; i < inputs2.length; i++) {
                                  if (inputs2[i].tileValue) {
                                    secondAnswer = secondAnswer +
                                        inputs2[i].tileName +
                                        ",";
                                  }
                                }
                                if (firstAnswer == "" || secondAnswer == "")
                                  ReusableWidgets.showInfo(
                                      _scaffoldKey,
                                      context,
                                      "Please select your answers before submit.");

                                debugPrint("***" + firstAnswer);
                                debugPrint("***2 " + secondAnswer);

                                var data = {
                                  "user_id": Helpers.prefrences
                                      .getString(AppStrings.USER_ID),
                                  "milestone": "2",
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
                                debugPrint("body " + response.toString());
                                if (response.statusCode == 200) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: (context),
                                      builder: (builder) => Dialog(
                                            backgroundColor:
                                                AppColors.onBoardingColor,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: ScreenUtil()
                                                      .setHeight(20),
                                                ),
                                                Text(
                                                  "SUBMISSION SUCCESSFULL",
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "You can now add as many ideas as you would like!",
                                                    textAlign: TextAlign.center,
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
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
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
                                                          fontSize: ScreenUtil()
                                                              .setSp(36)),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));

                                  return SimpleResponse.fromJson(response.data);
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
                    ),
                    Divider(
                      color: AppColors.black,
                      height: 1,
                    ),
                  ],
                ))),
    );
  }

  Future<QuestionsModel> getQuestions() async {
    // var id = await prefs.getUserid();
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "milestone": "2"
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
