import 'dart:convert';
import 'dart:io';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/models/CircleDetail.dart';
import 'package:sparks/models/UpdateCircleModel.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:dio/dio.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UpdateCircle extends StatefulWidget {
  CircleDetail _circleDetail;

  UpdateCircle(this._circleDetail);

  @override
  _UpdateCircleState createState() => _UpdateCircleState();
}

class _UpdateCircleState extends State<UpdateCircle> {
  TextEditingController nameController = TextEditingController();
  final picker = ImagePicker();
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _showloader = false;

  String imageCover = "";

  @override
  void initState() {
    imageCover = widget._circleDetail.circleImage;
    nameController.text=widget._circleDetail.circleName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.onBoardingColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/images/ic_close.png",color: AppColors.white,),),
        centerTitle: true,
        title: Text(
          "Update circle",
          style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                ClipOval(
                  child: Container(
                    width: 280,
                    height: 280,
                    color: AppColors.onBoardingColor,
                    child: CachedNetworkImage(
                      imageUrl: imageCover,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
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
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () async {
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.camera);
                              print("response d " + pickedFile.path.toString());
setState(() {
  _showloader=true;
});
                              try {
                                CloudinaryResponse response =
                                    await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(pickedFile.path,
                                      resourceType:
                                          CloudinaryResourceType.Image),
                                );

                                imageCover = response.secureUrl;
                                debugPrint("data " + imageCover);
                                setState(() {
                                  _showloader = false;
                                });
                              } on Exception catch (e) {
                                setState(() {
                                  _showloader = false;
                                });
                              }
                              setState(() {
                                _showloader=false;
                              });
                            },
                            child: SizedBox(
                              height: ScreenUtil().setHeight(60),
                              width: ScreenUtil().setWidth(60),
                              child: Image.asset(
                                "assets/images/ic_camera.png",
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            )),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           "or",
                           style: TextStyle(
                             color: AppColors.white,
                             fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                             fontWeight: FontWeight.w700
                           ),
                         ),
                       ),
                        InkWell(
                            onTap: () async {
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.gallery);
                              print("response d " + pickedFile.path.toString());
setState(() {
  _showloader=true;
});
                              try {
                                CloudinaryResponse response =
                                    await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(pickedFile.path,
                                      resourceType:
                                          CloudinaryResourceType.Image),
                                );

                                imageCover = response.secureUrl;
                                debugPrint("data " + imageCover);
                                setState(() {
                                  _showloader = false;
                                });
                              } on Exception catch (e) {
                                setState(() {
                                  _showloader = false;
                                });
                              }
                              setState(() {
                                _showloader=false;
                              });
                            },
                            child: SizedBox(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(50),
                                child: Image.asset(
                                  "assets/images/ic_addgallery.png",
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                )))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(40),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(10),
                        horizontal: ScreenUtil().setWidth(30)),
                    child: Text(
                      "Circle Name",
                      style: TextStyle(
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(30)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(10),
                      horizontal: ScreenUtil().setWidth(30)),
                  child: Container(
                    height: ScreenUtil().setHeight(90),
                    child: TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.sentences,
                      cursorHeight: 20,
                      style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: widget._circleDetail.circleName,
                        hintStyle: TextStyle(color: AppColors.backgoundLight),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30),
                    vertical: ScreenUtil().setHeight(30),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _showloader = true;
                        });
                        if (nameController.text == "") {
                          //   ReusableWidgets.showInfo(_scaffoldKey, context, "Please enter name");
                          nameController.text = widget._circleDetail.circleName;
                          updateCircle(widget._circleDetail.circleId,
                                  nameController.text, imageCover)
                              .then((value) {
                            setState(() {
                              _showloader = false;
                            });

                            ReusableWidgets.showInfo(_scaffoldKey, context,
                                "Circle has been updated!");
                            // Navigator.pop(context);
                            Future.delayed(Duration(seconds: 1), () {
                              // 5s over, navigate to a new page
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            selectPage: 1,
                                          )),
                                  (Route<dynamic> route) => true);
                            });
                          });
                        } else {
                          updateCircle(widget._circleDetail.circleId,
                                  nameController.text, imageCover)
                              .then((value) {
                            setState(() {
                              _showloader = false;
                            });

                            ReusableWidgets.showInfo(_scaffoldKey, context,
                                "Circle has been updated!");
                            // Navigator.pop(context);
                            Future.delayed(Duration(seconds: 1), () {
                              // 5s over, navigate to a new page
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            selectPage: 1,
                                          )),
                                  (Route<dynamic> route) => true);
                            });
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                      color: AppColors.colorPrimary,
                      child: Text(
                        "Update circle",
                        style: TextStyle(
                            color: AppColors.white,
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontSize: ScreenUtil().setSp(32)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_showloader)
            Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppColors.colorPrimary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                ))
        ],
      ),
    );
  }

  Future<UpdateCircleModel> updateCircle(String id, String name, String) async {
    var data = {
      "user_id": "1",
      "circle_id": id,
      "name": name,
      "image":imageCover,
      "description": " "
    };

    print("data isss" + data.toString());
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_CIRCLE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = UpdateCircleModel.fromJson(response.data);
      if (result.status == 200) {
        return UpdateCircleModel.fromJson(response.data);
      }

      // return LoginModel.fromJson(response.data);
    } else {}
  }
}
