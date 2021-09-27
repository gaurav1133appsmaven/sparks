import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/bloc/FeedbackController.dart';
import 'package:sparks/bloc/IdeaDetailController.dart';
import 'package:sparks/models/CirclesListModel.dart';
import 'package:sparks/models/CommentsModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:get/get.dart';


class FeedbackScreen extends StatefulWidget {
  Ideas idea;
  String circleId;

  FeedbackScreen({this.idea,this.circleId});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  var liked;
  var disliked;
  final _controller = ScrollController();
  List<CommentsData> commentsList = List();
FeedbackController feedbackController=Get.put(FeedbackController());
  TextEditingController textController = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    debugPrint("data liked---->" + widget.idea.isLiked);
    if (widget.idea.isLiked == "true") {
      liked = "true";
    } else {
      liked = "false";
    }

    if (widget.idea.isLiked == "false") {
      disliked = "true";
    } else {
      disliked = "false";
    }

    debugPrint("data liked" + liked.toString());
    super.initState();
  }

  Future<CommentsModel> getComments() async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": widget.idea.id,
      "circle_id":widget.circleId,
    };

    print("data isss" + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_COMMENTS,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = CommentsModel.fromJson(response.data);
      if (result.status == 200) {
        return CommentsModel.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}
  }

  Future<SimpleResponse> likedislike(value) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "relation_id": widget.idea.relationId,
      "is_liked": value.toString()
    };

    print("data " + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.LIKES_DISLIKES,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response " + response.data.toString());
      var result = SimpleResponse.fromJson(response.data);
      if (result.status == 200) {
        return SimpleResponse.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: ScreenUtil().setHeight(ScreenUtil().setHeight(800)),
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: widget.idea.coverImg,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                            backgroundColor: AppColors.colorPrimary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorAccent)),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(ScreenUtil().setHeight(800)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            String value=null;
                            if(disliked=="true")
                              {
                                value="disliked";
                              }
                            else if(liked=="true")
                              {
                                value="liked";
                              }
                            Navigator.pop(context,value);
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/ic_close.png",
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(20),
                              vertical: ScreenUtil().setHeight(20)),
                          child: Row(
                            children: [
                              // Image.asset("assets/images/ic_info.png",
                              //     color: Colors.white),

                              ClipOval(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    widget.idea.userImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(


                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              likedislike(true).then((value) {
                                                liked = "true";
                                                disliked="false";

                                                setState(() {});
                                              });
                                            },
                                            child: Container(
                                              child: liked == "true"
                                                  ? Icon(Icons.thumb_up,
                                                      color: Colors.white)
                                                  : Icon(
                                                      Icons.thumb_up_alt_outlined,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(20),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              likedislike(false).then((value) {
                                                disliked = "true";
                                                liked="false";
                                                setState(() {});
                                              });
                                            },
                                            child: Container(
                                              child: disliked == "true"
                                                  ? Icon(Icons.thumb_down,
                                                      color: Colors.white)
                                                  : Icon(
                                                      Icons.thumb_down_alt_outlined,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(20),
                                    ),
                                    Text(
                                      widget.idea.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(64),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_BOLD),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: 2000, minHeight: 20.0),
                    child: FutureBuilder<CommentsModel>(
                      future: getComments(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: AppColors.colorPrimary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.colorAccent)),
                          );
                        } else if (snapshot.hasData &&
                            snapshot.data.data.isEmpty) {
                          return Center(
                            child: Text(
                              "No comments yet!",
                              style: TextStyle(
                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                  fontSize: ScreenUtil().setSp(36)),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _controller,
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (a, b) {
                            return showMessage(snapshot.data.data[b]);
                          },
                        );
                      },
                    )),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintText: AppStrings.ENTER_TEXT,

                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(10)),
                              hintStyle:
                                  TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              filled: true,
                              fillColor: AppColors.onBoardingColor),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            if (textController.text.trim() == "") {
                              ReusableWidgets.showInfo(_scaffoldKey, context,
                                  "Please enter some text.");
                            } else {
                              feedbackController.chnageLoadingStatus();
                              addnewComment(textController.text).then((value) {
                                feedbackController.chnageLoadingStatus();
                                setState(() {
                                  textController.text = "";

                                  if (commentsList.isNotEmpty) {
                                    _controller.animateTo(
                                      0.0,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 300),
                                    );
                                  }
                                });
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              });
                            }
                          },
                          child: Obx((){



                            return feedbackController.showLoading.value?SizedBox(width: 27,height: 27,child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(),
                            )):Icon(
                              Icons.send_sharp,
                              size: ScreenUtil().setHeight(50),
                            );

                          })



                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showMessage(CommentsData data) {
    if (data.userId == Helpers.prefrences.getString(AppStrings.USER_ID)) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top:ScreenUtil().setHeight(10),left:ScreenUtil().setHeight(10) ),
                decoration: BoxDecoration(
                    color: AppColors.MYSIDE_COMMENT,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                width: 200,
                height: ScreenUtil().setHeight(120),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      data.comment,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: AppFonts.INTER_MEDIUM,
                          color: AppColors.black),
                    ),
                  ),
                ),
              ),


              Positioned(
                  left: 0,
                  top: 0,
                  child: ClipOval(
                      child: Container(
                        width: 20,height: 20,
                        child: data.userImage == null?Image.asset(
                          "assets/images/ic_imageplaceholder.png",fit: BoxFit.fill,
                        ):Image.network(data.userImage,fit: BoxFit.fill,),


                      )
                  )),
            ],
          ),
        ),
      );
    } else {


      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top:ScreenUtil().setHeight(10),right:ScreenUtil().setHeight(10) ),
                decoration: BoxDecoration(
                    color: AppColors.BUTTONTEXT_YELLOW,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    )),
                width: 200,
                height: ScreenUtil().setHeight(120),
                child: Center(
                  child: Text(
                    data.comment,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: AppFonts.INTER_MEDIUM,
                        color: AppColors.black),
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: ClipOval(
                    child: Container(
                      width: 20,height: 20,
                      child: data.userImage == null?Image.asset(
                             "assets/images/ic_imageplaceholder.png",fit: BoxFit.fill,
                           ):Image.network(data.userImage,fit: BoxFit.fill,),


                    )
                  )),
            ],
          ),
        ),
      );

      // return Align(
      //   alignment: Alignment.centerLeft,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Stack(
      //       children: [
      //         Container(
      //           margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
      //           decoration: BoxDecoration(
      //               color: AppColors.BUTTONTEXT_YELLOW,
      //               borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(0),
      //                 bottomRight: Radius.circular(10),
      //                 topRight: Radius.circular(10),
      //                 topLeft: Radius.circular(10),
      //               )),
      //           width: 200,
      //           height: ScreenUtil().setHeight(120),
      //           child: Center(
      //             child: Text(
      //               data.comment,
      //               style: TextStyle(
      //                   fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
      //                   color: AppColors.white),
      //             ),
      //           ),
      //         ),
      //         Positioned(
      //             right: 0,
      //             top: 0,
      //             child: ClipOval(
      //               child: data.userImage == null
      //                   ? Container(
      //                 width: 4,
      //                       height: 4,
      //
      //                       child: Image.asset(
      //                         "assets/images/ic_imageplaceholder.png",
      //                       ))
      //                   : Image.network(data.userImage),
      //             )),
      //       ],
      //     ),
      //   ),
      // );
    }
  }

  Future<SimpleResponse> addnewComment(String text) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": widget.idea.id,
      "circle_id":widget.circleId,
      "relation_id":widget.idea.relationId,
      "message": text
    };

    print("data isss" + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.ADD_COMMENT,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw datsa= " + response.data.toString());
      var result = SimpleResponse.fromJson(response.data);
      if (result.status == 200) {
        return SimpleResponse.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}
  }
}
