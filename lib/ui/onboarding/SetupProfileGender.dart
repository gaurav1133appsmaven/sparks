import 'package:flutter/material.dart';
import 'package:sparks/ui/onboarding/SetupProfileOccupation.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';

class SetupProfileGender extends StatefulWidget {
  @override
  _SetupProfileGenderState createState() => _SetupProfileGenderState();
}

class _SetupProfileGenderState extends State<SetupProfileGender> {
  bool male_checked = true;
  bool female_checked = false;
  bool other_checked = false;
  String gender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(14)),
                        height: ScreenUtil().setHeight(80),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(34),
                              height: ScreenUtil().setHeight(34),
                              child: Image.asset(
                                "assets/images/ic_male.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Text("Male"  ,style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    male_checked = true;
                                    female_checked = false;
                                    other_checked = false;
                                    gender = "Male";
                                    setState(() {});
                                  });
                                },
                                child: male_checked
                                    ? Image(
                                        image: AssetImage(
                                            "assets/images/ic_checked.png"))
                                    : Image(
                                        image: AssetImage(
                                            "assets/images/ic_unchecked.png")))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(14)),
                        height: ScreenUtil().setHeight(80),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(34),
                              height: ScreenUtil().setHeight(34),
                              child: Image.asset(
                                "assets/images/ic_female.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Text("Female" ,style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  male_checked = false;
                                  female_checked = true;
                                  other_checked = false;
                                  gender = "Female";
                                  setState(() {});
                                },
                                child: female_checked
                                    ? Image(
                                        image: AssetImage(
                                            "assets/images/ic_checked.png"))
                                    : Image(
                                        image: AssetImage(
                                            "assets/images/ic_unchecked.png")))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(14)),
                        height: ScreenUtil().setHeight(80),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(34),
                              height: ScreenUtil().setHeight(34),
                              child: Image.asset(
                                "assets/images/ic_other.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Text("Other" ,style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO),),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  male_checked = false;
                                  female_checked = false;
                                  other_checked = true;
                                  gender = "Other";
                                  setState(() {});
                                },
                                child: other_checked
                                    ? Image(
                                        image: AssetImage(
                                            "assets/images/ic_checked.png"))
                                    : Image(
                                        image: AssetImage(
                                            "assets/images/ic_unchecked.png")))
                          ],
                        ),
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
                            Helpers.prefrences
                                .setString(AppStrings.T_gender, gender);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SetupProfileOccupation()));
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
    );
  }
}
