import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/onboarding/SetupProfileBirthdate.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/CustomDropdownButton.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';

class SetupProfileLocation extends StatefulWidget {
  @override
  _SetupProfileLocationState createState() => _SetupProfileLocationState();
}

class _SetupProfileLocationState extends State<SetupProfileLocation> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();


  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  String country = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.onBoardingColor,
                  borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                            child: Text(
                             AppStrings.SETUP_PROFILE,
                              style: TextStyle(
                                  fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                  fontWeight: FontWeight.w900,
                                  fontSize: ScreenUtil().setSp(40.0)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(60),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(6)),
                            child: Text("Country" ,style: TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                          ),
                          Container(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setHeight(10))),
                                child:
                                InkWell(
                                  onTap: () {
                                    showCountryPicker(
                                        context: context,
                                        //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                        exclude: <String>['KN', 'MF'],
                                        //Optional. Shows phone code before the country name.
                                        showPhoneCode: false,

                                        onSelect: (Country country) {
                                          setState(() {
                                            countryController.text =
                                                country.displayName.split(" ")[0];
                                          });
                                          print(
                                              'Select country: ${country.displayName}');
                                        });
                                  },
                                  child: TextField(
                                    controller: countryController,
style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                    decoration: InputDecoration(
                                        hintText: "Select country",
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.keyboard_arrow_down),

                                        hintStyle: TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                      enabled: false,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColors.white, width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColors.white, width: 2.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColors.white, width: 2.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColors.white, width: 2.0),
                                        ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 6.0)
                                    ),
                                  ),
                                )

                                ),
                            color: AppColors.onBoardingColor,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(6)),
                            child: Text("State", style: TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            decoration:
                                InputDecoration(border: InputBorder.none,
                                    hintText: "Enter state",
                                    fillColor: AppColors.white,
                                    filled:true ,
                                    hintStyle: TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    contentPadding: EdgeInsets.only(left:10.0)),
                            controller: stateController,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(6)),
                            child: Text("City", style: TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                          ),
                          TextField(
                            controller: cityController,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            decoration:
                                InputDecoration(
                                    fillColor: AppColors.white,
                                    filled:true ,

                                  hintText: "Enter city",
                                    hintStyle: TextStyle(color: AppColors.backgoundLight,fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                    border: InputBorder.none,

                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: AppColors.white, width: 2.0),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    contentPadding: EdgeInsets.only(left:10.0)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(60),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(44.0)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: Colors.black,
                            height: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (countryController.text == "") {
                                  ReusableWidgets.showInfo(_scaffoldKey, context, "Please select country.");

                                } else if (stateController.text == "") {
                                  ReusableWidgets.showInfo(_scaffoldKey, context, "Please enter state.");

                                } else if (cityController.text == "") {
                                  ReusableWidgets.showInfo(_scaffoldKey, context, "Please enter city.");

                                } else {

                                  Helpers.prefrences
                                      .setString(AppStrings.T_country, countryController.text);
                                  Helpers.prefrences
                                      .setString(AppStrings.T_state, stateController.text);
                                  Helpers.prefrences
                                      .setString(AppStrings.T_city, cityController.text);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetupProfileBirthdate()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                      color: AppColors.NextButton_color,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                                      fontSize: ScreenUtil().setSp(44.0)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
