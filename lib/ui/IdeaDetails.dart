import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sparks/bloc/IdeaDetailController.dart';
import 'package:sparks/models/DashboardModel.dart';
import 'package:sparks/models/DetailedIdeaModel.dart';
import 'package:sparks/models/HomePageModel.dart';
import 'package:sparks/models/QuickIdeaModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/ui/DetailedAdd.dart';
import 'package:sparks/ui/FullscreenImage.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/QuickAdd.dart';
import 'package:sparks/ui/UpdateIdea.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/BottomSheetView.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/NetworkCalls.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class IdeaDetails extends StatefulWidget {
  String postId;

  IdeaDetails({this.postId});

  @override
  _IdeaDetailsState createState() => _IdeaDetailsState();
}

class _IdeaDetailsState extends State<IdeaDetails> {
  DateFormat dateFormat = DateFormat('MM-dd-yyyy');
  bool detailsSelected = true;
  String imageToAdd = "";
  String formattedDate = "";
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  //lhxj0crg
  final picker = ImagePicker();

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Circles> dashboard = List();
  String rank = "";
  String score = "";
  String rankUpdation = "";
  String scoreUpdation = "";
  bool _validations = false;

  String memo = "";

  var vitaminSelected = true;

  var showPremiumData = false;
  final IdeaDetailController controller = Get.put(IdeaDetailController());
  ScrollController _controller;

  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-dd-yyyy');
    formattedDate = formatter.format(now);
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("dispose called");
    if (controller.showPremium.value) {
      controller.changePremiumStatus();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              FutureBuilder<DetailedIdeaModel>(
                builder: (cont, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                              backgroundColor: AppColors.colorPrimary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.colorAccent)),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Text(
                            'Loading....',
                            style: TextStyle(
                                color: AppColors.black,
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                          ),
                        ],
                      ));
                    default:
                      if (snapshot.hasError)
                        return Center(child: Text('Error2: ${snapshot.error}'));
                      else {
                        debugPrint(snapshot.data.data.notes.length.toString());
                        debugPrint(
                            snapshot.data.data.gallery.length.toString());
                        if (snapshot.data.data.solutionType == "Vitamin") {
                          vitaminSelected = true;
                          debugPrint("done one");
                        } else {
                          vitaminSelected = false;
                          debugPrint(
                              "done two" + snapshot.data.data.solutionType);
                        }

                        return SingleChildScrollView(
                          controller: _controller,
                          physics: ScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(20)),
                                color: AppColors.colorPrimary,
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(20)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/ic_close.png"),
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                                  child: Center(
                                                      child: Text(
                                                    snapshot.data.data.title
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        color: AppColors.white,
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM,
                                                        fontSize: ScreenUtil()
                                                            .setSp(42)),
                                                  )),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  var result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateIdea(
                                                                  detailedIdea:
                                                                      snapshot
                                                                          .data)));
                                                  if (result == "0") {
                                                    setState(() {});
                                                  }
                                                },
                                                child: ImageIcon(
                                                  AssetImage(
                                                      "assets/images/ic_penciledit.png"),
                                                  color: AppColors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(40),
                                          vertical: ScreenUtil().setWidth(20)),
                                      height: ScreenUtil().setHeight(170),
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data.data.coverImg,
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
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ScreenUtil().setWidth(30)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (build) => Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
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
                                                                  "Add Photo",
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
                                                                          ScreenUtil()
                                                                              .setSp(36)),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .all(ScreenUtil()
                                                                      .setHeight(
                                                                          30)),
                                                              child: Text(
                                                                "Choose Image Source",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .FONTFAMILY_ROBOTO,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            30)),
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

                                                                        getImage(
                                                                            ImageSource.camera,
                                                                            snapshot.data.data);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          "Camera",
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
                                                                        FocusScope.of(context)
                                                                            .requestFocus(new FocusNode());

                                                                        getImage(
                                                                            ImageSource.gallery,
                                                                            snapshot.data.data);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          "Gallery",
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
                                                      ));
                                            },
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/ic_camera.png"),
                                              color: AppColors.white,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                  "assets/images/ic_info.png"),
                                              SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(20),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  NetworkCalls.submitIdeaVote(snapshot.data.data.id);
                                                  if (false) {
                                                    updateVoteStatus(
                                                            snapshot
                                                                .data.data.id,
                                                            "false")
                                                        .then((value) {
                                                      // Future.delayed(
                                                      //     Duration(seconds: 1),
                                                      //     () {
                                                      //   Navigator.pop(context);
                                                      // });

                                                      // showDialog(
                                                      //     context: (context),
                                                      //     builder:
                                                      //         (build) => Dialog(
                                                      //               shape: RoundedRectangleBorder(
                                                      //                   borderRadius:
                                                      //                       BorderRadius.circular(10)),
                                                      //               child: Container(
                                                      //                   width: ScreenUtil().setWidth(450),
                                                      //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                      //                   child: Column(
                                                      //                     mainAxisSize:
                                                      //                         MainAxisSize.min,
                                                      //                     children: [
                                                      //                       Container(
                                                      //                         padding: const EdgeInsets.all(8.0),
                                                      //                         decoration: BoxDecoration(
                                                      //                           borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                      //                           color: AppColors.colorPrimary,
                                                      //                         ),
                                                      //                         width: double.infinity,
                                                      //                         child: Center(
                                                      //                           child: Text("SUCCESS!", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: ScreenUtil().setSp(34), fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM)),
                                                      //                         ),
                                                      //                       ),
                                                      //                       Padding(
                                                      //                         padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(80)),
                                                      //                         child: Center(
                                                      //                           child: Text(
                                                      //                             value.message,
                                                      //                             style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(32), fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                                      //                           ),
                                                      //                         ),
                                                      //                       ),
                                                      //                     ],
                                                      //                   )),
                                                      //             ));

                                                      // setState(() {});
                                                    });
                                                  } else {
                                                    showDialog(
                                                        context: (context),
                                                        builder:
                                                            (builder) => Dialog(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .onBoardingColor,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                ScreenUtil().setHeight(8),
                                                                            horizontal: ScreenUtil().setHeight(15)),
                                                                        child:
                                                                            Text(
                                                                          "Voting Space Submission",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                                                              fontWeight: FontWeight.w900,
                                                                              fontSize: ScreenUtil().setSp(38)),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
                                                                        child:
                                                                            Text(
                                                                          "Submitting your idea to the voting space allows for other users to vote if they like your idea.",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                AppFonts.FONTFAMILY_ROBOTO,
                                                                            fontSize:
                                                                                ScreenUtil().setSp(32),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                                                                        child:
                                                                            Text(
                                                                          "Results help to indicate potential",
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: ScreenUtil().setSp(32)),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(6)),
                                                                        child:
                                                                            Text(
                                                                          "- Market Demand/Feasibility",
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                                                              color: AppColors.colorAccent,
                                                                              fontSize: ScreenUtil().setSp(38)),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                                                                        child: Image.asset(
                                                                            "assets/images/ic_topdialog.png"),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
                                                                        child:
                                                                            Text(
                                                                          "- Target Demographics",
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                                                              color: AppColors.colorAccent,
                                                                              fontSize: ScreenUtil().setSp(38)),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                                                                        child: Image.asset(
                                                                            "assets/images/ic_bottomdialog.png"),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Divider(
                                                                        color: AppColors
                                                                            .black,
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text(
                                                                                  "Later",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(40), fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          Expanded(
                                                                            child: InkWell(
                                                                                onTap: () async {
                                                                                  Navigator.pop(context);
                                                                                  updateVoteStatus(snapshot.data.data.id, "true").then((value) {
                                                                                    NetworkCalls.submitIdea(snapshot.data.data.id);

                                                                                    showPremiumDialog("Unfortunately this feature is still being developed.");
                                                                                    // Future.delayed(Duration(seconds: 1), () {
                                                                                    //   Navigator.pop(context);
                                                                                    // });
                                                                                    // showDialog(
                                                                                    //     context: (context),
                                                                                    //     builder: (build) => Dialog(
                                                                                    //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    //           child: Container(
                                                                                    //               width: ScreenUtil().setWidth(450),
                                                                                    //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                                                    //               child: Column(
                                                                                    //                 mainAxisSize: MainAxisSize.min,
                                                                                    //                 children: [
                                                                                    //                   Container(
                                                                                    //                     padding: const EdgeInsets.all(8.0),
                                                                                    //                     decoration: BoxDecoration(
                                                                                    //                       borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                    //                       color: AppColors.colorPrimary,
                                                                                    //                     ),
                                                                                    //                     width: double.infinity,
                                                                                    //                     child: Center(
                                                                                    //                       child: Text("SUCCESS!", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: ScreenUtil().setSp(34), fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM)),
                                                                                    //                     ),
                                                                                    //                   ),
                                                                                    //                   Padding(
                                                                                    //                     padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(80)),
                                                                                    //                     child: Text(
                                                                                    //                       value.message,
                                                                                    //                       style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(32), fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                                                                    //                     ),
                                                                                    //                   ),
                                                                                    //                 ],
                                                                                    //               )),
                                                                                    //         ));

                                                                                    // setState(() {});
                                                                                  });
                                                                                },
                                                                                child: Text("Submit Idea", textAlign: TextAlign.center, style: TextStyle(color: AppColors.NextButton_color, fontWeight: FontWeight.w900, fontSize: ScreenUtil().setSp(40), fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD))),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ));
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      ScreenUtil()
                                                          .setHeight(14)),
                                                  decoration: BoxDecoration(
                                                      // color: snapshot.data.data
                                                      //             .voteStatus ==
                                                      //         "true"
                                                      //     ? AppColors
                                                      //         .onBoardingColor
                                                      //     : AppColors
                                                      //         .VOTING_SPACE_BACKGROUND,
                                                      // borderRadius:
                                                      //     BorderRadius.all(
                                                      //         Radius.circular(
                                                      //             4))

                                                      color: snapshot.data.data
                                                                  .voteStatus ==
                                                              "true"
                                                          ? AppColors
                                                              .VOTING_SPACE_BACKGROUND
                                                          : AppColors
                                                              .VOTING_SPACE_BACKGROUND,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4))),
                                                  child: Text(
                                                    "Submit to voting space"
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              String data =
                                                  await showModalBottomSheet(
                                                context: context,
                                                builder: (_) => MyBottomSheet(),
                                              );

                                              if (data != null) {
                                                uploadFile(data,
                                                        snapshot.data.data)
                                                    .then((value) {
                                                  setState(() {
                                                    // showProgress = false;
                                                  });
                                                });
                                              }
                                            },
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/ic_mic.png"),
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(16)),
                                color: _validations
                                    ? AppColors.search_background
                                    : AppColors.circles_background,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(10)),
                                  decoration: BoxDecoration(
                                      color: AppColors.onBoardingColor,
                                      border: Border.all(
                                          color: AppColors.onBoardingColor),
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(50))),
                                  height: ScreenUtil().setHeight(70),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _validations = false;
                                            detailsSelected = true;
                                          });
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: detailsSelected
                                                    ? AppColors.white
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil().setWidth(
                                                            50))),
                                            child: Text("Details",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(26),
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO_MEDIUM,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.black),
                                                textAlign: TextAlign.center)),
                                      )),
                                      Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                getDashboard(
                                                        snapshot.data.data.id)
                                                    .then((value) {
                                                  try {
                                                    dashboard =
                                                        value.data.circles;
                                                    rank = value.data.rank;
                                                    score = value.data.topScore;
                                                    if(int.parse(value.data.rankUpdation)>0)
                                                      {
                                                        rankUpdation =
                                                            "+"+value.data.rankUpdation;
                                                      }
                                                    else
                                                      {
                                                        rankUpdation =
                                                            value.data.rankUpdation;
                                                      }

                                                    if(int.parse(value.data.scoreUpdation)>0)
                                                    {
                                                      scoreUpdation =
                                                          "+"+value.data.scoreUpdation;
                                                    }
                                                    else
                                                    {
                                                      scoreUpdation= value.data.scoreUpdation;
                                                    }


                                                    setState(() {
                                                      _validations = true;
                                                      detailsSelected = false;
                                                    });
                                                  } catch (e) {
                                                    print("error is"+e.toString());
                                                    showDialog(
                                                        context: (context),
                                                        builder:
                                                            (cont) => Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .onBoardingColor,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(ScreenUtil().setHeight(20)),
                                                                        child:
                                                                            Text(
                                                                          "Validation Page Requires Data",
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                                                              fontWeight: FontWeight.w900,
                                                                              fontSize: ScreenUtil().setSp(32)),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            ScreenUtil().setHeight(10),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                                                                        child:
                                                                            Text(
                                                                          "Create inner circles so that circle members can vote on your ideas",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                                                              fontSize: ScreenUtil().setSp(30)),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
                                                                        child:
                                                                            Text(
                                                                          "Preview",
                                                                          style: TextStyle(
                                                                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(18)),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.height / 2.0,
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/image_validationpreview.png",
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            ScreenUtil().setHeight(18),
                                                                      ),
                                                                      Divider(
                                                                        color: AppColors
                                                                            .black,
                                                                        height:
                                                                            1,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                                  child: Text(
                                                                                    "Later",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(color: Colors.red[800], fontSize: ScreenUtil().setSp(34), fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          Expanded(
                                                                            child: InkWell(
                                                                                onTap: () async {
                                                                                  Navigator.pop(context);

                                                                                  Navigator.of(context).pushAndRemoveUntil(
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => HomeScreen(
                                                                                                selectPage: 1,
                                                                                              )),
                                                                                      (Route<dynamic> route) => true);
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                                  child: Text("Go to My Circles", textAlign: TextAlign.center, style: TextStyle(color: AppColors.NextButton_color, fontWeight: FontWeight.w900, fontSize: ScreenUtil().setSp(30), fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD)),
                                                                                )),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ));
                                                    //
                                                    // ReusableWidgets.showInfo(
                                                    //     _scaffoldKey,
                                                    //     context,
                                                    //     "No data found!");
                                                  }

                                                  return;
                                                });
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: detailsSelected
                                                          ? null
                                                          : AppColors
                                                              .white,
                                                      borderRadius: BorderRadius
                                                          .circular(ScreenUtil()
                                                              .setWidth(50))),
                                                  child: Text(
                                                    "Validation",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(26),
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors.black),
                                                    textAlign: TextAlign.center,
                                                  ))))
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                              //   color: AppColors.onBoardingColor,
                              //   child: Padding(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: ScreenUtil().setWidth(30)),
                              //     child: Container(
                              //       padding:
                              //       EdgeInsets.all(ScreenUtil().setHeight(20)),
                              //       decoration: BoxDecoration(
                              //           color: AppColors.white,
                              //           borderRadius:
                              //           BorderRadius.all(Radius.circular(20))),
                              //       child:
                              //
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           InkWell(
                              //               onTap: () {
                              //                 setState(() {
                              //                   _validations = false;
                              //                 });
                              //               },
                              //               child: Text(
                              //                 "Details",
                              //                 style: TextStyle(
                              //                     fontFamily: AppFonts
                              //                         .FONTFAMILY_ROBOTO_MEDIUM,
                              //                     fontWeight: FontWeight.w700),
                              //               )),
                              //           SizedBox(
                              //             width: ScreenUtil().setWidth(140),
                              //           ),
                              //           InkWell(
                              //               onTap: () {
                              //                 getDashboard(snapshot.data.data.id)
                              //                     .then((value) {
                              //                   try {
                              //                     dashboard = value.data.circles;
                              //                     setState(() {
                              //                       _validations = true;
                              //                     });
                              //                   } catch (e) {
                              //                     ReusableWidgets.showInfo(
                              //                         _scaffoldKey,
                              //                         context,
                              //                         "No data found!");
                              //                   }
                              //
                              //                   return;
                              //                 });
                              //               },
                              //               child: Text(
                              //                 "Validation",
                              //                 style: TextStyle(
                              //                     fontFamily: AppFonts
                              //                         .FONTFAMILY_ROBOTO_MEDIUM,
                              //                     fontWeight: FontWeight.w700),
                              //               ))
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              if (!_validations)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(30)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Description",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppFonts
                                                  .FONTFAMILY_ROBOTO_MEDIUM),
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshot.data.data.description,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFonts.FONTFAMILY_ROBOTO),
                                          )),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(40)),
                                        color: AppColors.black,
                                        height: 2,
                                        width: ScreenUtil().setWidth(200),
                                      ),

                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Photos",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppFonts
                                                    .FONTFAMILY_ROBOTO_MEDIUM),
                                          )),
                                      snapshot.data.data.gallery.isNotEmpty
                                          ? Container(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics: ScrollPhysics(),
                                                itemBuilder: (c, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (builder) =>
                                                                  FullscreenImage(
                                                                    image: snapshot
                                                                            .data
                                                                            .data
                                                                            .gallery[
                                                                        index],
                                                                  )));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                          snapshot.data.data.gallery[index],
                                                          imageBuilder:
                                                              (context, imageProvider) =>
                                                              Container(
                                                                width: ScreenUtil().setWidth(100),
                                                                height:
                                                                ScreenUtil().setHeight(100),
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.rectangle,
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                          placeholder: (context, url) =>
                                                              Center(
                                                                child: CircularProgressIndicator(
                                                                    backgroundColor:
                                                                    AppColors.colorPrimary,
                                                                    valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                        AppColors
                                                                            .colorAccent)),
                                                              ),
                                                          errorWidget:
                                                              (context, url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                        // decoration: BoxDecoration(
                                                        //     image: DecorationImage(
                                                        //         image: NetworkImage(
                                                        //             snapshot
                                                        //                     .data
                                                        //                     .data
                                                        //                     .gallery[
                                                        //                 index]),
                                                        //         fit: BoxFit
                                                        //             .fill)),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: snapshot
                                                    .data.data.gallery.length,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "No photos added yet!",
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO),
                                              )),
                                      //      if (snapshot.data.data.gallery.isNotEmpty)
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(40)),
                                        color: AppColors.black,
                                        height: 2,
                                        width: ScreenUtil().setWidth(200),
                                      ),
                                      //     if (snapshot.data.data.notes.isNotEmpty)
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Notes/Memos",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppFonts
                                                    .FONTFAMILY_ROBOTO_MEDIUM),
                                          )),
                                      snapshot.data.data.notes.isNotEmpty
                                          ? ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxHeight: 500,
                                                  minHeight: 20.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemBuilder: (c, index) {
                                                  return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                snapshot.data.data.notes[index].substring(
                                                                    snapshot
                                                                            .data
                                                                            .data
                                                                            .notes[
                                                                                index]
                                                                            .indexOf(
                                                                                "date") +
                                                                        4,
                                                                    snapshot
                                                                        .data
                                                                        .data
                                                                        .notes[
                                                                            index]
                                                                        .length),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .FONTFAMILY_ROBOTO_MEDIUM),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: ScreenUtil()
                                                                        .setWidth(
                                                                            12)),
                                                                child:
                                                                    ImageIcon(
                                                                  AssetImage(
                                                                      "assets/images/ic_Keyboard.png"),
                                                                  color: AppColors
                                                                      .colorAccent,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                snapshot
                                                                    .data
                                                                    .data
                                                                    .notes[
                                                                        index]
                                                                    .substring(
                                                                        0,
                                                                        snapshot
                                                                            .data
                                                                            .data
                                                                            .notes[index]
                                                                            .indexOf("date")),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .FONTFAMILY_ROBOTO_MEDIUM),
                                                              ))
                                                        ],
                                                      ));
                                                },
                                                itemCount: snapshot
                                                    .data.data.notes.length,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "No notes added yet!",
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO),
                                              )),
                                      snapshot.data.data.voiceMsg.isNotEmpty
                                          ? ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxHeight: 500,
                                                  minHeight: 20.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemBuilder: (c, index) {
                                                  return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "memo ${index + 1} (" +
                                                                    snapshot.data.data.voiceMsg[index].substring(
                                                                        snapshot.data.data.voiceMsg[index].indexOf("date") +
                                                                            4,
                                                                        snapshot
                                                                            .data
                                                                            .data
                                                                            .voiceMsg[index]
                                                                            .length) +
                                                                    ")",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .FONTFAMILY_ROBOTO_MEDIUM),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: ScreenUtil()
                                                                        .setWidth(
                                                                            12)),
                                                                child:
                                                                    Container(
                                                                  width: ScreenUtil()
                                                                      .setWidth(
                                                                          80),
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          20),
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/ic_audiowave.png",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: ScreenUtil()
                                                                        .setWidth(
                                                                            12)),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              BottomSheetView(
                                                                        path: snapshot
                                                                            .data
                                                                            .data
                                                                            .voiceMsg[
                                                                                index]
                                                                            .substring(0,
                                                                                snapshot.data.data.voiceMsg[index].indexOf("date")),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/ic_playfilled.png"),
                                                                    color: AppColors
                                                                        .colorAccent,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          // Align(
                                                          //     alignment:
                                                          //         Alignment.centerLeft,
                                                          //     child: Text(snapshot.data
                                                          //         .data.voiceMsg[index]
                                                          //         .substring(0, 3)))
                                                        ],
                                                      ));
                                                },
                                                itemCount: snapshot
                                                    .data.data.voiceMsg.length,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: ScreenUtil()
                                                        .setHeight(4)),
                                                child: Text(
                                                  "No memos added yet",
                                                  style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO),
                                                ),
                                              )),
                                      // if (snapshot.data.data.interests != "")
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(40)),
                                        color: AppColors.black,
                                        height: 2,
                                        width: ScreenUtil().setWidth(200),
                                      ),
                                      //     if (snapshot.data.data.interests != "")
                                      Row(
                                        children: [
                                          Text("Personal Interest",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppFonts
                                                      .FONTFAMILY_ROBOTO_MEDIUM)),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.info_outline,
                                              size: ScreenUtil().setHeight(24),
                                            ),
                                          ),
                                        ],
                                      ),
                                      snapshot.data.data.interests != ""
                                          ? Column(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      "${double.parse(snapshot.data.data.interests).round()}/10",
                                                      style: TextStyle(
                                                          fontFamily: AppFonts
                                                              .FONTFAMILY_ROBOTO),
                                                    )),
                                                // FlutterSlider(
                                                //   values: [
                                                //     double.parse(
                                                //         snapshot.data.data.interests)
                                                //   ],
                                                //   max: 10,
                                                //   min: 1,
                                                //   disabled: false,
                                                //   trackBar: FlutterSliderTrackBar(
                                                //     activeTrackBarHeight: 5,
                                                //     inactiveTrackBar: BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.circular(20),
                                                //       color: Colors.amberAccent,
                                                //       border: Border.all(
                                                //           width: 3, color: Colors.black54),
                                                //     ),
                                                //     activeTrackBar: BoxDecoration(
                                                //         borderRadius:
                                                //             BorderRadius.circular(4),
                                                //         color: AppColors.colorPrimary),
                                                //   ),
                                                //   tooltip: FlutterSliderTooltip(
                                                //       custom: (value) {
                                                //         return Text(
                                                //             value.round().toString());
                                                //       },
                                                //       alwaysShowTooltip: true),
                                                //   handler: FlutterSliderHandler(
                                                //     decoration: BoxDecoration(),
                                                //     child: ImageIcon(AssetImage(
                                                //         "assets/images/ic_slidermarker.png")),
                                                //   ),
                                                // ),
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    activeTrackColor:
                                                        Colors.red,
                                                    inactiveTrackColor:
                                                        Colors.green,
                                                    trackHeight: 3.0,
                                                    disabledThumbColor:
                                                        AppColors.colorAccent,
                                                    disabledActiveTrackColor:
                                                        AppColors.colorAccent,
                                                    thumbColor: Colors.yellow,
                                                    thumbShape:
                                                        RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                3.0),
                                                    overlayColor: Colors.purple
                                                        .withAlpha(32),
                                                    overlayShape:
                                                        RoundSliderOverlayShape(
                                                            overlayRadius:
                                                                14.0),
                                                  ),
                                                  child: Slider(
                                                    min: 1,
                                                    max: 10,
                                                    value: double.parse(snapshot
                                                        .data.data.interests),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: ScreenUtil()
                                                        .setHeight(10)),
                                                child: Text(
                                                  "Interest not defined",
                                                  style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO),
                                                ),
                                              )),
                                      //           if (snapshot.data.data.interests != "")
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      Row(
                                        children: [
                                          Text("Personal Priority",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppFonts
                                                      .FONTFAMILY_ROBOTO_MEDIUM)),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.info_outline,
                                              size: ScreenUtil().setHeight(24),
                                            ),
                                          ),
                                        ],
                                      ),
                                      snapshot.data.data.interests != ""
                                          ? Column(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      "${double.parse(snapshot.data.data.priority).round()}/10",
                                                      style: TextStyle(
                                                          fontFamily: AppFonts
                                                              .FONTFAMILY_ROBOTO),
                                                    )),
                                                // FlutterSlider(
                                                //   values: [
                                                //     double.parse(
                                                //         snapshot.data.data.priority)
                                                //   ],
                                                //   max: 10,
                                                //   min: 1,
                                                //   disabled: true,
                                                //   tooltip: FlutterSliderTooltip(
                                                //       custom: (value) {
                                                //         return Text(
                                                //             value.round().toString());
                                                //       },
                                                //       alwaysShowTooltip: true),
                                                //   handler: FlutterSliderHandler(
                                                //     decoration: BoxDecoration(),
                                                //     child: ImageIcon(AssetImage(
                                                //         "assets/images/ic_slidermarker.png")),
                                                //   ),
                                                //
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    activeTrackColor:
                                                        Colors.red,
                                                    inactiveTrackColor: AppColors
                                                        .VOTING_SPACE_BACKGROUND,
                                                    trackHeight: 3.0,
                                                    thumbColor:
                                                        AppColors.colorAccent,
                                                    disabledThumbColor:
                                                        AppColors.colorAccent,
                                                    disabledActiveTrackColor:
                                                        AppColors.colorAccent,
                                                    thumbShape:
                                                        RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                3.0),
                                                    overlayColor: Colors.purple
                                                        .withAlpha(32),
                                                    overlayShape:
                                                        RoundSliderOverlayShape(
                                                            overlayRadius:
                                                                14.0),
                                                  ),
                                                  child: Slider(
                                                    min: 1,
                                                    max: 10,
                                                    value: double.parse(snapshot
                                                        .data.data.priority),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: ScreenUtil()
                                                        .setHeight(10)),
                                                child: Text(
                                                  "Priority not specified",
                                                  style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO),
                                                ),
                                              )),
                                      //         if (snapshot.data.data.interests != "")
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(4)),
                                        child: Align(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Solution type",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO_MEDIUM),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size: ScreenUtil()
                                                      .setHeight(24),
                                                ),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                      ),
                                      snapshot.data.data.solutionType != ""
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  border: Border.all(
                                                      color: AppColors
                                                          .onBoardingColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          ScreenUtil()
                                                              .setWidth(50))),
                                              height:
                                                  ScreenUtil().setHeight(80),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          20)),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: vitaminSelected
                                                                  ? AppColors
                                                                      .colorAccent
                                                                  : null,
                                                              borderRadius: BorderRadius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          50))),
                                                          child: Text(AppStrings.VITAMIN,
                                                              style: TextStyle(
                                                                  fontSize: ScreenUtil().setSp(26),
                                                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: vitaminSelected ? AppColors.white : AppColors.colorAccent),
                                                              textAlign: TextAlign.center))),
                                                  Expanded(
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: vitaminSelected
                                                                  ? null
                                                                  : AppColors
                                                                      .colorAccent,
                                                              borderRadius: BorderRadius
                                                                  .circular(ScreenUtil()
                                                                      .setWidth(
                                                                          50))),
                                                          child: Text(
                                                            AppStrings
                                                                .PAINKILLER,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            26),
                                                                fontFamily:
                                                                    AppFonts
                                                                        .FONTFAMILY_ROBOTO_MEDIUM,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: vitaminSelected
                                                                    ? AppColors
                                                                        .colorAccent
                                                                    : AppColors
                                                                        .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )))
                                                ],
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Solution type not specified",
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO),
                                              )),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(30),
                                      ),

                                      //premium content
                                      Obx(
                                        () {
                                          return !controller.showPremium.value
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller
                                                          .changePremiumStatus();
                                                      debugPrint("printed " +
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height
                                                              .toString());
                                                      _controller.animateTo(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height +
                                                              ScreenUtil()
                                                                  .setHeight(
                                                                      200),
                                                          curve: Curves
                                                              .easeOutCubic,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000));
                                                    },
                                                    child: SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(180),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                            "assets/images/ic_downarrow.png"),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Stack(children: [
                                                  Image.asset(
                                                      "assets/images/ic_premium.png"),
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: InkWell(
                                                              onTap: () {
                                                                // setState(() {
                                                                //   showPremiumData =
                                                                //   false;
                                                                // });

                                                                controller
                                                                    .changePremiumStatus();
                                                              },
                                                              child: SizedBox(
                                                                width: ScreenUtil()
                                                                    .setWidth(
                                                                        180),
                                                                child: Image.asset(
                                                                    "assets/images/ic_uparrow.png"),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            30),
                                                                vertical:
                                                                    ScreenUtil()
                                                                        .setHeight(
                                                                            20)),
                                                            child: Text(
                                                              "Upgrade to Premium for\nAdditional Content Fields.",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .YELLOW,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .CAIRO_BOLD,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              40)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            40)),
                                                            child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  RaisedButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4)),
                                                                onPressed: () {
                                                                  NetworkCalls.upgradeToPremium();
                                                                  showPremiumDialog(
                                                                      "Unfortunately premium\nfeatures are still being\ndeveloped.");
                                                                },
                                                                padding: EdgeInsets.all(
                                                                    ScreenUtil()
                                                                        .setHeight(
                                                                            30)),
                                                                color: AppColors
                                                                    .black,
                                                                child: Text(
                                                                  "Upgrade Now (\$2.99/Month)"
                                                                      .toUpperCase(),
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .VOTING_SPACE_BACKGROUND,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              30),
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .FONTFAMILY_ROBOTO),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                                ]);
                                        },
                                      )
                                      // if (!showPremiumData)
                                      //   Align(
                                      //     alignment: Alignment.center,
                                      //     child: InkWell(
                                      //       onTap: () {
                                      //         setState(() {
                                      //           showPremiumData = true;
                                      //
                                      //           _controller.animateTo(1000,
                                      //               curve: Curves.fastOutSlowIn,
                                      //               duration: Duration(
                                      //                   milliseconds: 1000));
                                      //         });
                                      //       },
                                      //       child: SizedBox(
                                      //         width: ScreenUtil().setWidth(180),
                                      //         child: Image.asset(
                                      //             "assets/images/ic_downarrow.png"),
                                      //       ),
                                      //     ),
                                      //   ),
                                      //
                                      // if (showPremiumData)
                                      //   Stack(children: [
                                      //     Image.asset(
                                      //         "assets/images/ic_premium.png"),
                                      //     Positioned(
                                      //         top: 0,
                                      //         left: 0,
                                      //         right: 0,
                                      //         child: Column(
                                      //           children: [
                                      //             Align(
                                      //               alignment: Alignment.center,
                                      //               child: InkWell(
                                      //                 onTap: () {
                                      //                   setState(() {
                                      //                     showPremiumData =
                                      //                         false;
                                      //                   });
                                      //                 },
                                      //                 child: SizedBox(
                                      //                   width: ScreenUtil()
                                      //                       .setWidth(180),
                                      //                   child: Image.asset(
                                      //                       "assets/images/ic_uparrow.png"),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   EdgeInsets.symmetric(
                                      //                       horizontal:
                                      //                           ScreenUtil()
                                      //                               .setWidth(
                                      //                                   40),
                                      //                       vertical:
                                      //                           ScreenUtil()
                                      //                               .setHeight(
                                      //                                   20)),
                                      //               child: Text(
                                      //                 "Upgrade to Premium for\nAdditional Content Fields.",
                                      //                 textAlign:
                                      //                     TextAlign.center,
                                      //                 style: TextStyle(
                                      //                     color:
                                      //                         AppColors.YELLOW,
                                      //                     fontWeight:
                                      //                         FontWeight.w900,
                                      //                     fontFamily: AppFonts
                                      //                         .CAIRO_BOLD,
                                      //                     fontSize: ScreenUtil()
                                      //                         .setSp(46)),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   EdgeInsets.symmetric(
                                      //                       horizontal:
                                      //                           ScreenUtil()
                                      //                               .setWidth(
                                      //                                   40)),
                                      //               child: SizedBox(
                                      //                 width: double.infinity,
                                      //                 child: RaisedButton(
                                      //                   shape:
                                      //                       RoundedRectangleBorder(
                                      //                           borderRadius:
                                      //                               BorderRadius
                                      //                                   .circular(
                                      //                                       4)),
                                      //                   onPressed: () {
                                      //
                                      //
                                      //                     showPremiumDialog("Unfortunately premium\nfeatures are still being\ndeveloped.");
                                      //
                                      //                   },
                                      //                   padding: EdgeInsets.all(
                                      //                       ScreenUtil()
                                      //                           .setHeight(30)),
                                      //                   color: AppColors.black,
                                      //                   child: Text(
                                      //                     "Upgrade Now (\$2.99/Month)"
                                      //                         .toUpperCase(),
                                      //                     style: TextStyle(
                                      //                         color: AppColors
                                      //                             .VOTING_SPACE_BACKGROUND,
                                      //                         fontWeight:
                                      //                             FontWeight
                                      //                                 .w500,
                                      //                         fontSize:
                                      //                             ScreenUtil()
                                      //                                 .setSp(
                                      //                                     30),
                                      //                         fontFamily: AppFonts
                                      //                             .FONTFAMILY_ROBOTO),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             )
                                      //           ],
                                      //         ))
                                      //   ])
                                    ],
                                  ),
                                ),
                              if (_validations)
                                Column(
                                  children: [
                                    Container(
                                      color: AppColors.search_background,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        score,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .colorAccent,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(70),
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO_BOLD,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Text(
                                                          "%",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .colorAccent,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          28),
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_ROBOTO_MEDIUM,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Container(
                                                      height: 30,
                                                      width: 1,
                                                      color: AppColors.black,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "Idea\nScore",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .colorAccent,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(36),
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO_BOLD,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),

                  // Align(
                  // alignment: Alignment
                  //     .bottomCenter,
                  //                                       child: SizedBox(
                  //                                         width:10,height:18,
                  //                                         child: int.parse(scoreUpdation) >
                  //                                             0
                  //                                             ? Icon(
                  //                                           Icons
                  //                                               .arrow_drop_up_sharp,
                  //                                           color: AppColors
                  //                                               .ARROW_COLOR,
                  //                                         )
                  //                                             : Icon(
                  //                                           Icons
                  //                                               .arrow_drop_down_sharp,
                  //                                           color: AppColors
                  //                                               .ARROW_COLOR,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:  EdgeInsets.only(left:8.0),
                  //                                       child: Align(
                  //                                         alignment: Alignment
                  //                                             .bottomCenter,
                  //                                         child: Text(
                  //                                           scoreUpdation+"%",
                  //                                           style: TextStyle(
                  //                                               color: AppColors
                  //                                                   .backgoundLight,
                  //                                               fontSize:
                  //                                                   ScreenUtil()
                  //                                                       .setSp(
                  //                                                           26),
                  //                                               fontFamily: AppFonts
                  //                                                   .FONTFAMILY_ROBOTO,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .w500),
                  //                                         ),
                  //                                       ),
                  //                                     )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        rank,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .BUTTONTEXT_YELLOW,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(70),
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO_BOLD,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Text(
                                                          Helpers.getDayOfMonthSuffix(int.parse(rank)),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .BUTTONTEXT_YELLOW,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          26),
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_ROBOTO_MEDIUM,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Container(
                                                      height: 30,
                                                      width: 1,
                                                      color: AppColors.black,
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Rank",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .BUTTONTEXT_YELLOW,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(36),
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO_BOLD,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      // Row(
                                                      //   children: [
                                                      //     int.parse(rankUpdation) >
                                                      //             0
                                                      //         ? Icon(
                                                      //             Icons
                                                      //                 .arrow_drop_up_sharp,
                                                      //             color: AppColors
                                                      //                 .ARROW_COLOR,
                                                      //           )
                                                      //         : Icon(
                                                      //             Icons
                                                      //                 .arrow_drop_down_sharp,
                                                      //             color: AppColors
                                                      //                 .ARROW_COLOR,
                                                      //           ),
                                                      //     Text(
                                                      //       rankUpdation+"%",
                                                      //       style: TextStyle(
                                                      //           color: AppColors
                                                      //               .backgoundLight,
                                                      //           fontSize:
                                                      //               ScreenUtil()
                                                      //                   .setSp(
                                                      //                       26),
                                                      //           fontFamily: AppFonts
                                                      //               .FONTFAMILY_ROBOTO,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .w500),
                                                      //     )
                                                      //   ],
                                                      // )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        "Inner Circles",
                                        style: TextStyle(
                                            color: AppColors.colorAccent,
                                            fontWeight: FontWeight.w700,
                                            fontSize: ScreenUtil().setSp(36),
                                            fontFamily: AppFonts
                                                .FONTFAMILY_ROBOTO_MEDIUM),
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(34)),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 4,
                                        thickness: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ScreenUtil().setWidth(30)),
                                      child: Row(
                                        children: [
                                          Container(

                                            height: ScreenUtil().setHeight(420),
                                            child: RotatedBox(
                                                quarterTurns: -1,
                                                child: Center(
                                                  child: Text(
                                                    "FEEDBACK",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(70),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontFamily:
                                                            AppFonts.INTER_BOLD,
                                                        color: AppColors
                                                            .backgoundLight),
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxHeight:  ScreenUtil().setHeight(460),
                                                  minHeight:  ScreenUtil().setHeight(420),),
                                              child: Padding(
                                                padding:  EdgeInsets.only(top:ScreenUtil().setHeight(2)),
                                                child: ListView.builder(

                                                  physics: ClampingScrollPhysics()
                                                  ,
                                                  itemBuilder: (context, index) {
                                                    return dashboard[index]
                                                        .totalUpvotes!="0"?
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          6)),
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  dashboard[index]
                                                                      .totalComments,
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .YELLOW,
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .INTER_BOLD,
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              54),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                ),
                                                                Text(
                                                                  "Messages",
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .colorAccent,
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .INTER_MEDIUM,
                                                                      fontSize: ScreenUtil()
                                                                          .setSp(
                                                                              32),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      ScreenUtil()
                                                                          .setWidth(
                                                                              20)),
                                                              child:
                                                                  CircularPercentIndicator(
                                                                radius: 50.0,
                                                                animation: true,
                                                                animationDuration:
                                                                    1200,
                                                                lineWidth: 5.0,
                                                                percent: int.parse(dashboard[
                                                                            index]
                                                                        .percentage) /
                                                                    100.0,
                                                                center:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          dashboard[index]
                                                                              .circleImage),
                                                                ),
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .butt,
                                                                backgroundColor:
                                                                    Colors.black,
                                                                progressColor:
                                                                    AppColors
                                                                        .VOTING_SPACE_BACKGROUND,
                                                              ),
                                                            ),
                                                            Column(
crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    "UPVOTE RATIO",
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .colorAccent,
                                                                        fontSize: ScreenUtil()
                                                                            .setSp(
                                                                                38),
                                                                        fontFamily:
                                                                            AppFonts
                                                                                .INTER_MEDIUM,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700)),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                            dashboard[
                                                                            index]
                                                                                .percentage
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                color: AppColors
                                                                                    .colorAccent,
                                                                                fontWeight: FontWeight
                                                                                    .w900,fontFamily: AppFonts
                                                                                .INTER_BOLD,
                                                                                fontSize:
                                                                                ScreenUtil().setSp(38))),

                                                                        Text("%",
                                                                            style: TextStyle(
                                                                                color: AppColors
                                                                                    .colorAccent,
                                                                                fontFamily: AppFonts
                                                                                    .INTER_BOLD,fontWeight: FontWeight.w900,
                                                                                fontSize:
                                                                                ScreenUtil().setSp(20))),
                                                                        Icon(Icons
                                                                            .thumb_up_alt_outlined,size: 22,),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: ScreenUtil().setWidth(20),
                                                                    ),


                                                                    Text(
                                                                        "Out of ${dashboard[index].totalUpvotes}\ntotal votes",
                                                                        textAlign: TextAlign.end,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: TextStyle(
                                                                            color: AppColors
                                                                                .backgoundLight,
                                                                            fontFamily: AppFonts
                                                                                .INTER_BOLD,
                                                                            fontSize:
                                                                                ScreenUtil().setSp(23)))
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ):SizedBox();
                                                  },
                                                  itemCount: dashboard.length,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(34)),
                                      child: Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 2,
                                      ),
                                    ),
                                    // Text(
                                    //   "Voting Space",
                                    //   style: TextStyle(
                                    //       color: AppColors.colorAccent,
                                    //       fontWeight: FontWeight.w700,
                                    //       fontFamily:
                                    //           AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                    //       fontSize: ScreenUtil().setSp(30)),
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.all(
                                    //       ScreenUtil().setHeight(20)),
                                    //   child: Divider(
                                    //     color: AppColors.black,
                                    //     height: 3,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(20),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        );
                      }
                  }
                },
                future: getData(widget.postId),
              ),
              Obx(() {
                return controller.showProgress.value
                    ? Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: AppColors.colorPrimary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.colorAccent)),
                        ),
                      )
                    : SizedBox();
              })
            ],
          )),
    );
  }

  Future uploadFile(String file, Data model) async {
    debugPrint("inside upload file");
    controller.changeLoader();
    if (file != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file,
              resourceType: CloudinaryResourceType.Raw),
        );

        debugPrint("inside memo received" + response.secureUrl);

        String images = "";
        if (model.gallery.isEmpty) {
        } else {
          for (int i = 0; i < model.gallery.length; i++) {
            images = images + model.gallery[i] + ",";
          }

          images = images.substring(0, images.length - 1);
        }

        //update the data
        String notes = "";
        if (model.notes.isEmpty) {
        } else {
          for (int i = 0; i < model.notes.length; i++) {
            notes = notes + model.notes[i] + "*sparks#";
          }

          notes = notes.substring(0, notes.length - 8);
        }

        if (model.voiceMsg.isEmpty) {
          memo = response.secureUrl + "date" + formattedDate;
          debugPrint("memo  is=" + "if");
        } else {
          String urls = "";

          for (int i = 0; i < model.voiceMsg.length; i++) {
            urls = urls + model.voiceMsg[i] + ",";
          }

          memo = urls + response.secureUrl + "date" + formattedDate;
          debugPrint("memo  is=" + "else" + model.voiceMsg.length.toString());
        }
        debugPrint("memo  is=" + memo);

        var data = {
          "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
          "idea_id": model.id,
          "title": model.title,
          "cover_image": model.coverImg,
          "voice_message": memo,
          "insert_type": "Detailed Add",
          "description": model.description,
          "gallery": images,
          "notes":notes,
          "interest": model.interests.toString(),
          "priority": model.priority.toString(),
          "solution_type": model.solutionType
        };

        print(data.toString());

        bool result = await Helpers.checkInternet();
        if (!result) {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, AppStrings.INTERNET_NOT_CONNECTED);
          return;
        }

        var response2 =
            await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_IDEA,
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                }),
                data: jsonEncode(data));
        // setState(() {
        //    showloader = false;
        //   });

        if (response2.statusCode == 200) {
          debugPrint(
              "response getting rawzzzz data= " + response2.data.toString());
          var result = QuickIdeaModel.fromJson(response2.data);
          if (result.status == 200) {
            if (result.success == 1) {
              // setState(() {});
              // setState(() {
              //
              // });

              ReusableWidgets.showInfo(
                  _scaffoldKey, context, "Your idea is updated successfully!");
            } else {
              ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
            }
          }

          // return LoginModel.fromJson(response.data);
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Something went wrong!");
        }
      } on Exception catch (e) {
        print("from2 " + e.toString());
        ReusableWidgets.showInfo(
            _scaffoldKey, context, e.toString());
      }

      // showProgress=false;

    }
    controller.changeLoader();
  }

  Future<DetailedIdeaModel> getData(String postId) async {
    var postData = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": postId
    };

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_DETAILED_IDEA,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(postData));

    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = DetailedIdeaModel.fromJson(response.data);
      if (result.status == 200) {
        if (result.success == 1) {
          return result;
        } else {
          ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
        }
      }
    } else {
      ReusableWidgets.showInfo(_scaffoldKey, context, "Something went wrong!");
    }
  }

  Future<DashboardModel> getDashboard(String postId) async {
    var postData = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": postId
    };
    debugPrint("valid data" + postData.toString());

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_DASHBOARD,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(postData));

    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());

      try {
        var result = DashboardModel.fromJson(response.data);
        if (result.status == 200) {
          return result;
        } else {
          //  ReusableWidgets.showInfo(_scaffoldKey, context, "No data found!");
        }
      } catch (e) {
        print("errormsg"+e.toString());
        //  ReusableWidgets.showInfo(_scaffoldKey, context, "No data found!");
      }
      //  var result = DashboardModel.fromJson(response.data);

    } else {
      ReusableWidgets.showInfo(_scaffoldKey, context, "Something went wrong!");
    }
  }

  Future<SimpleResponse> updateVoteStatus(
      String postId, String votingStatus) async {
    var postData = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": postId,
      "vote_status": votingStatus
    };

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_VOTE_STATUS,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(postData));

    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = SimpleResponse.fromJson(response.data);
      if (result.status == 200) {
        return result;
      }
    } else {
      ReusableWidgets.showInfo(_scaffoldKey, context, "Something went wrong!");
    }
  }

  Future getImage(ImageSource source, Data model) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      controller.changeLoader();
      //    controller.changeLoader();
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );
        print("response data is");
        print("from2" + response.secureUrl);
        imageToAdd = response.secureUrl;

        //update the data
        String images = "";
        if (model.gallery.isEmpty) {
          images = imageToAdd;
        } else {
          for (int i = 0; i < model.gallery.length; i++) {
            images = images + model.gallery[i] + ",";
          }

          images = images + imageToAdd;
        }

        String voiceMsg = "";
        if (model.voiceMsg.isEmpty) {
        } else {
          for (int i = 0; i < model.voiceMsg.length; i++) {
            voiceMsg = voiceMsg + model.voiceMsg[i] + ",";
          }

          voiceMsg = voiceMsg.substring(0, voiceMsg.length - 1);
        }

        String notes = "";
        if (model.notes.isEmpty) {
        } else {
          for (int i = 0; i < model.notes.length; i++) {
            notes = notes + model.notes[i] + "*sparks#";
          }

          notes = notes.substring(0, notes.length - 8);
        }

        debugPrint("imagesData1 " + images);

        debugPrint("imagesData2 " + images);

        var data = {
          "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
          "idea_id": model.id,
          "title": model.title,
          "cover_image": model.coverImg,
          "voice_message": voiceMsg,
          "insert_type": "Detailed Add",
          "description": model.description,
          "gallery": images,
          "notes": notes,
          "interest": model.interests.toString(),
          "priority": model.priority.toString(),
          "solution_type": model.solutionType
        };

        print(data.toString());

        // bool result = await Helpers.checkInternet();
        // if (result) {
        //   // setState(() {
        //   //   showloader = true;
        //   // });
        // } else {
        //   ReusableWidgets.showInfo(
        //       _scaffoldKey, context, AppStrings.INTERNET_NOT_CONNECTED);
        //   return;
        // }

        var response2 =
            await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_IDEA,
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                }),
                data: jsonEncode(data));
        if (response2.statusCode == 200) {
          debugPrint(
              "response getting rawzzzz data= " + response2.data.toString());
          var result = QuickIdeaModel.fromJson(response2.data);
          if (result.status == 200) {
            if (result.success == 1) {
              ReusableWidgets.showInfo(
                  _scaffoldKey, context, "Your idea is updated successfully!");
            } else {
              ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
            }
          }

          // return LoginModel.fromJson(response.data);
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Something went wrong!");
        }
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }
      controller.changeLoader();
    }
    setState(() {
      //showProgress = false;
    });
  }

  void showPremiumDialog(String description) {
    showDialog(
        context: (context),
        builder: (b) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColors.Dialog_background,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setHeight(60),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset("assets/images/ic_cross.png"),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Thank you for showing your interest!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFonts.CAIRO_SEMIBOLD,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(56),
                          color: AppColors.backgoundLight),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                      child: Image.asset("assets/images/ic_emoji.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: AppFonts.CAIRO_REGULAR,
                            fontSize: ScreenUtil().setSp(40),
                            color: AppColors.BUTTONTEXT_YELLOW),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Text(
                      "We are working to make a better experience. Please try this feature again later.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFonts.CAIRO_REGULAR,
                          fontSize: ScreenUtil().setSp(34),
                          color: AppColors.backgoundLight),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                  ],
                ),
              ),
            ));
  }
}
