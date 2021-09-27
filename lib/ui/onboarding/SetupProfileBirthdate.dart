import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/onboarding/SetupProfileGender.dart';
import 'package:sparks/ui/onboarding/SetupProfileOccupation.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/CustomDropdownButton.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:intl/intl.dart';
import 'package:sparks/utils/ReusableWidgets.dart';

class SetupProfileBirthdate extends StatefulWidget {
  @override
  _SetupProfileBirthdateState createState() => _SetupProfileBirthdateState();
}

class _SetupProfileBirthdateState extends State<SetupProfileBirthdate> {
  DateTime selectedDate = DateTime.now();
  List<ListItem> _list = [
    ListItem(0, "American Indian or Alaska Native"),
    ListItem(1, "Asian"),
    ListItem(2, "Black or African American"),
    ListItem(3, "Hispanic or Latino"),
    ListItem(4, "Native Hawaiian or Other Pacific Islander"),
    ListItem(5, "White"),
    ListItem(6, "Other"),
    ListItem(7, "Prefer not to answer")
  ];
  DateFormat dateFormat = DateFormat("MM-dd-yyyy");
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedList = 0;

  TextEditingController dobController = TextEditingController();

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
                          padding: EdgeInsets.only(top: 8.0),
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
                          height: ScreenUtil().setHeight(40),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(6)),
                          child: Text("Birthdate",
                              style:
                                  TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height /
                                        3,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (picked) {
                                        if (picked != null &&
                                            picked != selectedDate) {

                                          dobController.text = dateFormat
                                              .format(DateTime.parse(picked
                                              .toString()
                                              .split(" ")[0]));
                                          setState(() {

                                          });

                                          debugPrint("zzzzzz"+dobController.text);
                                        }
                                        // setState(() {
                                        //   selectedDate = picked;
                                        // });
                                      },
                                      initialDateTime: selectedDate,
                                      minimumYear: 1931,
                                      maximumYear: 2021,
                                    ),
                                  );
                                });
                          },
                          child: TextField(
                            controller: dobController,
                            style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                            enabled: false,
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                                filled: true,
                                fillColor: Colors.white,
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
                                contentPadding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 6.0),
                                hintStyle: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                                hintText: "mm/dd/yyyy"),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(6)),
                          child: Text("Ethnicity",
                              style:
                                  TextStyle(color: AppColors.onboardingTextColor,fontFamily: AppFonts.FONTFAMILY_ROBOTO)),
                        ),
                        Container(

                          decoration: BoxDecoration(
                              color: Colors.white,
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomDropdownButton(
                                value: _list[_selectedList].value,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    _list[_selectedList].name,
                                    style: TextStyle(
                                        color: AppColors.white,fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                                        fontSize: ScreenUtil().setSp(30)),
                                  ),
                                ),
                                items: _list
                                    .map((e) => DropdownMenuItem(
                                        value: e.value, child: Text(e.name,style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),)))
                                    .toList(),
                                onChanged: (value) {
                                  debugPrint(value.toString());

                                  setState(() {
                                    _selectedList = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          height: ScreenUtil().setHeight(80),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
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
                              if (dobController.text == "") {
                                ReusableWidgets.showInfo(
                                    _scaffoldKey, context, "Please select DOB");
                              } else {



                                debugPrint("@@@@@@"+dobController.text);
                                debugPrint("@@@@@@"+_list[_selectedList].name.toString());
                                Helpers.prefrences.setString(
                                    AppStrings.T_dob, dobController.text);
                                Helpers.prefrences.setString(
                                    AppStrings.T_ethnicity, _list[_selectedList].name.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SetupProfileGender()));
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
        ));
  }
}
