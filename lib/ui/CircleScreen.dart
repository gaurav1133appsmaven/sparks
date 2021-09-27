import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sparks/bloc/CircleBloc.dart';
import 'package:sparks/models/CircleDetail.dart';
import 'package:sparks/models/CircleModel.dart';
import 'package:sparks/models/CirclesListModel.dart';
import 'package:sparks/models/IdeasListModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/ui/FeedbackScreen.dart';
import 'package:sparks/ui/FullscreenImage.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/UpdateCircle.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:clipboard/clipboard.dart';

class CircleScreen extends StatefulWidget {
  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  List<Ideas> _idealist = List();
  List<Data2> _newlist = List();
  List<String> _dummyCircle = List();
  bool checkboxValueCity = false;
  List<Data2> allIdeas = [];
  List<String> selectedIdeas = [];
  List<Users> membersList = [];
  bool _showLoader = false;
  final picker = ImagePicker();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  Future<CirclesListModel> myFuture;
  String imagePath = "";

  String _membersList = "";

  TextEditingController circleNameController = TextEditingController();
  CircleDetail circleDetail = CircleDetail("", "", "", null);

  List _ideasToAdd = List<String>();

  String selectedCircleId = "";

  Data selectedCircle;

  var showPreview = false;

  String previewImage = "";

  int selectedCircleIndex = 0;

  @override
  void initState() {
    super.initState();
    // myFuture = getCircleList();
    // myFuture.then((value) {
    //     //   _dummyCircle.clear();
    //     //   _idealist.clear();
    //     //
    //     //   if (value.data.isNotEmpty) {
    //     //     _idealist.addAll(value.data[0].ideas);
    //     //     circleDetail = CircleDetail(value.data[0].name, value.data[0].image,
    //     //         value.data[0].id, value.data[0].user_names);
    //     //   }
    //     //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          body: FutureBuilder<CirclesListModel>(
              future: getCircleList(),
              builder: (c, value) {
                debugPrint("datavalues 1");
                if (!value.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: AppColors.colorPrimary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.colorAccent)),
                  );
                }
                if (value.data.data.isEmpty && selectedIndex != -1) {
                  _dummyCircle.clear();
                  _idealist.clear();
                } else {
                  if (selectedIndex != -1) {
                    _dummyCircle.clear();
                    _idealist.clear();

                    membersList.clear();
                    if (value.data.data[selectedCircleIndex].users.isNotEmpty) {
                      membersList
                          .addAll(value.data.data[selectedCircleIndex].users);
                      //    membersList.add(Users(name: "a",userId: "100"));
                    }

                    if (value.data.data.isNotEmpty) {
                      _idealist
                          .addAll(value.data.data[selectedCircleIndex].ideas);
                      circleDetail = CircleDetail(
                          value.data.data[selectedCircleIndex].name,
                          value.data.data[selectedCircleIndex].image,
                          value.data.data[selectedCircleIndex].id,
                          value.data.data[selectedCircleIndex].users);
                    }
                  } else {
                    _idealist.clear();
                  }
                }

                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Circles",
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: ScreenUtil().setSp(34),
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: ScreenUtil().setHeight(0),
                                  maxHeight: ScreenUtil().setHeight(850),
                                  maxWidth: ScreenUtil().setHeight(150)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: value.data.data.length,
                                itemBuilder: (c, index) {
                                  return InkWell(
                                    onTap: () {
                                      _dummyCircle.clear();
                                      _idealist.clear();
                                      selectedCircle = value.data.data[index];
                                      _idealist
                                          .addAll(value.data.data[index].ideas);
                                      selectedCircleIndex = index;
                                      circleDetail = CircleDetail(
                                          value.data.data[index].name,
                                          value.data.data[index].image,
                                          value.data.data[index].id,
                                          value.data.data[index].users);
                                      selectedIndex = index;
                                      selectedCircleId =
                                          value.data.data[index].id.toString();
                                      setState(() {});
                                    },
                                    child: Container(
                                      color: selectedIndex == index
                                          ? AppColors.colorPrimary
                                          : AppColors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: ScreenUtil().setWidth(100),
                                          height: ScreenUtil().setHeight(100),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                value.data.data[index].image,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: ScreenUtil().setWidth(100),
                                              height:
                                                  ScreenUtil().setHeight(100),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
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
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            InkWell(
                              onTap: () {
                                selectedIndex = -1;
                                setState(() {
                                  _dummyCircle.clear();
                                  _dummyCircle.add("");
                                  _idealist.clear();
                                  //_list.add(CircleModel());
                                });
                              },
                              child: Container(
                                width: ScreenUtil().setHeight(150),
                                color: selectedIndex == -1
                                    ? AppColors.colorPrimary
                                    : Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(10)),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.onBoardingColor,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "New\nCircle",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontFamily:
                                                  AppFonts.FONTFAMILY_ROBOTO),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.circles_background,
                          ),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: _dummyCircle.isEmpty && _idealist.isEmpty
                                    ? Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ScreenUtil()
                                                        .setHeight(40)),
                                                child: Text(
                                                  "No circles created yet!",
                                                  style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO,
                                                      fontSize: ScreenUtil()
                                                          .setSp(40)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : _dummyCircle.isEmpty &&
                                            _idealist.isNotEmpty
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(20)),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          var emailController =
                                                              TextEditingController();
                                                          showDialog(
                                                              context:
                                                                  (context),
                                                              builder: (c) =>
                                                                  Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color:
                                                                              AppColors.onBoardingColor,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30), vertical: ScreenUtil().setHeight(10)),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Text(
                                                                                        "Invite people to this inner circle",
                                                                                        style: TextStyle(fontWeight: FontWeight.w700, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontSize: ScreenUtil().setSp(32)),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: ScreenUtil().setHeight(10),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
                                                                                      child: Align(
                                                                                          alignment: Alignment.bottomLeft,
                                                                                          child: Text(
                                                                                            "Add Email(s)",
                                                                                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                          )),
                                                                                    ),
                                                                                    TextField(
                                                                                      cursorHeight: 20,
                                                                                      controller: emailController,
                                                                                      style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                      decoration: InputDecoration(
                                                                                        fillColor: Colors.white,
                                                                                        hintText: "Email separated by comma",
                                                                                        hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                        filled: true,
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                                                        ),
                                                                                        enabledBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                                                        ),
                                                                                        errorBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                                                        ),
                                                                                        focusedErrorBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: ScreenUtil().setHeight(30),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        if (emailController.text == "") {
                                                                                          ReusableWidgets.showInfo(_scaffoldKey, context, "Please enter email");
                                                                                        } else {
                                                                                          emailController.text == "";

                                                                                          Navigator.pop(context);
                                                                                          await sendInvitation(emailController.text, circleDetail.circleId);
                                                                                          ReusableWidgets.showInfo(_scaffoldKey, context, "Invite has been sent!");
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        padding: EdgeInsets.all(ScreenUtil().setHeight(28)),
                                                                                        decoration: BoxDecoration(color: AppColors.colorAccent, borderRadius: BorderRadius.circular(10)),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Send invites",
                                                                                            style: TextStyle(color: AppColors.white, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontWeight: FontWeight.w900),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                                                                                      child: Text(
                                                                                        "Or",
                                                                                        style: TextStyle(fontWeight: FontWeight.w700, fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        if (emailController.text == "") {
                                                                                          ReusableWidgets.showInfo(_scaffoldKey, context, "Please enter email");
                                                                                        } else {
                                                                                          emailController.text == "";

                                                                                          var result = await sendInvitation(emailController.text, circleDetail.circleId);

                                                                                          FlutterClipboard.copy(result.message).then((value) {
                                                                                            ReusableWidgets.showInfo(_scaffoldKey, context, "Link has been copied to clipboard");
                                                                                            Navigator.pop(context);
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        padding: EdgeInsets.all(ScreenUtil().setHeight(28)),
                                                                                        decoration: BoxDecoration(color: AppColors.colorAccent, borderRadius: BorderRadius.circular(10)),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Copy Invitation Link",
                                                                                            style: TextStyle(color: AppColors.white, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontWeight: FontWeight.w900),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: ScreenUtil().setHeight(30),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Divider(
                                                                                color: AppColors.backgoundLight,
                                                                                height: 5,
                                                                              ),
                                                                              SizedBox(
                                                                                width: double.infinity,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(12.0),
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      FocusScope.of(context).requestFocus(new FocusNode());
                                                                                    },
                                                                                    child: Text(
                                                                                      "Close",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(color: AppColors.colorAccent, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontWeight: FontWeight.w900, fontSize: ScreenUtil().setSp(38)),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )));
                                                        },
                                                        child: Container(
                                                          width: ScreenUtil()
                                                              .setWidth(60),
                                                          height: ScreenUtil()
                                                              .setHeight(60),
                                                          child: Image.asset(
                                                            "assets/images/ic_addidea.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                        )),
                                                    InkWell(
                                                      onTap: () {
                                                        deleteConfirmation();
                                                      },
                                                      child: Container(
                                                        width: ScreenUtil()
                                                            .setWidth(60),
                                                        height: ScreenUtil()
                                                            .setHeight(60),
                                                        child: Image.asset(
                                                          "assets/images/ic_delete.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                child: Text(
                                                                  circleDetail
                                                                      .circleName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .FONTFAMILY_ROBOTO_BOLD,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          ScreenUtil()
                                                                              .setSp(36)),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          10),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (c) =>
                                                                                UpdateCircle(circleDetail)));
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/ic_penciledit.png",
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          2),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  List removemembers =
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return MembersDialog(
                                                                members:
                                                                    membersList,
                                                                title:
                                                                    "Members",
                                                                submitButton:
                                                                    "Remove",
                                                                selectedMember:
                                                                    selectedIdeas,
                                                                onSelectedMemberChanged:
                                                                    (ideas) {
                                                                  selectedIdeas =
                                                                      ideas;
                                                                  print(
                                                                      selectedIdeas);
                                                                  _ideasToAdd
                                                                      .clear();
                                                                  _ideasToAdd
                                                                      .addAll(
                                                                    selectedIdeas,
                                                                  );
                                                                });
                                                          });

                                                  if (removemembers
                                                      .isNotEmpty) {
                                                    debugPrint(removemembers[0]
                                                        .toString());
                                                    if (removemembers[0] ==
                                                        Helpers.prefrences
                                                            .getString(
                                                                AppStrings
                                                                    .USER_ID)) {
                                                      selectedCircleIndex =
                                                          selectedCircleIndex -
                                                              1;
                                                      selectedIndex =
                                                          selectedIndex - 1;
                                                    }
                                                    removeMemberFromCircle(
                                                            removemembers[0]
                                                                .toString(),
                                                            circleDetail
                                                                .circleId)
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  circleDetail
                                                          .user_names.isEmpty
                                                      ? "No members yet!"
                                                      : "Participants",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO_BOLD,
                                                      color: AppColors.YELLOW,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: ScreenUtil()
                                                          .setSp(26)),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Row(
                                                    children: [
                                                      /*     Image.asset(
                                                "assets/images/ic_addgallery.png"),*/
                                                      Spacer(),
                                                      Text(
                                                        _membersList,
                                                        style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO),
                                                      )
                                                    ],
                                                  )),
                                              Divider(
                                                height:
                                                    ScreenUtil().setHeight(4),
                                                color: AppColors.black,
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              ),
                                              if (_idealist.isNotEmpty)
                                                Text(
                                                  "Hold idea to remove from circle",
                                                  style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: ScreenUtil()
                                                        .setHeight(0),
                                                    minWidth: ScreenUtil()
                                                        .setHeight(400)),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: _idealist.length,
                                                  itemBuilder: (c, i) {
                                                    return InkWell(
                                                      onLongPress: () {
                                                        ideaDeleteConfirmation(
                                                            _idealist[i].id,
                                                            circleDetail
                                                                .circleId,
                                                            _idealist.length ==
                                                                1);
                                                      },
                                                      onTap: () async {
                                                        // _idealist.addAll(value.data.data[index].ideas);
                                                        // // _idealist.clear();
                                                        // // _idealist.add("");
                                                        // setState(() {});

                                                        //disabled check for voting space
                                                        // if (_idealist[i]
                                                        //         .voteStatus ==
                                                        //     "false") {
                                                        //   ReusableWidgets.showInfo(
                                                        //       _scaffoldKey,
                                                        //       context,
                                                        //       "This idea is not available for voting.");
                                                        //
                                                        //   return;
                                                        // }

                                                        var result = await Navigator
                                                            .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            FeedbackScreen(
                                                                              idea: _idealist[i],
                                                                              circleId: circleDetail.circleId,
                                                                            )));

                                                        debugPrint("valudeata " +
                                                            result.toString());
                                                        if (result != null) {
                                                          if (result !=
                                                              "disliked") {
                                                            _idealist[i]
                                                                    .isLiked =
                                                                "false";
                                                          } else {
                                                            _idealist[i]
                                                                    .isLiked =
                                                                "true";
                                                          }
                                                        }
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 4.0),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    bottom: ScreenUtil()
                                                                        .setHeight(
                                                                            0)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: AppColors
                                                                        .white),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      width: ScreenUtil()
                                                                          .setWidth(
                                                                              150),
                                                                      height: ScreenUtil()
                                                                          .setHeight(
                                                                              150),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            _idealist[i].coverImg,
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                Container(
                                                                          width:
                                                                              ScreenUtil().setWidth(150),
                                                                          height:
                                                                              ScreenUtil().setHeight(150),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                                            image:
                                                                                DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Center(
                                                                          child: CircularProgressIndicator(
                                                                              backgroundColor: AppColors.colorPrimary,
                                                                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(Icons.error),
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20)),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(6.0),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Container(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          _idealist[i].title,
                                                                                          style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                      ),
                                                                                      if (_idealist[i].unread_count != 0)
                                                                                        Container(
                                                                                          width: ScreenUtil().setWidth(50),
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            color: AppColors.ARROW_COLOR,
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.symmetric(vertical: 2),
                                                                                            child: Text(
                                                                                              _idealist[i].unread_count.toString(),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(fontSize: ScreenUtil().setSp(26), color: AppColors.white, fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 4,
                                                                                  ),
                                                                                  Text(
                                                                                    _idealist[i].description,
                                                                                    style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, color: Colors.grey),
                                                                                    maxLines: 3,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            //  if(_idealist[i].unread_count!=0)
                                                                            //     Positioned(
                                                                            //   top:1,right:1
                                                                            //     ,child: Container(
                                                                            //       width:ScreenUtil().setWidth(50),
                                                                            //     decoration: BoxDecoration(
                                                                            //       borderRadius: BorderRadius.circular(10),
                                                                            //       color: AppColors.ARROW_COLOR,
                                                                            //     ),
                                                                            //     child: Padding(
                                                                            //       padding:  EdgeInsets.symmetric(vertical:2),
                                                                            //       child: Text(_idealist[i].unread_count.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: ScreenUtil().setSp(26),color: AppColors.white,fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                                                                            //     ),))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                                left: 0,
                                                                top: 0,
                                                                child: ClipOval(
                                                                    child: Container(
                                                                        width: 30,
                                                                        height: 30,
                                                                        child: Image.network(
                                                                          _idealist[i]
                                                                              .userImage,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ))))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(10),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(20)),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      _showLoader = true;
                                                    });
                                                    IdeasListModel result =
                                                        await getIdeasList();

                                                    setState(() {
                                                      _showLoader = false;
                                                    });
                                                    //   _idealist.clear();
                                                    allIdeas.clear();
                                                    allIdeas
                                                        .addAll(result.data);
                                                    selectedIdeas.clear();
                                                    List addItems =
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return _MyDialog(
                                                                  ideas:
                                                                      allIdeas,
                                                                  selectedIdeas:
                                                                      selectedIdeas,
                                                                  title:
                                                                      "IDEAS",
                                                                  submitButton:
                                                                      "Add",
                                                                  onSelectedIdeasListChanged:
                                                                      (ideas) {
                                                                    selectedIdeas =
                                                                        ideas;
                                                                    print(
                                                                        selectedIdeas);
                                                                    _ideasToAdd
                                                                        .clear();
                                                                    _ideasToAdd
                                                                        .addAll(
                                                                            selectedIdeas);
                                                                  });
                                                            });
                                                    String idestoAdd = "";

                                                    if (addItems != null &&
                                                        addItems.isNotEmpty) {
                                                      for (int i = 0;
                                                          i < addItems.length;
                                                          i++) {
                                                        idestoAdd = idestoAdd +
                                                            addItems[i] +
                                                            ",";
                                                      }

                                                      addIdeasInCircle(
                                                              idestoAdd,
                                                              circleDetail
                                                                  .circleId)
                                                          .then((value) {
                                                        setState(() {
                                                          _showLoader = false;
                                                        });

                                                        ReusableWidgets
                                                            .showInfo(
                                                                _scaffoldKey,
                                                                context,
                                                                value.message);

                                                        //  _idealist.clear();
                                                        _dummyCircle.clear();

                                                        setState(() {});
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    height: ScreenUtil()
                                                        .setHeight(140),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: AppColors.black,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: ScreenUtil()
                                                              .setHeight(160),
                                                          width: ScreenUtil()
                                                              .setWidth(160),
                                                          child: Icon(
                                                            Icons.add,
                                                            color:
                                                                AppColors.white,
                                                            size: ScreenUtil()
                                                                .setHeight(120),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Colors
                                                                      .white),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          160),
                                                              child: Center(
                                                                  child: Text(
                                                                "Add idea to this circle",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            32),
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .FONTFAMILY_ROBOTO_MEDIUM),
                                                              ))),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(20)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // InkWell(
                                                    //     onTap: () {
                                                    //       showDialog(
                                                    //           context: (context),
                                                    //           builder: (c) =>
                                                    //               Dialog(
                                                    //                   shape: RoundedRectangleBorder(
                                                    //                       borderRadius:
                                                    //                           BorderRadius.circular(
                                                    //                               10)),
                                                    //                   child:
                                                    //                       Container(
                                                    //                     decoration:
                                                    //                         BoxDecoration(
                                                    //                       borderRadius:
                                                    //                           BorderRadius.circular(10),
                                                    //                       color: AppColors
                                                    //                           .onBoardingColor,
                                                    //                     ),
                                                    //                     child:
                                                    //                         Column(
                                                    //                       mainAxisSize:
                                                    //                           MainAxisSize.min,
                                                    //                       children: [
                                                    //                         Padding(
                                                    //                           padding:
                                                    //                               EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30), vertical: ScreenUtil().setHeight(10)),
                                                    //                           child:
                                                    //                               Column(
                                                    //                             children: [
                                                    //                               Padding(
                                                    //                                 padding: const EdgeInsets.all(8.0),
                                                    //                                 child: Text(
                                                    //                                   "Invite people to this inner circle",
                                                    //                                   style: TextStyle(fontWeight: FontWeight.w900, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontSize: ScreenUtil().setSp(30)),
                                                    //                                 ),
                                                    //                               ),
                                                    //                               SizedBox(
                                                    //                                 height: ScreenUtil().setHeight(10),
                                                    //                               ),
                                                    //                               Padding(
                                                    //                                 padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
                                                    //                                 child: Align(
                                                    //                                     alignment: Alignment.bottomLeft,
                                                    //                                     child: Text(
                                                    //                                       "Add Email(s)",
                                                    //                                       style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                    //                                     )),
                                                    //                               ),
                                                    //                               TextField(
                                                    //                                 cursorHeight: 20,
                                                    //                                 controller: emailController,
                                                    //                                 decoration: InputDecoration(
                                                    //                                   fillColor: Colors.white,
                                                    //                                   hintText: "Email separated by comma",
                                                    //                                   hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                    //                                   filled: true,
                                                    //                                   focusedBorder: OutlineInputBorder(
                                                    //                                     borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                    //                                   ),
                                                    //                                   enabledBorder: OutlineInputBorder(
                                                    //                                     borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                    //                                   ),
                                                    //                                   errorBorder: OutlineInputBorder(
                                                    //                                     borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                    //                                   ),
                                                    //                                   focusedErrorBorder: OutlineInputBorder(
                                                    //                                     borderSide: BorderSide(color: AppColors.white, width: 2.0),
                                                    //                                   ),
                                                    //                                 ),
                                                    //                               ),
                                                    //                               SizedBox(
                                                    //                                 height: ScreenUtil().setHeight(30),
                                                    //                               ),
                                                    //                               InkWell(
                                                    //                                 onTap: (){
                                                    //
                                                    //                                 },
                                                    //                                 child: Container(
                                                    //                                   width: double.infinity,
                                                    //                                   padding: EdgeInsets.all(ScreenUtil().setHeight(24)),
                                                    //                                   decoration: BoxDecoration(color: AppColors.colorAccent, borderRadius: BorderRadius.circular(10)),
                                                    //                                   child: Center(
                                                    //                                     child: Text(
                                                    //                                       "Send invites",
                                                    //                                       style: TextStyle(color: AppColors.white, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontWeight: FontWeight.w900),
                                                    //                                     ),
                                                    //                                   ),
                                                    //                                 ),
                                                    //                               ),
                                                    //                               Padding(
                                                    //                                 padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                                                    //                                 child: Text(
                                                    //                                   "Or",
                                                    //                                   style: TextStyle(fontWeight: FontWeight.w700, fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                                                    //                                 ),
                                                    //                               ),
                                                    //                               InkWell(
                                                    //                                 onTap: (){
                                                    //
                                                    //
                                                    //
                                                    //                                 },
                                                    //                                 child: Container(
                                                    //                                   width: double.infinity,
                                                    //                                   padding: EdgeInsets.all(ScreenUtil().setHeight(24)),
                                                    //                                   decoration: BoxDecoration(color: AppColors.colorAccent, borderRadius: BorderRadius.circular(10)),
                                                    //                                   child: Center(
                                                    //                                     child: Text(
                                                    //                                       "Copy Invitation Link",
                                                    //                                       style: TextStyle(color: AppColors.white, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontWeight: FontWeight.w900),
                                                    //                                     ),
                                                    //                                   ),
                                                    //                                 ),
                                                    //                               ),
                                                    //                               SizedBox(
                                                    //                                 height: ScreenUtil().setHeight(30),
                                                    //                               ),
                                                    //                             ],
                                                    //                           ),
                                                    //                         ),
                                                    //                         Divider(
                                                    //                           color:
                                                    //                               AppColors.backgoundLight,
                                                    //                           height:
                                                    //                               5,
                                                    //                         ),
                                                    //                         Padding(
                                                    //                           padding:
                                                    //                               const EdgeInsets.all(12.0),
                                                    //                           child:
                                                    //                               InkWell(
                                                    //                             onTap: () {
                                                    //                               Navigator.pop(context);
                                                    //                               FocusScope.of(context).requestFocus(new FocusNode());
                                                    //                             },
                                                    //                             child: Text(
                                                    //                               "Close",
                                                    //                               style: TextStyle(color: AppColors.colorAccent, fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD, fontWeight: FontWeight.w900, fontSize: ScreenUtil().setSp(38)),
                                                    //                             ),
                                                    //                           ),
                                                    //                         )
                                                    //                       ],
                                                    //                     ),
                                                    //                   )));
                                                    //     },
                                                    //     child: Image.asset(
                                                    //         "assets/images/ic_addidea.png")),
                                                    Text(
                                                      "Circle name",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: ScreenUtil()
                                                              .setSp(36)),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: ScreenUtil()
                                                                .setWidth(20)),
                                                        child: TextField(
                                                          cursorHeight: 20,
                                                          controller:
                                                              circleNameController,
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .sentences,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_ROBOTO_MEDIUM),
                                                          decoration:
                                                              InputDecoration(
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  width: 2.0),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  width: 2.0),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  width: 2.0),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  width: 2.0),
                                                            ),
                                                            hintStyle: TextStyle(
                                                                fontFamily: AppFonts
                                                                    .FONTFAMILY_ROBOTO_MEDIUM),
                                                            hintText:
                                                                "Add circle name",
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(20)),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (build) =>
                                                                        Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                  color: AppColors.colorPrimary,
                                                                                ),
                                                                                padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Add Circle Image",
                                                                                    style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, fontWeight: FontWeight.w700, color: AppColors.white, fontSize: ScreenUtil().setSp(36)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                                                                                child: Text(
                                                                                  "Choose Image Source",
                                                                                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO, fontSize: ScreenUtil().setSp(30)),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          Navigator.pop(context);
                                                                                          FocusScope.of(context).requestFocus(new FocusNode());
                                                                                          getImage(ImageSource.camera);
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            "Camera",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          Navigator.pop(context);
                                                                                          FocusScope.of(context).requestFocus(new FocusNode());
                                                                                          getImage(ImageSource.gallery);
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            "Gallery",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
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
                                                          child: Image.asset(
                                                              "assets/images/ic_addgallery.png"),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setWidth(10),
                                                        ),
                                                        if (showPreview)
                                                          Column(
                                                            children: [
                                                              // Text(
                                                              //   "Preview",
                                                              //   style: TextStyle(
                                                              //       fontFamily:
                                                              //           AppFonts
                                                              //               .FONTFAMILY_ROBOTO_BOLD,
                                                              //       fontWeight:
                                                              //           FontWeight
                                                              //               .w800,
                                                              //       color: AppColors
                                                              //           .colorAccent),
                                                              // ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => FullscreenImage(
                                                                                image: previewImage,
                                                                              )));
                                                                  FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          new FocusNode());
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: ScreenUtil()
                                                                      .setWidth(
                                                                          90),
                                                                  height: ScreenUtil()
                                                                      .setHeight(
                                                                          80),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(color: Colors.black, width: 1),
                                                                      borderRadius: BorderRadius.circular(6),
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(
                                                                            previewImage,
                                                                          ),
                                                                          fit: BoxFit.fill)),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        previewImage,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      width: ScreenUtil()
                                                                          .setWidth(
                                                                              250),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                        // borderRadius: BorderRadius.all(
                                                                        //     Radius.circular(
                                                                        //         ScreenUtil().setHeight(20))),
                                                                      ),
                                                                    ),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Center(
                                                                      child: CircularProgressIndicator(
                                                                          backgroundColor: AppColors
                                                                              .colorPrimary,
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        Spacer(),
                                                        Text(
                                                          "Invite members to join",
                                                          style: TextStyle(
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_ROBOTO_MEDIUM,
                                                              color: AppColors
                                                                  .backgoundLight),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ScreenUtil()
                                                        .setHeight(30)),
                                                child: Divider(
                                                  color: AppColors.black,
                                                  height: ScreenUtil()
                                                      .setHeight(10),
                                                ),
                                              ),
                                              if (_newlist.isNotEmpty)
                                                Text(
                                                  "Hold idea to remove from circle",
                                                  style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: ScreenUtil()
                                                        .setHeight(0),
                                                    maxHeight: ScreenUtil()
                                                        .setHeight(2000),
                                                    minWidth: ScreenUtil()
                                                        .setHeight(400)),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: _newlist.length,
                                                  itemBuilder: (c, i) {
                                                    return Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            0)),
                                                        child: InkWell(
                                                          onLongPress: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (build) =>
                                                                        Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(color: AppColors.colorPrimary, borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                                                                padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Delete idea",
                                                                                    style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, fontWeight: FontWeight.w700, color: AppColors.white, fontSize: ScreenUtil().setSp(36)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                                                                                child: Text(
                                                                                  "Are you sure you want to\ndelete this Idea?",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO, fontSize: ScreenUtil().setSp(34)),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          Navigator.pop(context);
                                                                                          FocusScope.of(context).requestFocus(new FocusNode());
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            "No",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          Navigator.pop(context);
                                                                                          FocusScope.of(context).requestFocus(new FocusNode());
                                                                                          _newlist.removeAt(i);
                                                                                          setState(() {});
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            "Yes",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4.0),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            ScreenUtil().setHeight(0)),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        color: AppColors
                                                                            .white),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              ScreenUtil().setWidth(150),
                                                                          height:
                                                                              ScreenUtil().setHeight(150),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                _newlist[i].coverImg,
                                                                            imageBuilder: (context, imageProvider) =>
                                                                                Container(
                                                                              width: ScreenUtil().setWidth(150),
                                                                              height: ScreenUtil().setHeight(150),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                                                image: DecorationImage(
                                                                                  image: imageProvider,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            placeholder: (context, url) =>
                                                                                Center(
                                                                              child: CircularProgressIndicator(backgroundColor: AppColors.colorPrimary, valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                                                                            ),
                                                                            errorWidget: (context, url, error) =>
                                                                                Icon(Icons.error),
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(6.0),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  _newlist[i].title,
                                                                                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, fontWeight: FontWeight.w500),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 4,
                                                                                ),
                                                                                Text(
                                                                                  _newlist[i].description,
                                                                                  style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM, color: Colors.grey),
                                                                                  maxLines: 3,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                    left: 0,
                                                                    top: 0,
                                                                    child: ClipOval(
                                                                        child: Container(
                                                                            width: 30,
                                                                            height: 30,
                                                                            child: Image.network(
                                                                              _newlist[i].user_image,
                                                                              fit: BoxFit.cover,
                                                                            ))))
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(20)),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      _showLoader = true;
                                                    });
                                                    IdeasListModel result =
                                                        await getIdeasList();
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            new FocusNode());
                                                    setState(() {
                                                      _showLoader = false;
                                                    });
                                                    debugPrint("zzzzzzz" +
                                                        result.data.length
                                                            .toString());
                                                    debugPrint("zzzzzzz" +
                                                        result.data.isEmpty
                                                            .toString());
                                                    if (result.data.isEmpty) {
                                                      ReusableWidgets.showInfo(
                                                          _scaffoldKey,
                                                          context,
                                                          "No ideas created yet!");
                                                      return null;
                                                    }
                                                    _idealist.clear();
                                                    selectedIdeas.clear();
                                                    allIdeas.clear();
                                                    allIdeas
                                                        .addAll(result.data);

                                                    List r = await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return _MyDialog(
                                                              ideas: allIdeas,
                                                              selectedIdeas:
                                                                  selectedIdeas,
                                                              title: "IDEAS",
                                                              submitButton:
                                                                  "Add",
                                                              onSelectedIdeasListChanged:
                                                                  (ideas) {
                                                                selectedIdeas =
                                                                    ideas;
                                                                // _ideasToAdd
                                                                //     .clear();
                                                                _ideasToAdd.addAll(
                                                                    selectedIdeas);
                                                              });
                                                        });

                                                    if (r == null) return;

                                                    // _newlist.clear();
                                                    for (int i = 0;
                                                        i < allIdeas.length;
                                                        i++) {
                                                      for (int j = 0;
                                                          j < r.length;
                                                          j++) {
                                                        if (allIdeas[i].id ==
                                                            r[j]) {
                                                          _newlist
                                                              .add(allIdeas[i]);
                                                        }
                                                      }
                                                    }

                                                    setState(() {});

                                                    debugPrint("returned +" +
                                                        r.toString());
                                                  },
                                                  child: Container(
                                                    height: ScreenUtil()
                                                        .setHeight(140),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: AppColors.black,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: ScreenUtil()
                                                              .setHeight(160),
                                                          width: ScreenUtil()
                                                              .setWidth(160),
                                                          child: Icon(
                                                            Icons.add,
                                                            color:
                                                                AppColors.white,
                                                            size: ScreenUtil()
                                                                .setHeight(120),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Colors
                                                                      .white),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          160),
                                                              child: Center(
                                                                  child: Text(
                                                                "Add idea to this circle",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            32),
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .FONTFAMILY_ROBOTO_MEDIUM),
                                                              ))),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(30),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(20)),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (circleNameController
                                                            .text ==
                                                        "") {
                                                      ReusableWidgets.showInfo(
                                                          _scaffoldKey,
                                                          context,
                                                          "Please enter circle name");

                                                      return;
                                                    } else if (imagePath ==
                                                        "") {
                                                      ReusableWidgets.showInfo(
                                                          _scaffoldKey,
                                                          context,
                                                          "Please select a image for circle");
                                                      return;
                                                    } else if (_newlist
                                                        .isEmpty) {
                                                      ReusableWidgets.showInfo(
                                                          _scaffoldKey,
                                                          context,
                                                          "Add some items to circle");

                                                      return;
                                                    } else {
                                                      var ids_to_add = "";
                                                      for (int i = 0;
                                                          i < _newlist.length;
                                                          i++) {
                                                        ids_to_add =
                                                            ids_to_add +
                                                                _newlist[i].id +
                                                                ",";
                                                      }

                                                      print("BigData " +
                                                          ids_to_add);
                                                      setState(() {
                                                        _showLoader = true;
                                                      });
                                                      createCircle(ids_to_add)
                                                          .then((value) {
                                                        ReusableWidgets.showInfo(
                                                            _scaffoldKey,
                                                            context,
                                                            "Circle has been created!");
                                                        // Navigator.pop(context);
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HomeScreen(
                                                                              selectPage: 1,
                                                                            )),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    true);
                                                      });
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        0)),
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setHeight(40)),
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .colorAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Center(
                                                        child: Text(
                                                          "Create circle",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily: AppFonts
                                                                  .FONTFAMILY_ROBOTO_MEDIUM,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          36)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                              )
                                            ],
                                          ),
                              ),
                              if (_showLoader)
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      backgroundColor: AppColors.colorPrimary,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.colorAccent)),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Future<IdeasListModel> getIdeasList() async {
    var data = {"user_id": Helpers.prefrences.getString(AppStrings.USER_ID)};
    debugPrint("userId" + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOWIDEAS,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));

    debugPrint("raw data=" + response.toString());
    if (response.statusCode == 200) {
      return IdeasListModel.fromJson(response.data);
    }
  }

  Future<CirclesListModel> getCircleList() async {
    var data = {"user_id": Helpers.prefrences.getString(AppStrings.USER_ID)};
    //  var data = {"user_id": "1"};

    print("data isss" + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_CIRCLES,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = CirclesListModel.fromJson(response.data);
      if (result.status == 200) {
        return CirclesListModel.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      try {
        setState(() {
          _showLoader = true;
        });
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );
        print("response data is");
        print("from2" + response.secureUrl);
        imagePath = response.secureUrl;
        previewImage = imagePath;
        showPreview = true;
        setState(() {
          _showLoader = false;
        });
      } on Exception catch (e) {
        print("from2 " + e.toString());
        setState(() {
          _showLoader = false;
        });
      }
    }
  }

  Future<SimpleResponse> createCircle(String ids) async {
    if (ids.length > 0) {
      ids = ids.substring(0, ids.length - 1);
    }
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "name": circleNameController.text,
      "image": imagePath,
      "ideas": ids,
    };

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.ADD_CIRCLE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = CirclesListModel.fromJson(response.data);
      if (result.status == 200) {
        debugPrint("datavalues 2");
        getCircleList().then((value) {
          _dummyCircle.clear();
          _idealist.clear();

          if (value.data.isNotEmpty) {
            _idealist.clear();
            _idealist.addAll(value.data[0].ideas);
            circleDetail = CircleDetail(value.data[0].name, value.data[0].image,
                value.data[0].id, value.data[0].users);
          }

          setState(() {});
        });
        return SimpleResponse.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}

    setState(() {
      _showLoader = false;
    });
  }

  Future<SimpleResponse> addIdeasInCircle(
      String ideasList, String circleId) async {
    if (ideasList.length > 0) {
      ideasList = ideasList.substring(0, ideasList.length - 1);
    }
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "circle_id": circleId,
      "idea_id": ideasList
    };

    setState(() {
      _showLoader = true;
    });
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.ADD_CIRCLE_IDEAS,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    debugPrint("data checking" + response.data.toString());
    if (response.statusCode == 200) {
      debugPrint("data check" + data.toString());
      debugPrint("data check" + response.data.toString());
      var result = SimpleResponse.fromJson(response.data);
      if (result.status == 200) {
        return SimpleResponse.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}

    setState(() {
      _showLoader = false;
    });
  }

  Future<SimpleResponse> sendInvitation(String emails, String circleId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "email": emails
    };
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + "send-invitation/${circleId}",
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));

    if (response.statusCode == 200) {
      return SimpleResponse.fromJson(response.data);
    } else {
      ReusableWidgets.showInfo(_scaffoldKey, context, "Something went wrong!");
    }
  }

  void deleteConfirmation() {
    showDialog(
        context: context,
        builder: (build) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Center(
                      child: Text(
                        "Delete Circle",
                        style: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            fontSize: ScreenUtil().setSp(36)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                    child: Text(
                      "Are you sure you want to\ndelete this circle?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                          fontSize: ScreenUtil().setSp(34)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "No",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              deleteCircle(circleDetail.circleId).then((value) {
                                showCircleDeleteDialog();
                                setState(() {
                                  selectedCircleIndex = 0;
                                  selectedIndex = 0;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO),
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
  }

  void ideaDeleteConfirmation(String ideaId, String circleId, bool islastidea) {
    showDialog(
        context: context,
        builder: (build) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Center(
                      child: Text(
                        "Delete idea",
                        style: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            fontSize: ScreenUtil().setSp(36)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                    child: Text(
                      "Are you sure you want to\ndelete this idea?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                          fontSize: ScreenUtil().setSp(34)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Text(
                              "No",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              if (islastidea) {
                                selectedCircleIndex = selectedCircleIndex - 1;
                                selectedIndex = selectedIndex - 1;
                              }
                              deleteIdeaFromCircle(ideaId, circleId)
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Text(
                              "Yes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Future<SimpleResponse> deleteCircle(String circleId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "circle_id": circleId
    };
    debugPrint("circleID " + circleId);

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.DELETE_SINGLE_CIRCLE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.toString());

      return SimpleResponse.fromJson(response.data);
    }
  }

  Widget showCircleDeleteDialog() {
    return Dialog(
      child: Text("Circle deleted successfully!"),
    );
    setState(() {});
  }

  Future deleteIdeaFromCircle(String ideaId, String circleId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "circle_id": circleId,
      "idea_id": ideaId
    };

    debugPrint("data to send " + data.toString());

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.DELTE_SINGLE_IDEA_CIRCLE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.toString());

      return SimpleResponse.fromJson(response.data);
    }
  }

  Future removeMemberFromCircle(String id, String circleId) async {
    var data = {
      "user_id": id,
      "circle_id": circleId,
    };

    debugPrint("data to send " + data.toString());

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.DELTE_USER_FROM_CIRCLE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.toString());

      return SimpleResponse.fromJson(response.data);
    }
  }
}

class _MyDialog extends StatefulWidget {
  _MyDialog(
      {this.ideas,
      this.selectedIdeas,
      this.onSelectedIdeasListChanged,
      this.title,
      this.submitButton});

  final List<Data2> ideas;
  final List<String> selectedIdeas;
  final ValueChanged<List<String>> onSelectedIdeasListChanged;
  String title = "IDEAS";
  String submitButton = "Add";

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<String> _tempSelectedIdeas = [];

  @override
  void initState() {
    _tempSelectedIdeas = widget.selectedIdeas;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: ScreenUtil().setHeight(600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.black,
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context, widget.selectedIdeas);
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    color: AppColors.colorPrimary,
                    child: Text(
                      widget.submitButton,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.ideas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ideaName = widget.ideas[index];
                    return Container(
                      child: CheckboxListTile(
                          title: Text(
                            ideaName.title,
                            style: TextStyle(
                                color: AppColors.colorAccent,
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                fontWeight: FontWeight.w900),
                          ),
                          value: _tempSelectedIdeas.contains(ideaName.id),
                          onChanged: (bool value) {
                            if (value) {
                              if (!_tempSelectedIdeas.contains(ideaName.id)) {
                                setState(() {
                                  _tempSelectedIdeas.add(ideaName.id);
                                });
                              }
                            } else {
                              if (_tempSelectedIdeas.contains(ideaName.id)) {
                                setState(() {
                                  _tempSelectedIdeas.removeWhere(
                                      (String idea) => idea == ideaName.id);
                                });
                              }
                            }
                            widget
                                .onSelectedIdeasListChanged(_tempSelectedIdeas);
                          }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class MembersDialog extends StatefulWidget {
  MembersDialog(
      {this.members,
      this.selectedMember,
      this.onSelectedMemberChanged,
      this.title,
      this.submitButton});

  final List<Users> members;
  final List<String> selectedMember;
  final ValueChanged<List<String>> onSelectedMemberChanged;
  String title = "IDEAS";
  String submitButton = "Add";

  @override
  MembersDialogState createState() => MembersDialogState();
}

class MembersDialogState extends State<MembersDialog> {
  List<String> _tempSelectedMember = [];

  @override
  void initState() {
    _tempSelectedMember = widget.selectedMember;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: ScreenUtil().setHeight(600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.black,
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context, widget.selectedMember);
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    color: AppColors.colorPrimary,
                    child: Text(
                      widget.submitButton,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.members.length,
                  itemBuilder: (BuildContext context, int index) {
                    final member = widget.members[index];
                    return Container(
                      child: CheckboxListTile(
                          title: Text(
                            member.name,
                            style: TextStyle(
                                color: AppColors.colorAccent,
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                fontWeight: FontWeight.w900),
                          ),
                          value: _tempSelectedMember.contains(member.userId),
                          onChanged: (bool value) {
                            if (value) {
                              if (!_tempSelectedMember
                                  .contains(member.userId)) {
                                setState(() {
                                  for (int i = 0;
                                      i < _tempSelectedMember.length;
                                      i++) {
                                    if (_tempSelectedMember[i] !=
                                        member.userId) {
                                      _tempSelectedMember.removeAt(i);
                                    }
                                  }
                                  _tempSelectedMember.add(member.userId);
                                });
                              }
                            } else {
                              if (_tempSelectedMember.contains(member.userId)) {
                                setState(() {
                                  _tempSelectedMember.removeWhere(
                                      (String idea) => idea == member.userId);
                                });
                              }
                            }
                            widget.onSelectedMemberChanged(_tempSelectedMember);
                          }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
