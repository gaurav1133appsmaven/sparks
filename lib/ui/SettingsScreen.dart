import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/bloc/SettingsBloc.dart';
import 'package:dio/dio.dart';
import 'package:sparks/ui/ChangePassword.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'dart:io';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sparks/ui/SplashScreen.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/models/RegisterationModel.dart';
import 'package:country_picker/country_picker.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingBloc = SettingsBloc();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat("MM-dd-yyyy");
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  var phoneController = new MaskedTextController(mask: '000-000-0000');
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController ethnicityController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController monthlyIdeasController = TextEditingController();
  String statusType = "";
  final picker = ImagePicker();
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  var status = "";
  var aspiringSelected = false;
  double lowerbound = 0.0;
  double upperBound = 1.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _showLoader = false;

  var shouldAbsorb = true;

  String profileImage = "";

  @override
  void initState() {
    _settingBloc.firstnameChanged(
        Helpers.prefrences.getString(AppStrings.USER_FIRSTNAME));
    fnameController.text =
        Helpers.prefrences.getString(AppStrings.USER_FIRSTNAME);
    lnameController.text =
        Helpers.prefrences.getString(AppStrings.USER_LASTNAME);
    userController.text =
        Helpers.prefrences.getString(AppStrings.USER_USERNAME);
    phoneController.text = Helpers.prefrences.getString(AppStrings.USER_PHONE);
    passwordController.text =
        Helpers.prefrences.getString(AppStrings.USER_PASSWORD);
    emailController.text = Helpers.prefrences.getString(AppStrings.USER_EMAIL);
    countryController.text =
        Helpers.prefrences.getString(AppStrings.USER_COUNTRY);
    stateController.text = Helpers.prefrences.getString(AppStrings.USER_STATE);
    interestController.text =
        Helpers.prefrences.getString(AppStrings.USER_INTEREST);
    ethnicityController.text =
        Helpers.prefrences.getString(AppStrings.USER_ETHNICITY);

    stateController.text =
        Helpers.prefrences.getString(AppStrings.USER_STATE) == "  "
            ? "-"
            : stateController.text;

    interestController.text =
        Helpers.prefrences.getString(AppStrings.USER_INTEREST) == "  "
            ? "-"
            : interestController.text;

    cityController.text =
        Helpers.prefrences.getString(AppStrings.USER_CITY) == " "
            ? "-"
            : cityController.text;
    cityController.text = Helpers.prefrences.getString(AppStrings.USER_CITY);
    debugPrint(
        "date " + Helpers.prefrences.getString(AppStrings.USER_BIRTHDAY));
    birthdayController.text =
        Helpers.prefrences.getString(AppStrings.USER_BIRTHDAY);
    ethnicityController.text =
        Helpers.prefrences.getString(AppStrings.USER_ETHNICITY);
    genderController.text =
        Helpers.prefrences.getString(AppStrings.USER_GENDER);

    lowerbound =
        double.parse(Helpers.prefrences.getString(AppStrings.USER_MINFREETIME));
    upperBound =
        double.parse(Helpers.prefrences.getString(AppStrings.USER_MAXFREETIME));
    monthlyIdeasController.text =
        Helpers.prefrences.getString(AppStrings.USER_MONTHLY_IDEAS);

    profileImage = Helpers.prefrences.getString(AppStrings.USER_IMAGE);

    status = Helpers.prefrences.getString(AppStrings.USER_STATUS);
    if (status == AppStrings.Aspiring_Enterpreneur) {
      aspiringSelected = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            !shouldAbsorb
                ? Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () async {
                        shouldAbsorb = !shouldAbsorb;

                        if (fnameController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "First name can't be blank.");
                          return;
                        } else if (lnameController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "Last name can't be blank.");
                          return;
                        } else if (userController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "Username can't be blank.");
                          return;
                        } else if (emailController.text == "") {
                          ReusableWidgets.showInfo(
                              _scaffoldKey, context, "Email can't be blank.");

                          return;
                        } else if (phoneController.text == "") {
                          ReusableWidgets.showInfo(
                              _scaffoldKey, context, "Phone can't be blank.");
                          return;
                        } else if (countryController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "Country name can't be blank.");
                          return;
                        } else if (stateController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "State name can't be blank.");
                          return;
                        } else if (interestController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "Interest can't be blank.");
                          return;
                        } else if (cityController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "City name can't be blank.");
                          return;
                        } else if (birthdayController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "Birthdate can't be blank.");
                          return;
                        } else if (ethnicityController.text == "") {
                          ReusableWidgets.showInfo(_scaffoldKey, context,
                              "Ethnicity can't be blank.");
                          return;
                        } else if (genderController.text == "") {
                          ReusableWidgets.showInfo(
                              _scaffoldKey, context, "Gender can't be blank.");
                          return;
                        }

                        setState(() {
                          _showLoader = true;
                        });

                        var data = {
                          "user_id":
                              Helpers.prefrences.getString(AppStrings.USER_ID),
                          "first_name": fnameController.text,
                          "last_name": lnameController.text,
                          "phone_no": phoneController.text,
                          "country": countryController.text,
                          "state": stateController.text,
                          "user_name": userController.text,
                          "email": emailController.text,
                          "city": cityController.text,
                          "birth_date": birthdayController.text,
                          "ethnicity": ethnicityController.text,
                          "gender": genderController.text,
                          "status_type": status,
                          "occupation": Helpers.prefrences
                              .getString(AppStrings.USER_OCCUPATION),
                          "interests": interestController.text,
                          "min_free_time": lowerbound,
                          "max_free_time": upperBound,
                          "ideas_for_months": Helpers.prefrences
                              .getString(AppStrings.USER_MONTHLY_IDEAS),
                          "image": profileImage
                          // "image": Helpers.prefrences
                          //             .getString(AppStrings.USER_IMAGE) ==
                          //         null
                          //     ? ""
                          //     : Helpers.prefrences
                          //         .getString(AppStrings.USER_IMAGE)
                        };

                        debugPrint(data.toString());

                        var response = await Dio().post(
                            ApiEndpoints.BASE_URL + ApiEndpoints.ONBOARDING,
                            options: Options(headers: {
                              HttpHeaders.contentTypeHeader: "application/json",
                            }),
                            data: jsonEncode(data));
                        setState(() {
                          _showLoader = false;
                        });
                        if (response.statusCode == 200) {
                          debugPrint("response getting raw data= " +
                              response.data.toString());
                          var result =
                              RegisterationModel.fromJson(response.data);
                          if (result.status == 200) {
                            if (result.success == 1) {
                              Helpers.prefrences
                                  .setBool(AppStrings.USER_LOGGEDIN, true);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_ID, result.data.id);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_EMAIL, result.data.email);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_FIRSTNAME,
                                  result.data.firstName);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_LASTNAME,
                                  result.data.lastName);

                              Helpers.prefrences.setString(
                                  AppStrings.USER_INTEREST,
                                  result.data.interests);

                              Helpers.prefrences.setString(
                                  AppStrings.USER_IMAGE, result.data.image);

                              Helpers.prefrences.setString(
                                  AppStrings.USER_USERNAME,
                                  result.data.username);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_PHONE, result.data.phoneNo);
                              //  Helpers.prefrences.setString(AppStrings.USER_PASSWORD, r.data.);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_COUNTRY, result.data.country);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_STATE, result.data.state);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_CITY, result.data.city);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_BIRTHDAY,
                                  result.data.birthDate);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_ETHNICITY,
                                  result.data.ethnicity);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_GENDER, result.data.gender);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_STATUS,
                                  result.data.statusType);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_MONTHLY_IDEAS,
                                  result.data.ideasForMonths);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_MINFREETIME,
                                  result.data.minFreeTime);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_MAXFREETIME,
                                  result.data.maxFreeTime);
                              Helpers.prefrences.setString(
                                  AppStrings.USER_OCCUPATION,
                                  result.data.occupation);
                              ReusableWidgets.showInfo(_scaffoldKey, context,
                                  "Your profile has been updated!");
                              //  Navigator.pop(context);
                            } else {
                              ReusableWidgets.showInfo(
                                  _scaffoldKey, context, result.message);
                            }
                          }

                          // return LoginModel.fromJson(response.data);
                        } else {
                          ReusableWidgets.showInfo(
                              _scaffoldKey, context, "Something went wrong!");
                        }

                        // setState(() {});
                      },
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: AppColors.white,
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                              fontWeight: FontWeight.w700,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        shouldAbsorb = !shouldAbsorb;
                        setState(() {});
                      },
                      child: Center(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: AppColors.white,
                              fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                              fontWeight: FontWeight.w700,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                    ),
                  )
          ],
          title: Text(
            "Settings",
            style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                fontWeight: FontWeight.w700,
                fontSize: ScreenUtil().setSp(30)),
          ),
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                if (!shouldAbsorb)
                  InkWell(
                    onTap: () {
                      shouldAbsorb = !shouldAbsorb;

                      setState(() {});
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: AppColors.white,
                    ),
                  ),
                // Text(
                //   "Cancel",
                //   style: TextStyle(
                //       color: AppColors.white,
                //       fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                //       fontSize: ScreenUtil().setSp(30)),
                // )
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: AppColors.onBoardingColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.white,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(8)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AbsorbPointer(
                                  absorbing: shouldAbsorb,
                                  child: Stack(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 190.0,
                                        lineWidth: 6.0,
                                        percent: 0.65,
                                        animationDuration: 1200,
                                        animation: true,
                                        backgroundColor: Colors.black,
                                        progressColor:
                                            AppColors.VOTING_SPACE_BACKGROUND,
                                        center: CircularPercentIndicator(
                                          radius: 170.0,
                                          lineWidth: 5.0,
                                          percent: 0.85,
                                          backgroundColor: Colors.black,
                                          animationDuration: 1200,
                                          animation: true,
                                          progressColor:
                                              AppColors.BUTTONTEXT_YELLOW,
                                          center: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius:
                                                  ScreenUtil().setHeight(180),
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: CircleAvatar(
                                                radius:
                                                    ScreenUtil().setHeight(170),
                                                backgroundImage: NetworkImage(
                                                  profileImage,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //
                                        // center: CircleAvatar(
                                        //   radius: ScreenUtil().setHeight(186),
                                        //   backgroundColor: Colors.transparent,
                                        //   child: CircleAvatar(
                                        //     radius: ScreenUtil().setHeight(170),
                                        //     backgroundImage: NetworkImage(
                                        //       imageCover,
                                        //     ),
                                        //   ),
                                        // ),
                                      ),
                                      if (!shouldAbsorb)
                                        Positioned(
                                            right: ScreenUtil().setWidth(28),
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


                                                                          final pickedFile =
                                                                              await picker.getImage(source: ImageSource.camera);
                                                                          print("response d " +
                                                                              pickedFile.path.toString());
                                                                          if(pickedFile==null)
                                                                          {
                                                                            return;
                                                                          }
                                                                          setState(
                                                                                  () {
                                                                                _showLoader =
                                                                                true;
                                                                              });

                                                                          try {
                                                                            CloudinaryResponse
                                                                                response =
                                                                                await cloudinary.uploadFile(
                                                                              CloudinaryFile.fromFile(pickedFile.path, resourceType: CloudinaryResourceType.Image),
                                                                            );

                                                                            profileImage =
                                                                                response.secureUrl;
                                                                            debugPrint("data " +
                                                                                profileImage);
                                                                            setState(() {
                                                                              _showLoader = false;
                                                                            });
                                                                          } on Exception catch (e) {
                                                                            setState(() {
                                                                              _showLoader = false;
                                                                            });
                                                                          }
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



                                                                          final pickedFile =
                                                                              await picker.getImage(source: ImageSource.gallery);
                                                                          print("response d " +
                                                                              pickedFile.path.toString());
                                                                          if(pickedFile==null)
                                                                            {
                                                                              return;
                                                                            }
                                                                          setState(
                                                                                  () {
                                                                                _showLoader =
                                                                                true;
                                                                              });

                                                                          try {
                                                                            CloudinaryResponse
                                                                                response =
                                                                                await cloudinary.uploadFile(
                                                                              CloudinaryFile.fromFile(pickedFile.path, resourceType: CloudinaryResourceType.Image),
                                                                            );

                                                                            profileImage =
                                                                                response.secureUrl;
                                                                            debugPrint("data " +
                                                                                profileImage);
                                                                            setState(() {
                                                                              _showLoader = false;
                                                                            });
                                                                          } on Exception catch (e) {
                                                                            setState(() {
                                                                              _showLoader = false;
                                                                            });
                                                                          }
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
                                              child: ClipOval(
                                                  child: Container(
                                                      color: AppColors
                                                          .backgoundLight,
                                                      padding: EdgeInsets.all(
                                                          ScreenUtil()
                                                              .setHeight(12)),
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: AppColors.white,
                                                        size: ScreenUtil()
                                                            .setHeight(34),
                                                      ))),
                                            ))
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              getDividerLine(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: ScreenUtil().setHeight(20),
                                          ),
                                          title("First Name"),
                                          //
                                          // textField(fnameController, _settingBloc.firstName,
                                          //     _settingBloc.firstnameChanged),

                                          TextField(
                                            controller: fnameController,
                                            onChanged: (value) {},
                                            enabled: !shouldAbsorb,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFonts.FONTFAMILY_ROBOTO,
                                                color: AppColors
                                                    .SETTINGS_TEXT_COLOR,
                                                fontSize:
                                                    ScreenUtil().setSp(34)),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          title("Last Name"),
                                          // textField(lnameController, _settingBloc.lastName,
                                          //     _settingBloc.lastNameChanged),
                                          TextField(
                                            controller: lnameController,
                                            enabled: !shouldAbsorb,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFonts.FONTFAMILY_ROBOTO,
                                                color: AppColors
                                                    .SETTINGS_TEXT_COLOR,
                                                fontSize:
                                                    ScreenUtil().setSp(34)),
                                            onChanged: (value) {},
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              getDividerLine(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(10),
                                    top: ScreenUtil().setHeight(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Profile Name"),
                                              TextField(
                                                controller: userController,
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    color: AppColors
                                                        .SETTINGS_TEXT_COLOR,
                                                    fontSize:
                                                        ScreenUtil().setSp(34)),
                                                enabled: !shouldAbsorb,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Phone Number"),
                                              TextField(
                                                controller: phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                maxLength: 12,
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    color: AppColors
                                                        .SETTINGS_TEXT_COLOR,
                                                    fontSize:
                                                        ScreenUtil().setSp(34)),
                                                enabled: !shouldAbsorb,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        // Expanded(
                                        //   child: Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       title("Password"),
                                        //       TextField(
                                        //         controller: passwordController,
                                        //         decoration: InputDecoration(
                                        //           border: InputBorder.none,
                                        //           focusedBorder: InputBorder.none,
                                        //           enabledBorder: InputBorder.none,
                                        //           errorBorder: InputBorder.none,
                                        //           disabledBorder: InputBorder.none,
                                        //         ),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Email"),
                                              TextField(
                                                controller: emailController,
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    color: AppColors
                                                        .SETTINGS_TEXT_COLOR,
                                                    fontSize:
                                                        ScreenUtil().setSp(34)),
                                                enabled: !shouldAbsorb,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              ChangePassword()));
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        child: title(
                                                            "Change Password")),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "*********",
                                                        style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO,
                                                            color:
                                                                AppColors.black,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(30)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              getDividerLine(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(10),
                                    top: ScreenUtil().setHeight(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Country"),
                                              AbsorbPointer(
                                                absorbing: shouldAbsorb,
                                                child: InkWell(
                                                  onTap: () {
                                                    showCountryPicker(
                                                        context: context,
                                                        //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                                        exclude: <String>[
                                                          'KN',
                                                          'MF'
                                                        ],
                                                        //Optional. Shows phone code before the country name.
                                                        showPhoneCode: false,
                                                        onSelect:
                                                            (Country country) {
                                                          setState(() {
                                                            countryController
                                                                    .text =
                                                                country
                                                                    .displayName
                                                                    .split(
                                                                        " ")[0];
                                                          });
                                                          print(
                                                              'Select country: ${country.displayName}');
                                                        });
                                                  },
                                                  child: TextField(
                                                    controller:
                                                        countryController,
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO,
                                                        color: AppColors
                                                            .SETTINGS_TEXT_COLOR,
                                                        fontSize: ScreenUtil()
                                                            .setSp(34)),
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("State"),
                                              TextField(
                                                controller: stateController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    color: AppColors
                                                        .SETTINGS_TEXT_COLOR,
                                                    fontSize:
                                                        ScreenUtil().setSp(34)),
                                                enabled: !shouldAbsorb,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("City"),
                                              TextField(
                                                controller: cityController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    color: AppColors
                                                        .SETTINGS_TEXT_COLOR,
                                                    fontSize:
                                                        ScreenUtil().setSp(34)),
                                                enabled: !shouldAbsorb,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              getDividerLine(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(10),
                                    top: ScreenUtil().setHeight(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Birthday"),
                                              AbsorbPointer(
                                                absorbing: shouldAbsorb,
                                                child: InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            builder) {
                                                          return Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .copyWith()
                                                                    .size
                                                                    .height /
                                                                3,
                                                            color: Colors.white,
                                                            child:
                                                                CupertinoDatePicker(
                                                              mode:
                                                                  CupertinoDatePickerMode
                                                                      .date,
                                                              onDateTimeChanged:
                                                                  (picked) {
                                                                if (picked !=
                                                                        null &&
                                                                    picked !=
                                                                        selectedDate) {
                                                                  birthdayController
                                                                          .text =
                                                                      dateFormat.format(DateTime.parse(picked
                                                                          .toString()
                                                                          .split(
                                                                              " ")[0]));
                                                                  setState(
                                                                      () {});

                                                                  debugPrint("zzzzzz" +
                                                                      birthdayController
                                                                          .text);
                                                                }
                                                                // setState(() {
                                                                //   selectedDate = picked;
                                                                // });
                                                              },
                                                              initialDateTime:
                                                                  selectedDate,
                                                              minimumYear: 1931,
                                                              maximumYear: 2021,
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: TextField(
                                                    controller:
                                                        birthdayController,
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO,
                                                        color: AppColors
                                                            .SETTINGS_TEXT_COLOR,
                                                        fontSize: ScreenUtil()
                                                            .setSp(34)),
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Ethnicity"),
                                              AbsorbPointer(
                                                absorbing: shouldAbsorb,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (builder) => Dialog(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .onBoardingColor,
                                                                  child:
                                                                      Container(
                                                                    height: ScreenUtil()
                                                                        .setHeight(
                                                                            540),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: Container(
                                                                              child: Text(
                                                                                "Select Ethnicity",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD, fontWeight: FontWeight.w700, color: AppColors.colorAccent, fontSize: ScreenUtil().setSp(40)),
                                                                              ),
                                                                            )),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_AMERICANINDIAN;
                                                                            });
                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_AMERICANINDIAN,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_ASIAN;
                                                                            });
                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_ASIAN,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_AFRICANAMERICAN;
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_AFRICANAMERICAN,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_HISPANIC;
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_HISPANIC,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_NATIVEHAWAIIAN;
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_NATIVEHAWAIIAN,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_WHITE;
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_WHITE,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_OTHER;
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_OTHER,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              ethnicityController.text = AppStrings.EHTNICITY_NOTTOANSWER;
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppStrings.EHTNICITY_NOTTOANSWER,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ));
                                                  },
                                                  child: (ethnicityController.text.length>20&&shouldAbsorb)?Text(ethnicityController.text, style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO,
                                                      color: AppColors
                                                          .SETTINGS_TEXT_COLOR,
                                                      fontSize:
                                                      ScreenUtil().setSp(34))):TextField(
                                                    controller:
                                                        ethnicityController,
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO,
                                                        color: AppColors
                                                            .SETTINGS_TEXT_COLOR,
                                                        fontSize: ScreenUtil()
                                                            .setSp(34)),
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Gender"),
                                              AbsorbPointer(
                                                absorbing: shouldAbsorb,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (builder) => Dialog(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .onBoardingColor,
                                                                  child:
                                                                      Container(
                                                                    height: ScreenUtil()
                                                                        .setHeight(
                                                                            250),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: Text(
                                                                              "Select Gender",
                                                                              style: TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD, fontWeight: FontWeight.w700, color: AppColors.colorAccent, fontSize: ScreenUtil().setSp(40)),
                                                                            )),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              genderController.text = "Male";
                                                                            });

                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Male",
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              genderController.text = "Female";
                                                                            });
                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Female",
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              genderController.text = "Others";
                                                                            });
                                                                            Navigator.pop(context);
                                                                            FocusScope.of(context).requestFocus(new FocusNode());
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Others",
                                                                            style:
                                                                                TextStyle(fontFamily: AppFonts.FONTFAMILY_OPENSANS_REGULAR, fontSize: ScreenUtil().setSp(34)),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ));
                                                  },
                                                  child: TextField(
                                                    controller:
                                                        genderController,
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO,
                                                        color: AppColors
                                                            .SETTINGS_TEXT_COLOR,
                                                        fontSize: ScreenUtil()
                                                            .setSp(34)),
                                                    enabled: false,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              title("Interests"),
                                              (interestController.text.length>20&&shouldAbsorb)?Text(interestController.text,  style: TextStyle(
                                                  fontFamily: AppFonts
                                                  .FONTFAMILY_ROBOTO,
                                                  color: AppColors
                                                      .SETTINGS_TEXT_COLOR,
                                                  fontSize:
                                                  ScreenUtil().setSp(34)),):TextField(
                                                controller: interestController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                style: TextStyle(
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO,
                                                    color: AppColors
                                                        .SETTINGS_TEXT_COLOR,
                                                    fontSize:
                                                        ScreenUtil().setSp(34)),
                                                enabled: !shouldAbsorb,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              getDividerLine(),
                              //availability slot

                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(10),
                                    top: ScreenUtil().setHeight(20)),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: title("Status")),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(10)),
                                decoration: BoxDecoration(
                                    color: AppColors.onBoardingColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: ScreenUtil().setHeight(60),
                                child: AbsorbPointer(
                                  absorbing: shouldAbsorb,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            status = AppStrings
                                                .Aspiring_Enterpreneur;
                                            aspiringSelected =
                                                !aspiringSelected;
                                          });
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: aspiringSelected
                                                    ? Colors.white
                                                    : null,
                                                border: aspiringSelected
                                                    ? Border.all(
                                                        color: Colors.black,
                                                        width: 0.5)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                                AppStrings
                                                    .Aspiring_Enterpreneur,
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(26),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: AppFonts
                                                        .FONTFAMILY_ROBOTO_MEDIUM),
                                                textAlign: TextAlign.center)),
                                      )),
                                      Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  status =
                                                      AppStrings.Entrepreneur;
                                                  aspiringSelected =
                                                      !aspiringSelected;
                                                });
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: aspiringSelected
                                                          ? null
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: aspiringSelected
                                                          ? null
                                                          : Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 0.5)),
                                                  child: Text(
                                                    AppStrings.Entrepreneur,
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setSp(26),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM),
                                                    textAlign: TextAlign.center,
                                                  ))))
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Padding(

                                padding:  EdgeInsets.only( left: ScreenUtil().setWidth(10)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Free time",
                                    style: TextStyle(
                                        fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                        color: AppColors.backgoundLight,
                                        fontSize: ScreenUtil().setSp(30)),
                                  ),
                                ),
                              ),
                              AbsorbPointer(
                                absorbing: shouldAbsorb,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(20),
                                      horizontal: ScreenUtil().setWidth(10)),
                                  child: Stack(
                                    children: [
                                      FlutterSlider(
                                        values: [lowerbound, upperBound],
                                        max: 24,
                                        min: 1,
                                        trackBar: FlutterSliderTrackBar(
                                          activeTrackBarHeight: 5,
                                          inactiveTrackBar: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppColors.colorPrimary,
                                            border: Border.all(
                                                width: 3,
                                                color: Colors.black54),
                                          ),
                                          activeTrackBar: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: AppColors.colorAccent),
                                        ),
                                        tooltip: FlutterSliderTooltip(
                                            custom: (value) {
                                              return Text(
                                                  value.round().toString());
                                            },
                                            alwaysShowTooltip: true),
                                        rangeSlider: true,
                                        onDragCompleted: (_, lower, upper) {
                                          print("~~~" + lower.toString());
                                          print("###" + upper.toString());
                                          setState(() {
                                            lowerbound = lower;
                                            upperBound = upper;
                                          });
                                        },
                                        rightHandler: FlutterSliderHandler(
                                            decoration: BoxDecoration(),
                                            child: Image.asset(
                                                "assets/images/ic_slidermarker.png")),
                                        handler: FlutterSliderHandler(
                                            decoration: BoxDecoration(),
                                            child: Image.asset(
                                                "assets/images/ic_slidermarker.png")),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Text("0"),
                                            Spacer(),
                                            Text("24")
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30),
                          vertical: ScreenUtil().setHeight(20)),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(32)),
                          onPressed: () {
                            String tkn = Helpers.prefrences
                                .getString(AppStrings.DEVICE_TOKEN);
                            Helpers.prefrences.clear();
                            Helpers.prefrences
                                .setString(AppStrings.DEVICE_TOKEN, tkn);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (cont) => SplashScreen()),
                                (route) => false);
                          },
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w900,
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                fontSize: ScreenUtil().setSp(36)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showLoader)
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppColors.colorPrimary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: AppFonts.FONTFAMILY_ROBOTO,
            color: AppColors.backgoundLight,
            fontSize: ScreenUtil().setSp(30)),
      ),
    );
  }

  Widget getDividerLine() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
      ),
      child: Container(
        height: 1,
        color: AppColors.backgoundLight,
      ),
    );
  }
}
