import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:sparks/ui/FullscreenImage.dart';
import 'package:sparks/ui/Limit1Screen.dart';
import 'package:sparks/ui/Limit2Screen.dart';
import 'package:sparks/ui/QuickAdd.dart';
import 'package:sparks/utils/BottomSheetView.dart';
import 'package:sparks/utils/NetworkCalls.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sparks/models/QuickIdeaModel.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/Helpers.dart';
import 'dart:async';
import 'package:record_mp3/record_mp3.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailedAdd extends StatefulWidget {
  @override
  _DetailedAddState createState() => _DetailedAddState();
}

class _DetailedAddState extends State<DetailedAdd> {
  String statusText = "";
  bool isComplete = false;
  String voiceMsg = "";
  double _personalInterest = 4.0;
  double _personalPriority = 2.0;
  String solutionSelected = AppStrings.VITAMIN;
  bool vitaminSelected = true;
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  List<String> _notesList = List<String>();
  final picker = ImagePicker();
  var _attachedMedia = List<String>();
  String gallery = "";
  List<TextEditingController> _controllers = new List();
  String _todoList = "";

  String imageCover = "";
  var titleController = TextEditingController();

  var descriptionController = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showloader = false;

  var _memosList = List();
  String formattedDate = "";
  ScrollController _scrollController;
  var showPremiumData = false;
  var height=0.0;

  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-dd-yyyy');
    formattedDate = formatter.format(now);
    _scrollController = ScrollController();
    super.initState();
  }
  Future<bool> _onWillPop() {
    return     showDialog(
        context: context,
        builder: (build) =>
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                      10)),
              child: Column(
                mainAxisSize:
                MainAxisSize
                    .min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors
                            .colorPrimary,
                        borderRadius: BorderRadius.only(
                            topRight:
                            Radius.circular(
                                10),
                            topLeft:
                            Radius.circular(10))),
                    padding: EdgeInsets.all(
                        ScreenUtil()
                            .setHeight(
                            20)),
                    child: Center(
                      child: Text(
                        "Alert!",
                        style: TextStyle(
                            fontFamily:
                            AppFonts
                                .FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight:
                            FontWeight
                                .w700,
                            color: AppColors
                                .white,
                            fontSize:
                            ScreenUtil().setSp(36)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        ScreenUtil()
                            .setHeight(
                            30)),
                    child: Text(
                      AppStrings.EXIT_MESSAGE,textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily:
                          AppFonts
                              .FONTFAMILY_ROBOTO,fontSize: ScreenUtil().setSp(32)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil()
                            .setHeight(
                            20)),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          InkWell(
                            onTap:
                                () async {
                              Navigator.pop(
                                  context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());



                            },
                            child:
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child:
                              Text(
                                "No",
                                textAlign:
                                TextAlign.center,
                                style:
                                TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                          InkWell(
                            onTap:
                                () async {
                              Navigator.pop(
                                  context);

                              Navigator.pop(context,"0");


                            },
                            child:
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child:
                              Text(
                                "Yes",
                                textAlign:
                                TextAlign.center,
                                style:
                                TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    height=  MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()=>_onWillPop(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (build) =>
                          Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    10)),
                            child: Column(
                              mainAxisSize:
                              MainAxisSize
                                  .min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors
                                          .colorPrimary,
                                      borderRadius: BorderRadius.only(
                                          topRight:
                                          Radius.circular(
                                              10),
                                          topLeft:
                                          Radius.circular(10))),
                                  padding: EdgeInsets.all(
                                      ScreenUtil()
                                          .setHeight(
                                          20)),
                                  child: Center(
                                    child: Text(
                                      "Alert!",
                                      style: TextStyle(
                                          fontFamily:
                                          AppFonts
                                              .FONTFAMILY_ROBOTO_MEDIUM,
                                          fontWeight:
                                          FontWeight
                                              .w700,
                                          color: AppColors
                                              .white,
                                          fontSize:
                                          ScreenUtil().setSp(36)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      ScreenUtil()
                                          .setHeight(
                                          30)),
                                  child: Text(
                                    AppStrings.EXIT_MESSAGE,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                        AppFonts
                                            .FONTFAMILY_ROBOTO,fontSize: ScreenUtil().setSp(32)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil()
                                          .setHeight(
                                          20)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:
                                        InkWell(
                                          onTap:
                                              () async {
                                            Navigator.pop(
                                                context);
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());



                                          },
                                          child:
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child:
                                            Text(
                                              "No",
                                              textAlign:
                                              TextAlign.center,
                                              style:
                                              TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child:
                                        InkWell(
                                          onTap:
                                              () async {
                                            Navigator.pop(
                                                context);

                                            Navigator.pop(context,"0");


                                          },
                                          child:
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child:
                                            Text(
                                              "Yes",
                                              textAlign:
                                              TextAlign.center,
                                              style:
                                              TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                  );
                },
                child: Image.asset(
                  "assets/images/ic_close.png",
                  color: Colors.white,
                  scale: 1.4,
                )),
            centerTitle: true,
            title: Text(
              AppStrings.TITLE_DETAILED_IDEA,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
            ),
          ),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: AppColors.colorPrimary,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(30),
                                      ),
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(20)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: ScreenUtil().setWidth(60)),
                                        child: Text(
                                          AppStrings.DETAIL_NOTE_DESCRIPTION,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily:
                                                  AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                              fontSize: ScreenUtil().setSp(44)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(6),
                                      ),
                                      Text(
                                        "* Indicates required information",
                                        style: TextStyle(
                                            color: AppColors.black,
                                            fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "",
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontFamily: AppFonts
                                                    .FONTFAMILY_ROBOTO_MEDIUM),
                                            children: [
                                              TextSpan(
                                                  text: " Gold ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.YELLOW,
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO_MEDIUM)),
                                              TextSpan(
                                                  text:
                                                      "Text indicates highly recommended fields",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO)),
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(100),
                                vertical: ScreenUtil().setHeight(10)
                              ),
                              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                              child: ButtonTheme(
                                minWidth: ScreenUtil().setWidth(200),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setHeight(28),
                                  ),
                                  onPressed: () async {


                                    if(showloader)
                                      {

                                        return;
                                      }
                                    if (titleController.text == "") {
                                      ReusableWidgets.showInfo(_scaffoldKey,
                                          context, "Please enter title");
                                      return;
                                    } else if (titleController.text
                                        .startsWith(" ")) {
                                      setState(() {
                                        titleController.text =
                                            titleController.text.trimLeft();
                                      });

                                      return;
                                    } else if (descriptionController.text.trim() ==
                                        "") {
                                      ReusableWidgets.showInfo(_scaffoldKey,
                                          context, "Please enter description");
                                      return;
                                    } else if (descriptionController.text
                                        .startsWith(" ")) {
                                      setState(() {
                                        descriptionController.text =
                                            descriptionController.text.trimLeft();
                                      });

                                      return;
                                    }

                                    // Navigator.pop(context);

                                    if (_controllers.isNotEmpty) {

                                      _todoList = "";
                                      for (int i = 0;
                                          i < _controllers.length;
                                          i++) {


                                        if (_controllers[i].text.toString() ==
                                            null) {
                                        } else if (_controllers[i]
                                                .text
                                                .toString() ==
                                            "") {
                                        } else {
                                          // _todoList
                                          //     .add(_controllers[i].text.toString());

                                          _todoList = _todoList +
                                              _controllers[i].text.toString() +"date"+formattedDate+
                                              "*sparks#";
                                        }
                                      }

                                      if (_controllers.isNotEmpty)
                                        _todoList = _todoList.substring(
                                            0, _todoList.length - 8);
                                    } else {
                                      print("Controller list is empty");
                                    }

                                    if (_attachedMedia.isNotEmpty) {
                                      for (int i = 0;
                                          i < _attachedMedia.length;
                                          i++) {
                                        gallery = gallery + _attachedMedia[i] + ",";
                                      }
                                    }



                                    if (_memosList.isNotEmpty) {
                                      for (int i = 0; i < _memosList.length; i++) {
                                        voiceMsg = voiceMsg + _memosList[i]+"date"+formattedDate + ",";
                                      }
                                    }


                                    debugPrint("datewithmemo "+voiceMsg);



                                    if (_memosList.isNotEmpty)
                                      voiceMsg = voiceMsg.substring(
                                          0, voiceMsg.length - 1);

                                    if (_attachedMedia.isNotEmpty)
                                      gallery =
                                          gallery.substring(0, gallery.length - 1);

                                    // if (imageCover == null) {
                                    //   ReusableWidgets.showInfo(_scaffoldKey,
                                    //       context, "Please select a cover image.");
                                    //   return;
                                    // }

                                    try {
                                      _todoList =
                                          _todoList.substring(0, _todoList.length);
                                    } on Exception catch (e) {
                                      _todoList = "";
                                    }

                                    var data = {
                                      "user_id": Helpers.prefrences
                                          .getString(AppStrings.USER_ID),
                                      "insert_type": "Detailed Add",
                                      "title": titleController.text.toString(),
                                      "cover_image": imageCover,
                                      "voice_message": voiceMsg,
                                      "description": descriptionController.text,
                                      "gallery": gallery,
                                      "notes": _todoList,
                                      "interest": _personalInterest.toString(),
                                      "priority": _personalPriority.toString(),
                                      "solution_type": solutionSelected
                                    };

                                    print(data.toString());

                                    bool result = await Helpers.checkInternet();
                                    if (result) {
                                      setState(() {
                                        showloader = true;
                                      });
                                    } else {
                                      ReusableWidgets.showInfo(
                                          _scaffoldKey,
                                          context,
                                          AppStrings.INTERNET_NOT_CONNECTED);
                                      return;
                                    }

                                    var response = await Dio().post(
                                        ApiEndpoints.BASE_URL +
                                            ApiEndpoints.ADD_IDEAS,
                                        options: Options(headers: {
                                          HttpHeaders.contentTypeHeader:
                                              "application/json",
                                        }),
                                        data: jsonEncode(data));
                                    setState(() {
                                      showloader = false;
                                    });

                                    if (response.statusCode == 200) {
                                      debugPrint("response getting raw data= " +
                                          response.data.toString());
                                      var result =
                                          QuickIdeaModel.fromJson(response.data);
                                      // if (result.limit == "0") {
                                      //   Navigator.pushReplacement(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (c) => Limit1Screen()));
                                      //   return;
                                      // } else if (result.limit == "1") {
                                      //   Navigator.pushReplacement(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (c) => Limit2Screen()));
                                      //   return;
                                      // }
                                      if (result.status == 200) {
                                        if (result.success == 1) {
                                          Future.delayed(const Duration(seconds: 0),
                                              () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                HomeScreen(
                                                                    selectPage: 0)),
                                                    (Route<dynamic> route) =>
                                                        true);
                                          });

                                          ReusableWidgets.showInfo(
                                              _scaffoldKey,
                                              context,
                                              "Your idea is added successfully!");
                                        } else {
                                          ReusableWidgets.showInfo(_scaffoldKey,
                                              context, result.message);
                                        }
                                      }

                                      // return LoginModel.fromJson(response.data);
                                    } else {
                                      ReusableWidgets.showInfo(_scaffoldKey,
                                          context, "Something went wrong!");
                                    }
                                  },
                                  color: AppColors.colorAccent,
                                  child: Text(
                                    "SAVE",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(40),
                                        fontFamily:
                                            AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16)),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Idea Title *",
                                  style: TextStyle(
                                      color: AppColors.YELLOW,
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                )),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            DottedBorder(
                              dashPattern: [8, 4],
                              strokeWidth: 1,
                              child: TextField(
                                controller: titleController,
                                cursorHeight: 20,
                                style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                textInputAction: TextInputAction.done,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 6.0),
                                  hintText: "Text...",
                                  hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(20)),
                              width: ScreenUtil().setWidth(300),
                              height: 2,
                              color: Colors.black,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cover Photo",
                                      style: TextStyle(
                                          color: AppColors.YELLOW,
                                          fontWeight: FontWeight.w700,
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                    ),
                                  ],
                                )),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () async {
                                        getCover(ImageSource.gallery);
                                      },
                                      child: SizedBox(
                                          height: ScreenUtil().setHeight(60),
                                          width: ScreenUtil().setHeight(60),
                                          child: Image.asset(
                                            "assets/images/ic_addgallery.png",
                                            fit: BoxFit.contain,
                                          )),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () async {
                                        getCover(ImageSource.camera);
                                      },
                                      child: Container(
                                          height: ScreenUtil().setHeight(60),
                                          width: ScreenUtil().setHeight(60),
                                          child: Image.asset(
                                            "assets/images/ic_camera.png",
                                            fit: BoxFit.contain,
                                            color: Colors.black,
                                          )),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Preview",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: AppFonts
                                                  .FONTFAMILY_ROBOTO_MEDIUM),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (imageCover == "") {
                                                ReusableWidgets.showInfo(
                                                    _scaffoldKey,
                                                    context,
                                                    "Please select a cover image first.");
                                                return;
                                              }

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (cont) =>
                                                          FullscreenImage(
                                                            image: imageCover,
                                                          )));
                                              // showDialog(
                                              //     context: (context),
                                              //     builder: (context) => Dialog(
                                              //           child:
                                              //               Image.network(imageCover,
                                              //               fit: BoxFit.cover,),
                                              //         ));
                                            },
                                            child: Container(
                                                height: ScreenUtil().setHeight(90),
                                                width: ScreenUtil().setWidth(150),
                                                color: AppColors.colorAccent,
                                                child: imageCover == ""
                                                    ? Container(
                                                        height: ScreenUtil()
                                                            .setHeight(60),
                                                        child: Center(
                                                            child: Image.asset(
                                                          "assets/images/ic_imageplaceholder.png",
                                                          color: AppColors.white,
                                                        )))
                                                    : Image.network(
                                                        imageCover,
                                                        fit: BoxFit.cover,
                                                      )

                                                // Image.asset(
                                                //   "assets/images/ic_profile.png",
                                                //   fit: BoxFit.contain,
                                                // )
                                                //

                                                )),
                                      ],
                                    ))
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(20)),
                              width: ScreenUtil().setWidth(300),
                              height: 2,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Description*",
                                  style: TextStyle(
                                      color: AppColors.YELLOW,
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                )),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            DottedBorder(
                              dashPattern: [8, 4],
                              strokeWidth: 1,
                              child: TextField(
                                controller: descriptionController,
                                textCapitalization: TextCapitalization.sentences,
                                cursorHeight: 20,
                                maxLines: 4,
                                style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(6.0),
                                  hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                  enabledBorder: null,
                                  focusColor: null,
                                  hintText: "Text...",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(20)),
                              width: ScreenUtil().setWidth(300),
                              height: 2,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Photos",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                )),
                            Container(
                              height: ScreenUtil().setHeight(150),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (build) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(10),
                                                                topRight:
                                                                    Radius.circular(
                                                                        10)),
                                                        color:
                                                            AppColors.colorPrimary,
                                                      ),
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setHeight(20)),
                                                      child: Center(
                                                        child: Text(
                                                          "Add Photo",
                                                          style: TextStyle(
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_ROBOTO_MEDIUM,
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                              color:
                                                                  AppColors.white,
                                                              fontSize: ScreenUtil()
                                                                  .setSp(36)),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setHeight(30)),
                                                      child: Text(
                                                        "Choose Image Source",
                                                        style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO,
                                                            fontSize: ScreenUtil()
                                                                .setSp(30)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: ScreenUtil()
                                                              .setHeight(20)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: InkWell(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        new FocusNode());

                                                                getImage(ImageSource
                                                                    .camera);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  "Camera",
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: AppFonts
                                                                          .FONTFAMILY_ROBOTO),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: InkWell(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        new FocusNode());

                                                                getImage(ImageSource
                                                                    .gallery);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  "Gallery",
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontFamily: AppFonts
                                                                          .FONTFAMILY_ROBOTO),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: Container(
                                      height: ScreenUtil().setHeight(120),
                                      width: 80,
                                      child: Image.asset(
                                        "assets/images/ic_addgallery.png",
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) => Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(
                                                    ScreenUtil().setHeight(10)),
                                                height: 70,
                                                width: 70,

                                                child: CachedNetworkImage(
                                    imageUrl:  _attachedMedia[index],
                                      imageBuilder:
                                          (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setHeight(10))),
                                            ),
                                          ),
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _attachedMedia
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  child: ClipOval(
                                                      child: Container(
                                                          color: AppColors
                                                              .colorPrimary,
                                                          child: Icon(
                                                            Icons.close,
                                                            color: AppColors.white,
                                                            size: ScreenUtil()
                                                                .setHeight(30),
                                                          )))),
                                            )
                                          ],
                                        ),
                                      ),
                                      itemCount: _attachedMedia.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Notes/Memos",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () {}, child: Icon(Icons.info_outline))
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxHeight: 2000, minHeight: 2.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (itemBuilder, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: ScreenUtil().setHeight(4),top: ScreenUtil().setHeight(4)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.0),
                                          child: DottedBorder(
                                            dashPattern: [8, 4],
                                            strokeWidth: 1,
                                            child: TextField(
                                              controller: _controllers[index],
                                              textCapitalization:
                                              TextCapitalization.sentences,
                                              style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                EdgeInsets.only(left: 6.0),
                                                hintText: "Text...",
                                                hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                           _notesList.removeAt(index);
                                           _controllers.removeAt(index);
                                              });
                                            },
                                            child: ClipOval(
                                                child: Container(
                                                    color: AppColors
                                                        .colorPrimary,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: AppColors.white,
                                                      size: ScreenUtil()
                                                          .setHeight(30),
                                                    )))),
                                      )


                                    ],
                                  );
                                },
                                itemCount: _notesList.length,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _controllers.add(new TextEditingController());
                                  _notesList.add("");
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: AppColors.colorAccent,
                                  ),
                                  Text(
                                    "Add Text Field",
                                    style: TextStyle(
                                        color: AppColors.colorAccent,
                                        fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(4),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxHeight: 2000, minHeight: 2.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (itemBuilder, index) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "memo ${index + 1} ($formattedDate)",
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFonts.FONTFAMILY_ROBOTO),
                                          ),
                                          Spacer(),
                                          InkWell(
                                              onTap: () async {
                                                var data =
                                                    await showModalBottomSheet(
                                                  context: context,
                                                  builder: (_) => BottomSheetView(
                                                    path: _memosList[index],
                                                  ),
                                                );
                                                debugPrint(
                                                    "forarams " + data.toString());
                                              },
                                              child: Image.asset(
                                                  "assets/images/ic_play.png")),
                                          InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (build) => Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight: Radius
                                                                          .circular(
                                                                              10)),
                                                                  color: AppColors
                                                                      .colorPrimary,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .all(ScreenUtil()
                                                                        .setHeight(
                                                                            20)),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Alert",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            AppFonts
                                                                                .FONTFAMILY_ROBOTO_MEDIUM,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: AppColors
                                                                            .white,
                                                                        fontSize: ScreenUtil()
                                                                            .setSp(
                                                                                36)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .all(ScreenUtil()
                                                                        .setHeight(
                                                                            30)),
                                                                child: Text(
                                                                  "Are you sure you want to delete this memo?",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .FONTFAMILY_ROBOTO,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(
                                                                                  34)),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical:
                                                                        ScreenUtil()
                                                                            .setHeight(
                                                                                20)),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          FocusScope.of(
                                                                                  context)
                                                                              .requestFocus(
                                                                                  new FocusNode());
                                                                        },
                                                                        child: Text(
                                                                          "No",
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: TextStyle(
                                                                              fontFamily:
                                                                                  AppFonts.FONTFAMILY_ROBOTO),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          InkWell(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          FocusScope.of(
                                                                                  context)
                                                                              .requestFocus(
                                                                                  new FocusNode());

                                                                          setState(
                                                                              () {
                                                                            _memosList
                                                                                .removeAt(index);
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                          "Yes",
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: TextStyle(
                                                                              fontFamily:
                                                                                  AppFonts.FONTFAMILY_ROBOTO),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ));

                                                // showDialog(
                                                //     context: context,
                                                //     builder: (build) => AlertDialog(
                                                //           title: Text("Alert",
                                                //               style: TextStyle(
                                                //                   fontFamily: AppFonts
                                                //                       .FONTFAMILY_ROBOTO)),
                                                //           content: Text(
                                                //             "Do you really want to delete this memo?",
                                                //             style: TextStyle(
                                                //                 fontFamily: AppFonts
                                                //                     .FONTFAMILY_ROBOTO),
                                                //           ),
                                                //           actions: [
                                                //             InkWell(
                                                //               onTap: () {
                                                //                 Navigator.pop(
                                                //                     context);
                                                //                 FocusScope.of(
                                                //                         context)
                                                //                     .requestFocus(
                                                //                         new FocusNode());
                                                //               },
                                                //               child: Text("No",
                                                //                   style: TextStyle(
                                                //                       fontFamily:
                                                //                           AppFonts
                                                //                               .FONTFAMILY_ROBOTO)),
                                                //             ),
                                                //             InkWell(
                                                //               onTap: () {
                                                //                 Navigator.pop(
                                                //                     context);
                                                //                 FocusScope.of(
                                                //                         context)
                                                //                     .requestFocus(
                                                //                         new FocusNode());
                                                //
                                                //                 setState(() {
                                                //                   _memosList
                                                //                       .removeAt(
                                                //                           index);
                                                //                 });
                                                //               },
                                                //               child: Text("Yes",
                                                //                   style: TextStyle(
                                                //                       fontFamily:
                                                //                           AppFonts
                                                //                               .FONTFAMILY_ROBOTO)),
                                                //             )
                                                //           ],
                                                //         ));
                                              },
                                              child: Image.asset(
                                                  "assets/images/ic_delete.png")),
                                        ],
                                      ));
                                },
                                itemCount: _memosList.length,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() async {
                                  var data = await showModalBottomSheet(
                                    context: context,
                                    builder: (_) => MyBottomSheet(),
                                  );

                                  if (data != null) {
                                    uploadFile(data).then((value) {
                                      setState(() {
                                        _memosList.add(value);
                                      });
                                    });
                                  }

                                  // _memosList.add("");
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: AppColors.colorAccent,
                                  ),
                                  Text(
                                    "Add memo",
                                    style: TextStyle(
                                        color: AppColors.colorAccent,
                                        fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(20)),
                              width: ScreenUtil().setWidth(300),
                              height: 2,
                              color: Colors.black,
                            ),
                            Row(
                              children: [
                                Text("Personal Interest",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            AppFonts.FONTFAMILY_ROBOTO_MEDIUM)),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Center(
                                              child: Text(
                                                AppStrings.YourPersonalInterest,
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.FONTFAMILY_ROBOTO),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.grey,
                                      size: ScreenUtil().setHeight(24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "${_personalInterest.round()}/10",
                                      style: TextStyle(
                                          fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                    )),
                                FlutterSlider(
                                  values: [_personalInterest],
                                  max: 10,
                                  min: 1,
                                  onDragCompleted: (_, lower, upper) {
                                    setState(() {
                                      _personalInterest = lower;
                                    });
                                  },
                                  trackBar: FlutterSliderTrackBar(
                                    activeTrackBarHeight: 5,
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black12,
                                      border: Border.all(
                                          width: 3, color: Colors.black54),
                                    ),
                                    activeTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.colorPrimary),
                                  ),
                                  tooltip: FlutterSliderTooltip(
                                      custom: (value) {
                                        return Text(
                                          value.round().toString(),
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFonts.FONTFAMILY_ROBOTO),
                                        );
                                      },
                                      alwaysShowTooltip: true),
                                  handler: FlutterSliderHandler(
                                    decoration: BoxDecoration(),
                                    child: Image.asset(
                                        "assets/images/ic_slidermarker.png"),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(AppStrings.PersonalPriority,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            AppFonts.FONTFAMILY_ROBOTO_MEDIUM)),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                    size: ScreenUtil().setHeight(24),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "${_personalPriority.round()}/10",
                                      style: TextStyle(
                                          fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                    )),
                                FlutterSlider(
                                  values: [_personalPriority],
                                  max: 10,
                                  min: 1,
                                  onDragCompleted: (_, lower, upper) {
                                    setState(() {
                                      _personalPriority = lower;
                                    });
                                  },
                                  trackBar: FlutterSliderTrackBar(
                                    activeTrackBarHeight: 5,
                                    inactiveTrackBar: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black12,
                                      border: Border.all(
                                          width: 3, color: Colors.black54),
                                    ),
                                    activeTrackBar: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.colorPrimary),
                                  ),
                                  tooltip: FlutterSliderTooltip(
                                      custom: (value) {
                                        return Text(
                                          value.round().toString(),
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFonts.FONTFAMILY_ROBOTO),
                                        );
                                      },
                                      alwaysShowTooltip: true),
                                  handler: FlutterSliderHandler(
                                    decoration: BoxDecoration(),
                                    child: Image.asset(
                                        "assets/images/ic_slidermarker.png"),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(4)),
                              child: Align(
                                child: Text(
                                  AppStrings.SolutionType,
                                  style: TextStyle(
                                      color: AppColors.YELLOW,
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(10)),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border:
                                      Border.all(color: AppColors.onBoardingColor),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(50))),
                              height: ScreenUtil().setHeight(80),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        solutionSelected = AppStrings.VITAMIN;
                                        vitaminSelected = !vitaminSelected;
                                      });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: vitaminSelected
                                                ? AppColors.colorAccent
                                                : null,
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setWidth(50))),
                                        child: Text(AppStrings.VITAMIN,
                                            style: TextStyle(
                                                fontSize: ScreenUtil().setSp(26),
                                                fontFamily: AppFonts
                                                    .FONTFAMILY_ROBOTO_MEDIUM,
                                                fontWeight: FontWeight.w700,
                                                color: vitaminSelected
                                                    ? AppColors.white
                                                    : AppColors.colorAccent),
                                            textAlign: TextAlign.center)),
                                  )),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              solutionSelected =
                                                  AppStrings.PAINKILLER;
                                              vitaminSelected = !vitaminSelected;
                                            });
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: vitaminSelected
                                                      ? null
                                                      : AppColors.colorAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ScreenUtil()
                                                              .setWidth(50))),
                                              child: Text(
                                                AppStrings.PAINKILLER,
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(26),
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO_MEDIUM,
                                                    fontWeight: FontWeight.w700,
                                                    color: vitaminSelected
                                                        ? AppColors.colorAccent
                                                        : AppColors.white),
                                                textAlign: TextAlign.center,
                                              ))))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            if (!showPremiumData)
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    debugPrint("height is"+height.toString());
                                    setState(() {
                                      showPremiumData = true;

                                    });
                                    Future.delayed(Duration(milliseconds:200 ),(){


                                      Helpers.showPremiumContent(_scrollController,height+ScreenUtil().setHeight(600));

                                    })
;
                                  },
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(180),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                          "assets/images/ic_downarrow.png"),
                                    ),
                                  ),
                                ),
                              ),
                            if (showPremiumData)
                              Stack(children: [
                                Image.asset("assets/images/ic_premium.png"),
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                showPremiumData = false;
                                              });
                                            },
                                            child: SizedBox(
                                              width: ScreenUtil().setWidth(180),
                                              child: Image.asset(
                                                  "assets/images/ic_uparrow.png"),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setWidth(30),
                                              vertical: ScreenUtil().setHeight(20)),
                                          child: Text(
                                            "Upgrade to Premium for\nAdditional Content Fields.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppColors.YELLOW,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: AppFonts.CAIRO_BOLD,
                                                fontSize: ScreenUtil().setSp(40)),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(40)),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              onPressed: () {
                                                NetworkCalls.upgradeToPremium();
                                                showDialog(
                                                    context: (context),
                                                    builder: (b) => Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          backgroundColor: AppColors
                                                              .Dialog_background,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(8.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize.min,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8.0),
                                                                  child: Align(
                                                                    alignment: Alignment
                                                                        .centerRight,
                                                                    child: SizedBox(
                                                                      width: ScreenUtil()
                                                                          .setWidth(
                                                                              60),
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              60),
                                                                      child:
                                                                          InkWell(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Image
                                                                            .asset(
                                                                                "assets/images/ic_cross.png"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Thank you for showing your interest!",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .CAIRO_SEMIBOLD,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(
                                                                                  56),
                                                                      color: AppColors
                                                                          .backgoundLight),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .all(ScreenUtil()
                                                                          .setHeight(
                                                                              30)),
                                                                  child: Image.asset(
                                                                      "assets/images/ic_emoji.png"),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          ScreenUtil()
                                                                              .setWidth(
                                                                                  30)),
                                                                  child: Text(
                                                                    "Unfortunately premium\nfeatures are still being\ndeveloped.",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            AppFonts
                                                                                .CAIRO_REGULAR,
                                                                        fontSize: ScreenUtil()
                                                                            .setSp(
                                                                                40),
                                                                        color: AppColors
                                                                            .BUTTONTEXT_YELLOW),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      ScreenUtil()
                                                                          .setHeight(
                                                                              30),
                                                                ),
                                                                Text(
                                                                  "We are working to make a better experience.Please try this feature again later.",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .CAIRO_REGULAR,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(
                                                                                  34),
                                                                      color: AppColors
                                                                          .backgoundLight),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      ScreenUtil()
                                                                          .setHeight(
                                                                              40),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                              },
                                              padding: EdgeInsets.all(
                                                  ScreenUtil().setHeight(30)),
                                              color: AppColors.black,
                                              child: Text(
                                                "Upgrade Now (\$2.99/Month)"
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: AppColors
                                                        .VOTING_SPACE_BACKGROUND,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        ScreenUtil().setSp(30),
                                                    fontFamily:
                                                        AppFonts.FONTFAMILY_ROBOTO),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                              ])
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (showloader)
                  Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AppColors.colorPrimary,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getCover(ImageSource sourcevalue) async {
    setState(() {
      showloader = true;
    });
    final pickedFile = await picker.getImage(source: sourcevalue);

    if (pickedFile != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );
        print("response data is");
        print("from2" + response.secureUrl);
        imageCover = response.secureUrl;
        setState(() {});
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }
    }
    setState(() {
      showloader = false;
    });
  }

  Future<String> uploadFile(String file) async {
    if (file != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file,
              resourceType: CloudinaryResourceType.Raw),
        );
        print("response data is");
        print("from2" + response.secureUrl);

        return response.secureUrl;
      } on Exception catch (e) {
        print("from2 " + e.toString());
        return null;
      }
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      try {
        setState(() {
          showloader=true;
        });
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );
        print("response data is");
        print("from2" + response.secureUrl);
        _attachedMedia.add(response.secureUrl);
        setState(() {
          showloader=false;

        });
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }
    }
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      RecordMp3.instance.stop();
      // if (recordFilePath != null) {
      //   uploadFile(recordFilePath);
      // }

      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  String recordFilePath;

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);


    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record1";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${Random().nextInt(1000)}.mp3";
  }
}
