import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/models/MyProfileModel.dart';
import 'package:sparks/models/UpdateProfileModel.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:sparks/utils/AppFonts.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/utils/ReusableWidgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool canEdit = true;
  Future _profileFuture;
  TextEditingController statusController = TextEditingController();
  MyProfileModel model;
  TextEditingController nameController = TextEditingController();
  int ideaTotalCount=0;
  final picker = ImagePicker();
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  var interest = "";
  var interestData = List<String>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _showloader = false;

  String imageCover = "";

  double divisor=5.0;

  Future<MyProfileModel> getProfile() async {
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

  @override
  void initState() {
    interest = Helpers.prefrences.getString(AppStrings.USER_INTEREST);
    if (interest != null) {
      interestData.addAll(interest.split(","));
    }
    _profileFuture = getProfile();
    _profileFuture.then((value) {
      model = value;

 if(int.parse(model.data.createdIdeasCount)>5 &&int.parse(model.data.createdIdeasCount)<11)
   {

     ideaTotalCount=int.parse(model.data.createdIdeasCount);
     divisor=10.0;
   }
 else if(int.parse(model.data.createdIdeasCount)==5  && int.parse(model.data.ideasLimit)==1)
   {
     ideaTotalCount=int.parse(model.data.createdIdeasCount);
     divisor=10.0;
   }

 else
   {
     ideaTotalCount=int.parse(model.data.createdIdeasCount);
   }

      imageCover = model.data.image;
 Helpers.prefrences.setString(AppStrings.USER_IMAGE, imageCover);

      nameController.text = model.data.firstName + " " + model.data.lastName;
      statusController.text = model.data.userStatus;

      setState(() {});
    });

    debugPrint("AAA" + Helpers.prefrences.getString(AppStrings.USER_INTEREST));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: model == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                  children: [

                    Container(
                      color: AppColors.colorPrimary,
                      height: ScreenUtil().setHeight(510),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                AbsorbPointer(
                                  absorbing: canEdit,
                                  child: Stack(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 190.0,
                                        lineWidth: 6.0,
                                        percent: 0.65,
                                        animationDuration:
                                        1200,
                                        animation: true,
                                    backgroundColor: Colors.black,
                                    progressColor: AppColors.VOTING_SPACE_BACKGROUND,
                                        center:       CircularPercentIndicator(
                                          radius: 170.0,
                                          lineWidth: 5.0,
                                          percent: 0.85,
                                          backgroundColor: Colors.black,
                                          animationDuration:
                                          1200,
                                          animation: true,
                                          progressColor: AppColors.BUTTONTEXT_YELLOW,


                                          center: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: ScreenUtil().setHeight(186),
                                              backgroundColor: Colors.transparent,
                                              child: CircleAvatar(
                                                radius: ScreenUtil().setHeight(170),
                                                backgroundImage: NetworkImage(
                                                  imageCover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ),
                                      if (!canEdit)
                                        Positioned(
                                            right: ScreenUtil().setWidth(30),
                                            top: ScreenUtil().setHeight(34),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (build) => Dialog(
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
                                                                    "Update Profile Image",
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
                                                                  "Choose Image Source",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .FONTFAMILY_ROBOTO),
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

                                                                          setState(
                                                                              () {
                                                                            _showloader =
                                                                                true;
                                                                          });
                                                                          final pickedFile =
                                                                              await picker.getImage(source: ImageSource.camera);
                                                                          print("response d " +
                                                                              pickedFile.path.toString());

                                                                          try {
                                                                            CloudinaryResponse
                                                                                response =
                                                                                await cloudinary.uploadFile(
                                                                              CloudinaryFile.fromFile(pickedFile.path, resourceType: CloudinaryResourceType.Image),
                                                                            );

                                                                            imageCover =
                                                                                response.secureUrl;
                                                                            debugPrint("data " +
                                                                                imageCover);
                                                                            setState(() {
                                                                              _showloader = false;
                                                                            });
                                                                          } on Exception catch (e) {
                                                                            setState(() {
                                                                              _showloader = false;
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
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

                                                                          setState(
                                                                              () {
                                                                            _showloader =
                                                                                true;
                                                                          });

                                                                          final pickedFile =
                                                                              await picker.getImage(source: ImageSource.gallery);
                                                                          print("response d " +
                                                                              pickedFile.path.toString());

                                                                          try {
                                                                            CloudinaryResponse
                                                                                response =
                                                                                await cloudinary.uploadFile(
                                                                              CloudinaryFile.fromFile(pickedFile.path, resourceType: CloudinaryResourceType.Image),
                                                                            );

                                                                            imageCover =
                                                                                response.secureUrl;
                                                                            debugPrint("data " +
                                                                                imageCover);
                                                                            setState(() {
                                                                              _showloader = false;
                                                                            });
                                                                          } on Exception catch (e) {
                                                                            setState(() {
                                                                              _showloader = false;
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
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
                                              child: ClipOval(
                                                  child: Container(
                                                      color: AppColors
                                                          .onBoardingColor,
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setHeight(16)),
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: AppColors.black,
                                                        size: ScreenUtil()
                                                            .setHeight(30),
                                                      ))),
                                            ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(20),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(10)),
                                  child: SizedBox(
                                    height: ScreenUtil().setHeight(40),
                                    child: TextField(
                                      controller: nameController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_SEMIBOLD,
                                          fontWeight: FontWeight.w500,
                                          fontSize: ScreenUtil().setSp(50)),
                                      onChanged: (value) {},
                                      enabled: !canEdit,
                                      decoration: InputDecoration(
                                        //  hintText:    snapshot.data.data.firstName,
                                        hintStyle: TextStyle(
                                            color: AppColors.black,
                                            fontFamily: AppFonts
                                                .FONTFAMILY_OPENSANS_BOLD,
                                            fontWeight: FontWeight.w500,
                                            fontSize: ScreenUtil().setSp(50)),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(
                                //   "Aspiring Enterpreneur",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w900,
                                //       color: Colors.white,
                                //       fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD,
                                //       fontSize: ScreenUtil().setSp(40)),
                                // ),
                                AbsorbPointer(
                                  absorbing: canEdit,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (builder) => Dialog(
                                                backgroundColor:
                                                    AppColors.onBoardingColor,
                                                child: Container(
                                                  height: ScreenUtil()
                                                      .setHeight(220),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "Select Status",
                                                            style: TextStyle(
                                                                fontFamily: AppFonts
                                                                    .FONTFAMILY_OPENSANS_BOLD,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: AppColors
                                                                    .colorAccent,
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            40)),
                                                          )),
                                                      InkWell(
                                                        onTap: () {
                                                          statusController
                                                                  .text =
                                                              AppStrings
                                                                  .Aspiring_Enterpreneur;
                                                          setState(() {});

                                                          Navigator.pop(
                                                              context);
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  new FocusNode());
                                                        },
                                                        child: Text(
                                                          AppStrings
                                                              .Aspiring_Enterpreneur,
                                                          style: TextStyle(
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_OPENSANS_REGULAR,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          30)),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          statusController
                                                                  .text =
                                                              AppStrings
                                                                  .Entrepreneur;
                                                          setState(() {});

                                                          Navigator.pop(
                                                              context);
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  new FocusNode());
                                                        },
                                                        child: Text(
                                                          "Entrepreneur",
                                                          style: TextStyle(
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_OPENSANS_REGULAR,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          30)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: SizedBox(
                                      height: ScreenUtil().setHeight(40),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: statusController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        onChanged: (value) {},
                                        enabled: false,
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontFamily: AppFonts
                                                .FONTFAMILY_OPENSANS_BOLD,
                                            fontWeight: FontWeight.w900,
                                            fontSize: ScreenUtil().setSp(50)),
                                        decoration: InputDecoration(
                                          // hintText:  snapshot.data.data.userStatus,
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: AppColors.white,
                                              fontFamily: AppFonts
                                                  .FONTFAMILY_OPENSANS_BOLD,
                                              fontWeight: FontWeight.w900,
                                              fontSize: ScreenUtil().setSp(50)),
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(40),
                          vertical: ScreenUtil().setHeight(20)),
                      child: Row(
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(16)),
                              child: Image.asset("assets/images/ic_bulb.png"),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: AppColors.colorAccent)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ideas logged",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32),
                                      fontFamily:
                                          AppFonts.FONTFAMILY_OPENSANS_REGULAR),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      model.data.createdIdeasCount,
                                      style: TextStyle(
                                          color: AppColors.YELLOW,
                                          fontSize: ScreenUtil().setSp(50),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_BOLD),
                                    ),
                                    int.parse(model.data.ideasLimit) < 2?
                                      Column(
                                        children: [
                                          Container(
                                            height: 4,
                                            width: ScreenUtil().setWidth(440),
                                            child: LinearPercentIndicator(
                                              lineHeight: 4.0,
                                              percent: ideaTotalCount/divisor,
                                              backgroundColor: Colors.grey,
                                              progressColor: Colors.blue,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              int.parse(model
                                                          .data.ideasLimit) ==
                                                      0
                                                  ? "Idea limit 5"
                                                  : "Idea limit 10",
                                              style: TextStyle(
                                                  color: AppColors
                                                      .BUTTONTEXT_YELLOW,
                                                  fontSize:
                                                      ScreenUtil().setSp(32),
                                                  fontFamily: AppFonts
                                                      .FONTFAMILY_OPENSANS_REGULAR),
                                            ),
                                          )
                                        ],
                                      ):Padding(
                                        padding:  EdgeInsets.only(left:4.0),
                                        child: Center(
                                        child: Text("Unlimited", style: TextStyle(
                                            color: AppColors
                                                .BUTTONTEXT_YELLOW,
                                            fontSize:
                                            ScreenUtil().setSp(32),
                                            fontFamily: AppFonts
                                                .FONTFAMILY_OPENSANS_BOLD,
                                        fontWeight: FontWeight.w500),),
                                    ),
                                      )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(40),
                          vertical: ScreenUtil().setWidth(20)),
                      child: Row(
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(16)),
                              child: Image.asset("assets/images/ic_share2.png"),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: AppColors.colorAccent)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20)),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Inner",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(32),
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_REGULAR),
                                    ),
                                    Text(
                                      "Circles",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(32),
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_REGULAR),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10)),
                                  child: Text(
                                    model.data.createdCirclesCount,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.BUTTONTEXT_YELLOW,
                                        fontFamily: AppFonts
                                            .FONTFAMILY_OPENSANS_SEMIBOLD,
                                        fontSize: ScreenUtil().setSp(80)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(40),
                          vertical: ScreenUtil().setWidth(20)),
                      child: Row(
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(16)),
                              child: Image.asset(
                                  "assets/images/ic_monthlycount.png"),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: AppColors.colorAccent)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20)),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Monthly",
                                      style: TextStyle(
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_REGULAR,
                                          fontSize: ScreenUtil().setSp(32)),
                                    ),
                                    Text(
                                      "Idea Rate",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(32),
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_REGULAR),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10)),
                                  child: Text(
                                    model.data.monthlyAvgIdeas.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.BUTTONTEXT_YELLOW,
                                        fontFamily: AppFonts
                                            .FONTFAMILY_OPENSANS_SEMIBOLD,
                                        fontSize: ScreenUtil().setSp(80)),
                                  ),
                                ),
                                RotatedBox(
                                    quarterTurns: -1,
                                    child: Text(
                                      "Ideas",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              AppColors.MYSIDE_COMMENT,
                                          fontFamily: AppFonts
                                              .FONTFAMILY_OPENSANS_REGULAR,
                                          fontSize: ScreenUtil().setSp(26)),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Selected interests",
                          style: TextStyle(
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                              fontSize: ScreenUtil().setSp(40),
                              fontWeight: FontWeight.w700,
                              color: AppColors.colorAccent),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: AppColors.SETTINGS_TEXT_COLOR,
                        thickness: 1,
                      ),
                    ),

                    if (interestData.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "NA",
                            style: TextStyle(
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                              fontSize: ScreenUtil().setSp(40),
                              color: AppColors.onBoardingColor,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: <Widget>[
                          Wrap(
                            spacing: 4.0,
                            runSpacing: 0.0,
                            children: List<Widget>.generate(interestData.length,
                                // place the length of the array here
                                (int index) {
                              return Chip(
                                  label: Text(interestData[index],
                                      style: TextStyle(
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO)));
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                if (_showloader) Center(child: CircularProgressIndicator())
              ],
            ),
    ));
  }

  Future<UpdateProfileModel> updateProfile(
      String updatedImage, String fname, String lname) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "first_name": fname,
      "last_name": lname,
      "image": updatedImage,
      "status_type": statusController.text
    };

    print("data isss" + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_PROFILE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = MyProfileModel.fromJson(response.data);
      if (result.status == 200) {
        canEdit = true;
        Helpers.prefrences.setString(AppStrings.USER_IMAGE, updatedImage);

        ReusableWidgets.showInfo(
            _scaffoldKey, context, "Your profile has been updated!");
        return UpdateProfileModel.fromJson(response.data);
      }

      return UpdateProfileModel.fromJson(response.data);
    } else {}
    setState(() {});
  }
}
