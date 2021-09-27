import 'package:flutter/material.dart';
import 'package:sparks/ui/LoginScreen.dart';
import 'package:sparks/ui/RegisterScreen.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _image = AssetImage(
    "assets/images/splash_background.png",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: _image, fit: BoxFit.fill)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(24)),
                      borderSide: BorderSide(
                          color: AppColors.colorPrimaryDark, width: 2),
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.LoginRoute),
                      child: Text(
                        AppStrings.LOGIN,
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontSize: ScreenUtil().setSp(40)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(24)),
                      onPressed: () => Navigator.pushNamed(
                          context, Routes.RegisterationRoute),
                      color: AppColors.colorPrimaryDark,
                      child: Text(
                        AppStrings.REGISTER.toUpperCase(),
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
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
      ),
    ));
  }
}
