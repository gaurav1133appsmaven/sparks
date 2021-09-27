import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sparks/models/MyProfileModel.dart';
import 'package:sparks/ui/DetailedAdd.dart';
import 'package:sparks/ui/Limit1Screen.dart';
import 'package:sparks/ui/Limit2Screen.dart';
import 'package:sparks/ui/QuickAdd.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:dio/dio.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  var ideasCount = 0;
  var limit = 0;

  int canAddIdea = 0;

  bool canEnter=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.onBoardingColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add idea".toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
          ),
        ),
        body: AbsorbPointer(
          absorbing: !canEnter,
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                width: ScreenUtil().setHeight(600),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(20),
                    horizontal: ScreenUtil().setHeight(10),
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.backgoundLight,
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            if (canAddIdea == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => Limit1Screen()));
                            } else if (canAddIdea == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => Limit2Screen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuickAdd()));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                            decoration: BoxDecoration(
                                color: AppColors.colorAccent,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                AppStrings.QUICK_ADD.toUpperCase(),
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                    fontSize: ScreenUtil().setSp(48)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        InkWell(
                          onTap: () {
                            if (canAddIdea == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => Limit1Screen()));
                            } else if (canAddIdea == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => Limit2Screen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailedAdd()));
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                            decoration: BoxDecoration(
                                color: AppColors.colorAccent,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                AppStrings.DETAILED_ADD.toUpperCase(),
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                    fontSize: ScreenUtil().setSp(48)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getIdeasCount().then((value) {
      ideasCount = int.parse(value.data.createdIdeasCount);
      limit = int.parse(value.data.ideasLimit);
      if (ideasCount == 5 && limit == 0) {
        canAddIdea = 1;
      } else if (ideasCount == 10 && limit == 1) {
        canAddIdea = 2;
      } else {
        canAddIdea = 0;
      }

      setState(() {
        canEnter=true;
      });
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   showDialog(
    //       useSafeArea: true,
    //       barrierDismissible: false,
    //       context: (context),
    //       builder: (builder) =>
    //           SizedBox(
    //             height: ScreenUtil().setHeight(200),
    //             child: Dialog(
    //                 child: Container(
    //               color: AppColors.colorPrimary,
    //               child: Padding(
    //                 padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: [
    //                     InkWell(
    //                       onTap: () {
    //                         Navigator.pushReplacement(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => QuickAdd()));
    //                       },
    //                       child: Container(
    //                         padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
    //                         color: AppColors.colorAccent,
    //                         child: Center(
    //                           child: Text(
    //                             AppStrings.QUICK_ADD,
    //                             style: TextStyle(color: AppColors.white),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: ScreenUtil().setHeight(20),
    //                     ),
    //                     InkWell(
    //                       onTap: () {
    //                         Navigator.pushReplacement(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) => DetailedAdd()));
    //                       },
    //                       child: Container(
    //                         padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
    //                         color: AppColors.colorAccent,
    //                         child: Center(
    //                           child: Text(
    //                             AppStrings.DETAILED_ADD,
    //                             style: TextStyle(color: AppColors.white),
    //                           ),
    //                         ),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             )),
    //           ));
    // });
  }

  Future<MyProfileModel> getIdeasCount() async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
    };

    print("data isss" + data.toString());
    var response =
    await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_PROFILE,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = MyProfileModel.fromJson(response.data);
      if (result.status == 200) {
        return MyProfileModel.fromJson(response.data);
      }

      return MyProfileModel.fromJson(response.data);
    } else {}
  }
}