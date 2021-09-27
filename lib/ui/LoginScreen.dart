import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparks/bloc/LoginBloc.dart';
import 'package:sparks/ui/ForgotPassword.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/onboarding/SetUpName.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:sparks/utils/Routes.dart';
import 'package:sparks/utils/SparksTextField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'RegisterScreen.dart';




class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscuretext = true;

  @override
  Widget build(BuildContext context) {
    //   _loginBloc.loaderValueChanged(false);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ImageIcon(
                            AssetImage("assets/images/ic_close.png"),
                            color: AppColors.colorPrimary,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(60)),
                        child: Text(
                          AppStrings.TITLE_LOGIN,
                          style: TextStyle(
                              color: AppColors.colorAccent,
                              fontFamily: AppFonts.Comfortaa_SemiBold,

                              fontSize: ScreenUtil()
                                  .setSp(70)),
                        ),
                      ),
                      SparksTextField(
                          _loginBloc.email,
                          _emailController,
                          _loginBloc.emailChanged,
                          AppStrings.EMAIL_HINT,
                          TextInputType.emailAddress),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      StreamBuilder(
                        stream: _loginBloc.password,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _passwordController,
                              style: TextStyle(  fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD,),
                            onChanged: _loginBloc.passwordChanged,
                              cursorHeight: 20,

                            obscureText: _obscuretext,

                            inputFormatters: [
                              new BlacklistingTextInputFormatter(
                                  new RegExp(' ')),
                            ],
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: new InputDecoration(
                                errorText: snapshot.error,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _obscuretext
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.backgoundLight,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _obscuretext = !_obscuretext;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                color: AppColors.colorPrimary, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                          color: AppColors.colorPrimary, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                          color: AppColors.colorPrimary, width: 2.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                          color: AppColors.colorPrimary, width: 2.0),
                          ),
                          hintText: AppStrings.PASSWORD_HINT,
                              hintStyle: TextStyle(  fontFamily: AppFonts.FONTFAMILY_OPENSANS_BOLD,),
                          ));
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),

                      InkWell(
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>

                          ForgotPassword()

                          ));

                        },
                        child: Align(

                          alignment: Alignment.centerRight
                          ,child: Text("Forgot password?",style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorPrimary

                          ),),
                        ),
                      ),

                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: EdgeInsets.all(18),
                          onPressed: () => moveToNext(context),
                          color: AppColors.colorPrimaryDark,
                          child: Text(
                            AppStrings.LOGIN.toUpperCase(),
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: StreamBuilder(
                      stream: _loginBloc.showLoader,
                      builder: (context, snapshot) {
                        debugPrint("inside stream" + snapshot.data.toString());

                        return snapshot.data
                            ?    CircularProgressIndicator(
                            backgroundColor: AppColors.colorPrimary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorAccent))
                            : SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToNext(BuildContext contxt) {
    Helpers.checkInternet().then((value) {
      if (value) {
        if (_loginBloc.validateFields() == null) {
          _loginBloc.loginUser().then((value) {
            value.fold((l) => ReusableWidgets.showInfo(_scaffoldKey, contxt, l),
                    (r) {
                  if (r.data.onboardingStatus == "0") {
                    Navigator.of(contxt).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SetUpName()),
                            (Route<dynamic> route) => true);
                  } else {
                    Helpers.prefrences.setBool(AppStrings.USER_LOGGEDIN, true);
                    Helpers.prefrences.setString(AppStrings.USER_ID, r.data.id);
                    Helpers.prefrences.setString(AppStrings.USER_EMAIL, r.data.email);
                    Helpers.prefrences.setString(AppStrings.USER_FIRSTNAME, r.data.firstName);
                    Helpers.prefrences.setString(AppStrings.USER_LASTNAME, r.data.lastName);
                    Helpers.prefrences.setString(AppStrings.USER_USERNAME, r.data.username);
                    Helpers.prefrences.setString(AppStrings.USER_PHONE, r.data.phoneNo);
                    Helpers.prefrences.setString(AppStrings.USER_IMAGE, r.data.image);
                    //  Helpers.prefrences.setString(AppStrings.USER_PASSWORD, r.data.);
                    Helpers.prefrences.setString(AppStrings.USER_COUNTRY, r.data.country);
                    Helpers.prefrences.setString(AppStrings.USER_STATE, r.data.state);
                    Helpers.prefrences.setString(AppStrings.USER_CITY, r.data.city);
                    Helpers.prefrences.setString(AppStrings.USER_BIRTHDAY, r.data.birthDate);
                    Helpers.prefrences.setString(AppStrings.USER_ETHNICITY, r.data.ethnicity);
                    Helpers.prefrences.setString(AppStrings.USER_GENDER, r.data.gender);
                    Helpers.prefrences.setString(AppStrings.USER_STATUS, r.data.statusType);
                    Helpers.prefrences.setString(AppStrings.USER_MONTHLY_IDEAS, r.data.ideasForMonths);
                    Helpers.prefrences.setString(AppStrings.USER_MINFREETIME, r.data.minFreeTime);
                    Helpers.prefrences.setString(AppStrings.USER_MAXFREETIME, r.data.maxFreeTime);
                    Helpers.prefrences.setString(AppStrings.USER_OCCUPATION, r.data.occupation);
                    Helpers.prefrences.setString(AppStrings.USER_INTEREST, r.data.interests);

                    Navigator.of(contxt).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen(selectPage: 0,)),
                            (Route<dynamic> route) => true);
                  }

                  return;
                });
          });
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, contxt, _loginBloc.validateFields());
        }
      } else {
        ReusableWidgets.showInfo(
            _scaffoldKey, contxt, AppStrings.INTERNET_NOT_CONNECTED);
      }
    });
  }
}



