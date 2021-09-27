import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sparks/models/QuickIdeaModel.dart';
import 'package:sparks/ui/FullscreenImage.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/Limit1Screen.dart';
import 'package:sparks/ui/Limit2Screen.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/BottomSheetView.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:sparks/utils/SessionManger.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:record_mp3/record_mp3.dart';
import 'methodcalls.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class QuickAdd extends StatefulWidget {
  @override
  _QuickAddState createState() => _QuickAddState();
}

class _QuickAddState extends State<QuickAdd> {
  String recordFilePath;

  bool isComplete = false;
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  SessionManager prefs = SessionManager();

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  final picker = ImagePicker();
  String userid, userEmail;
  String imageCover = "";
  bool showProgress = false;
  String memo = "";

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  bool voiceRecorded = false;

  var showPreview = false;
  String previewImage = "";

  @override
  void initState() {
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
    debugPrint(showProgress.toString());
    return WillPopScope(
        onWillPop: ()=>_onWillPop(),
      child: SafeArea(
        child: Scaffold(
          appBar:
          AppBar(
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
              "Add Quick Idea",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
            ),
          ),
          key: _scaffoldKey,
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(
                  ScreenUtil().setHeight(40),
                ),
                child: Stack(
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Title",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(36),
                                      fontFamily:
                                          AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                ),
                                Spacer(),
                                // Text("Preview",style: TextStyle(
                                //     fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                //     fontWeight: FontWeight.w800,
                                //     color: AppColors.colorAccent
                                // ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: titleController,
                                    cursorHeight: 20,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: TextStyle(color: Colors.black,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: AppColors.QUICK_IDEA_BACKGROUND,
                                      filled: true,
                                      hintText: "Enter title",
                                      hintStyle: TextStyle(color: Colors.black,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.QUICK_IDEA_BACKGROUND,
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.QUICK_IDEA_BACKGROUND,
                                            width: 2.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.QUICK_IDEA_BACKGROUND,
                                            width: 2.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.QUICK_IDEA_BACKGROUND,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      bool result = await Helpers.checkInternet();
                                      if (result) {
                                      } else {
                                        ReusableWidgets.showInfo(
                                            _scaffoldKey,
                                            context,
                                            AppStrings.INTERNET_NOT_CONNECTED);
                                        return;
                                      }

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
                                                          "Add Cover Image",
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

                                                                var pickedFile=null;
                                                                try{
   pickedFile =
  await picker.getImage(
      source: ImageSource
          .camera);
}
on Exception catch (e) {
  ReusableWidgets.showInfo(_scaffoldKey, context,
      "Last name can't be blank.");
                                                                  return;

}


                                                                if (pickedFile ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                try {
                                                                  setState(() {
                                                                    showProgress =
                                                                        true;
                                                                  });
                                                                  CloudinaryResponse
                                                                      response =
                                                                      await cloudinary
                                                                          .uploadFile(
                                                                    CloudinaryFile.fromFile(
                                                                        pickedFile
                                                                            .path,
                                                                        resourceType:
                                                                            CloudinaryResourceType
                                                                                .Image),
                                                                  );

                                                                  imageCover =
                                                                      response
                                                                          .secureUrl;
                                                                  previewImage =
                                                                      imageCover;
                                                                  showPreview =
                                                                      true;
                                                                  debugPrint("data " +
                                                                      imageCover);
                                                                  setState(() {
                                                                    showProgress =
                                                                        false;
                                                                  });
                                                                } on Exception catch (e) {
                                                                  setState(() {
                                                                    showProgress =
                                                                        false;
                                                                  });
                                                                }
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



                                                                final pickedFile =
                                                                    await picker.getImage(
                                                                        source: ImageSource
                                                                            .gallery);

                                                                if (pickedFile ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                try {
                                                                  setState(() {
                                                                    showProgress =
                                                                        true;
                                                                  });
                                                                  CloudinaryResponse
                                                                      response =
                                                                      await cloudinary
                                                                          .uploadFile(
                                                                    CloudinaryFile.fromFile(
                                                                        pickedFile
                                                                            .path,
                                                                        resourceType:
                                                                            CloudinaryResourceType
                                                                                .Image),
                                                                  );

                                                                  imageCover =
                                                                      response
                                                                          .secureUrl;
                                                                  previewImage =
                                                                      imageCover;
                                                                  showPreview =
                                                                      true;
                                                                  debugPrint("data " +
                                                                      imageCover);
                                                                  setState(() {
                                                                    showProgress =
                                                                        false;
                                                                  });
                                                                } on Exception catch (e) {
                                                                  setState(() {
                                                                    showProgress =
                                                                        false;
                                                                  });
                                                                }
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
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        width: ScreenUtil().setWidth(90),
                                        height: ScreenUtil().setHeight(90),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/ic_addgallery.png"))),
                                      ),
                                    )),
                                SizedBox(
                                  width: ScreenUtil().setWidth(20),
                                ),
                                if (showPreview)
                                  Column(
                                    children: [
                                      // Text(
                                      //   "Preview",
                                      //   style: TextStyle(
                                      //       fontFamily:
                                      //           AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                      //       fontWeight: FontWeight.w800,
                                      //       color: AppColors.colorAccent),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullscreenImage(
                                                        image: previewImage,
                                                      )));
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        },
                                        child: Container(
                                          width: ScreenUtil().setWidth(80),
                                          height: ScreenUtil().setHeight(70),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    previewImage,
                                                  ),
                                                  fit: BoxFit.fill)),
                                          child: CachedNetworkImage(
                                            imageUrl: previewImage,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: ScreenUtil().setWidth(250),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                                // borderRadius: BorderRadius.all(
                                                //     Radius.circular(
                                                //         ScreenUtil().setHeight(20))),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      AppColors.colorPrimary,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(
                                                          AppColors.colorAccent)),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(36),
                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          ScreenUtil().setHeight(20)),
                                      decoration: BoxDecoration(
                                          color: voiceRecorded
                                              ? AppColors.ARROW_COLOR
                                              : AppColors.colorAccent,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/images/ic_voice.png"),
                                          Builder(builder: (context) {
                                            String statusText = "";
                                            return StatefulBuilder(
                                                builder: (a, StateSetter setState) {
                                              return InkWell(
                                                onTap: () async {
                                                  String data =
                                                      await showModalBottomSheet(
                                                    context: context,
                                                    builder: (_) => MyBottomSheet(),
                                                  );

                                                  if (data != null) {
                                                    setState(() {
                                                      showProgress = true;
                                                    });
                                                    uploadFile(data).then((value) {
                                                      setState(() {
                                                        showProgress = false;

                                                        voiceRecorded = true;
                                                      });
                                                    });
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 4.0),
                                                  child: Text(
                                                    voiceRecorded
                                                        ? "Description Recorded"
                                                        : "Voice Description",
                                                    style: TextStyle(
                                                        color: AppColors.white,
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize:
                                                            ScreenUtil().setSp(30)),
                                                  ),
                                                ),
                                              );
                                            });
                                          })
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        "or",
                                        style: TextStyle(
                                            fontFamily:
                                                AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                            fontSize: ScreenUtil().setSp(40),
                                            fontWeight: FontWeight.w900),
                                      )),
                                    ),
                                  ],
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.0, top: 4.0),
                                  child: InkWell(
                                      onTap: () async {
                                        if (memo != "") {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (_) => BottomSheetView(
                                              path: memo,
                                            ),
                                          );
                                        } else {
                                          ReusableWidgets.showInfo(_scaffoldKey,
                                              context, "No memo added yet!");
                                          return;
                                        }
                                      },
                                      child:
                                          Image.asset("assets/images/ic_play.png")),
                                ),
                                InkWell(
                                    onTap: () {
                                      if (memo == "") {
                                        ReusableWidgets.showInfo(_scaffoldKey,
                                            context, "No memo added yet!");
                                        return;
                                      }

                                      showDialog(
                                          context: context,
                                          builder: (build) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10)),
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
                                                          "Alert",
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
                                                        "Are you sure you want to delete this memo?",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO,
                                                            fontSize: ScreenUtil()
                                                                .setSp(34)),
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
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        new FocusNode());
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  "No",
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
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        new FocusNode());

                                                                setState(() {
                                                                  memo = "";
                                                                  voiceRecorded =
                                                                      false;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  "Yes",
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
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Image.asset(
                                          "assets/images/ic_delete.png"),
                                    )),
                              ],
                            ),
                            TextField(
                              controller: descriptionController,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 6,
                              textInputAction: TextInputAction.done,
                              cursorHeight: 20,
                              style: TextStyle(color: Colors.black,fontFamily: AppFonts.FONTFAMILY_ROBOTO),

                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Text Description",
                                  hintStyle: TextStyle(color: Colors.black,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                  fillColor: AppColors.QUICK_IDEA_BACKGROUND,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.QUICK_IDEA_BACKGROUND,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.QUICK_IDEA_BACKGROUND,
                                        width: 2.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.QUICK_IDEA_BACKGROUND,
                                        width: 2.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.QUICK_IDEA_BACKGROUND,
                                        width: 2.0),
                                  ),
                                  filled: true),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(40),
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(
                                ScreenUtil().setHeight(30),
                              ),
                              onPressed: () {


                                if(showProgress)
                                  {
                                   return;
                                  }

                                if (titleController.text == "") {
                                  ReusableWidgets.showInfo(
                                      _scaffoldKey, context, "Please enter title");
                                } else if (descriptionController.text == "" &&
                                    memo == "") {
                                  ReusableWidgets.showInfo(_scaffoldKey, context,
                                      "Please provide description or voice");
                                }
                                // else if (imageCover == null) {
                                //   ReusableWidgets.showInfo(_scaffoldKey, context,
                                //       "Please provide a cover image");
                                // }
                                else {
                                  Helpers.checkInternet().then((value) {
                                    if (value) {
                                      setState(() {
                                        showProgress = true;
                                      });

                                      addQuickIdea(memo).then((value) {
                                        if(value==null)
                                          {
                                            ReusableWidgets.showInfo(
                                                _scaffoldKey,
                                                context,
                                                "Please try again");
                                            return;
                                          }

                                        ReusableWidgets.showInfo(
                                            _scaffoldKey,
                                            context,
                                            "Your idea is added successfully!");

                                        Future.delayed(const Duration(seconds: 0),
                                            () {
// Here you can write your code
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(selectPage: 0)),
                                              (Route<dynamic> route) => true);
                                        });
                                      });
                                    } else {
                                      ReusableWidgets.showInfo(
                                          _scaffoldKey,
                                          context,
                                          AppStrings.INTERNET_NOT_CONNECTED);
                                    }
                                  });
                                }
                              },
                              color: AppColors.colorAccent,
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: AppColors.BUTTONTEXT_YELLOW,
                                    fontSize: ScreenUtil().setSp(48),
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (showProgress)
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<QuickIdeaModel> addQuickIdea(String voiceNote) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-dd-yyyy');
    if(voiceNote!="")
      {
        voiceNote=voiceNote+"date"+formatter.format(now);
      }


    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "insert_type": "Quick Add",
      "title": titleController.text.toString(),
      "cover_image": imageCover,
      "description": descriptionController.text.toString(),
      "voice_message": voiceNote,
      "gallery": "",
      "notes": "",
      "interest": "",
      "priority": "",
      "solution_type": ""
    };

    debugPrint(data.toString());
    try{
      var response =
      await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.ADD_IDEAS,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data));
      if (response.statusCode == 200) {
        QuickIdeaModel model = QuickIdeaModel.fromJson(response.data);

        debugPrint("response data" + model.toString());

        setState(() {
          showProgress = false;
        });
        debugPrint("response getting raw data= " + response.data.toString());
        debugPrint(
            "debugger " + QuickIdeaModel.fromJson(response.data).toString());
        return model;
      }
      else
      {
        return null;
      }
    }
    on Exception catch(_)
    {
     return null;
    }

  }




  Future uploadFile(String file) async {
    debugPrint("inside upload file");
    if (file != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file,
              resourceType: CloudinaryResourceType.Raw),
        );

        setState(() {
          memo = response.secureUrl;
          debugPrint("inside memo received" + memo);
          // showProgress=false;
        });
      } on Exception catch (e) {}
    }
  }
}

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  int playerID;
  AudioPlayer audioPlayer = AudioPlayer(playerId: "sparks");
  List<Color> colors = [
    AppColors.colorPrimary,
    AppColors.colorPrimary,
    AppColors.colorPrimary,
    AppColors.colorPrimary
  ];
  List<int> duration = [900, 700, 600, 800, 500];

  bool startanim = false;

  @override
  void dispose() {
    RecordMp3.instance.stop();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  String recordFilePath;
  String statusText = "";

  bool isComplete = false;
  bool showError = false;
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  SessionManager prefs = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(620),
      color: AppColors.onBoardingColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: AppColors.colorPrimary,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
              child: Center(
                child: Text(
                  "Add memo",
                  style: TextStyle(
                      fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      fontSize: ScreenUtil().setSp(40)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Divider(
                //   height: 2,
                //   color: AppColors.colorPrimary,
                // ),
                if (startanim)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(120),
                        vertical: ScreenUtil().setHeight(20)),
                    child: Container(
                      height: ScreenUtil().setHeight(100),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                              30,
                              (index) => AnimWidget(
                                  duration: duration[index % 5],
                                  color: colors[index % 4]))),
                    ),
                  ),

                Divider(
                  height: 2,
                  color: AppColors.colorPrimary,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(40),
                      vertical: ScreenUtil().setHeight(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RecordMp3.instance.status == RecordStatus.IDEL
                          ? GestureDetector(
                              child: ClipOval(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.green,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        //      decoration: BoxDecoration(color: Colors.red.shade300),
                                        child: Center(
                                            child: Icon(
                                          Icons.mic,
                                          color: AppColors.white,
                                        )),
                                      ),
                                      Text(
                                        "Start",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(24),
                                            fontFamily:
                                                AppFonts.FONTFAMILY_ROBOTO),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                bool hasPermission = await checkPermission();
                                if (hasPermission) {
                                  statusText = "Recording started...";
                                  recordFilePath = await getFilePath();
                                  debugPrint("path "+recordFilePath);
                                  isComplete = false;
                                  RecordMp3.instance.start(recordFilePath,
                                      (type) {
                                    statusText = "Record error--->$type";

                                  });
                                } else {
                                  statusText = "No microphone permission";
                                }
                                setState(() {
                                  startanim = false;
                                });
                              },
                            )
                          : GestureDetector(
                              child: ClipOval(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.red,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30.0,
                                        //      decoration: BoxDecoration(color: Colors.red.shade300),
                                        child: Center(
                                            child: Icon(
                                          Icons.done_outlined,
                                          color: AppColors.white,
                                        )),
                                      ),
                                      Text(
                                        "Stop",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(24),
                                            fontFamily:
                                                AppFonts.FONTFAMILY_ROBOTO),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {

                                bool s = RecordMp3.instance.stop();
                                if (s) {
                                  statusText = "Recording complete";
                                  isComplete = true;
                                  RecordMp3.instance.stop();
                                  showError=false;

                                  setState(() {});
                                }
                              },
                            ),


                      isComplete && recordFilePath != null
                          ? GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(100)),
                                child: ClipOval(
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    color: AppColors.colorPrimary,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 30.0,
                                          //      decoration: BoxDecoration(color: Colors.red.shade300),
                                          child: Center(
                                              child: Icon(
                                            Icons.preview_outlined,
                                            color: AppColors.white,
                                          )),
                                        ),
                                        Text(
                                          "Preview",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily:
                                                AppFonts.FONTFAMILY_ROBOTO,
                                            fontSize: ScreenUtil().setSp(24),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                play();
                              },
                            )
                          : Container(),

                    ],
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                      color: AppColors.colorPrimary,
                      fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                      fontSize: ScreenUtil().setSp(40)),
                ),
                if(showError)
                  Text(
                    "Please stop your recording first.",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                        fontSize: ScreenUtil().setSp(36)),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                  ],
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(40)),
                  child: RaisedButton(
                    color: AppColors.colorPrimary,
                    padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () {

                      if(RecordMp3.instance.status == RecordStatus.RECORDING)
                        {
                            showError=true;
                          setState(() {

                          });
                        }


                      if( !isComplete)
                        return;
                      audioPlayer.stop();
                      Navigator.pop(context, recordFilePath);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: ScreenUtil().setSp(40),
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {

      debugPrint("ind");
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {

        debugPrint("ind2");
        return false;
      }
    }

    debugPrint("out2d");
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record1";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: false);
    }
    return sdPath + "/test_${Random().nextInt(1000)}.mp3";
  }

  void play() {
    if (recordFilePath != null) {
      setState(() {
        startanim = true;
      });
      audioPlayer.onPlayerCompletion.listen((event) {
        setState(() {
          startanim = false;
          audioPlayer.release();
        });
      });

      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }
}

class AnimWidget extends StatefulWidget {
  const AnimWidget({Key key, @required this.duration, @required this.color})
      : super(key: key);
  final int duration;
  final Color color;

  @override
  _AnimWidgetState createState() => _AnimWidgetState();
}

class _AnimWidgetState extends State<AnimWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    _animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      decoration: BoxDecoration(color: widget.color),
      height: _animation.value,
    );
  }
}
