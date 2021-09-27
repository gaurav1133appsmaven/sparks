import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/SplashScreen.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sparks/utils/Routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/SessionManger.dart';

import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


bool _initialUriIsHandled = false;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  _showNotification(message.data['title'], message.data['body'],
      message.data['circle_id'].toString());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Helpers.prefrences = await SharedPreferences.getInstance();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,

    sound: true,
  );
  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: false,
    badge: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_logo',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true)
      ]);

  var result;

  result = await Helpers.prefrences.getBool(AppStrings.USER_LOGGEDIN);

  // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(SparksApp(result));
}

class SparksApp extends StatefulWidget {
  SparksApp(this.userloggedin);

  final userloggedin;

  @override
  _SparksAppState createState() => _SparksAppState();
}

class _SparksAppState extends State<SparksApp> {
  FirebaseMessaging _firebaseMessaging;

  Uri _initialUri;
  Uri _latestUri;
  Object _err;

  final _navKey = GlobalKey<NavigatorState>();

  StreamSubscription<Uri> _sub;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();


    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print("permission requested");
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        _showNotification(message.data['title'], message.data['body'],
            message.data['circle_id'].toString());
      }
    });
    FirebaseMessaging.instance.getToken().then((value) {
      Helpers.prefrences.setString(AppStrings.DEVICE_TOKEN, value);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.data['title'], message.data['body'],
          message.data['circle_id'].toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    // AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   if (receivedNotification.payload["circleId"] != null &&
    //       receivedNotification.payload["circleId"] != "") {
    //     if (receivedNotification.buttonKeyPressed == "Yes") {
    //       addUserToCircle(receivedNotification.payload['circleId']);
    //     }
        // else if (receivedNotification.buttonKeyPressed == "" &&
        //     receivedNotification.payload["circleId"] != "") {
        //  Future.delayed(const Duration(milliseconds: 500),()=>
        //       showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           backgroundColor: AppColors.QUICK_IDEA_BACKGROUND,
        //           title: Text(
        //             receivedNotification.title,
        //             style: TextStyle(
        //                 fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
        //                 fontSize: ScreenUtil().setSp(40),
        //                 fontWeight: FontWeight.w900),
        //           ),
        //           content: Text(
        //             receivedNotification.body,
        //             style: TextStyle(
        //                 fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
        //                 fontWeight: FontWeight.w500,
        //                 fontSize: ScreenUtil().setSp(36)),
        //           ),
        //           actions: <Widget>[
        //             FlatButton(
        //               child: Text(
        //                 'Cancel',
        //                 style: TextStyle(
        //                     fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
        //                     fontWeight: FontWeight.bold,
        //                     color: AppColors.colorPrimary,
        //                     fontSize: ScreenUtil().setSp(30)),
        //               ),
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //               },
        //             ),
        //             FlatButton(
        //               child: Text(
        //                 'Yes',
        //                 style: TextStyle(
        //                     fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
        //                     color: AppColors.colorPrimary,
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: ScreenUtil().setSp(30)),
        //               ),
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //                 addUserToCircle(
        //                     receivedNotification.payload['circleId']);
        //               },
        //             ),
        //           ],
        //         );
        //       }));
        // }
    //  }
   // });
 //   _handleIncomingLinks();
 //   _handleInitialUri();
  }
  // Future<void> _handleInitialUri() async {
  //   // In this example app this is an almost useless guard, but it is here to
  //   // show we are not going to call getInitialUri multiple times, even if this
  //   // was a weidget that will be disposed of (ex. a navigation route change).
  //   if (!_initialUriIsHandled) {
  //     _initialUriIsHandled = true;
  //     print('_handleInitialUri called');
  //     try {
  //       final uri = await getInitialUri();
  //       if (uri == null) {
  //         print('no initial uri');
  //       } else {
  //         print('got initial uri: $uri');
  //       }
  //       if (!mounted) return;
  //       setState(() => _initialUri = uri);
  //     } on PlatformException {
  //       // Platform messages may fail but we ignore the exception
  //       print('falied to get initial uri');
  //     } on FormatException catch (err) {
  //       if (!mounted) return;
  //       print('malformed initial uri');
  //       setState(() => _err = err);
  //     }
  //   }
  // }
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
  // void _handleIncomingLinks() {
  //
  //     // It will handle app links while the app is already started - be it in
  //     // the foreground or in the background.
  //     _sub = uriLinkStream.listen((Uri uri) {
  //       if (!mounted) return;
  //       print('got uri: $uri');
  //       setState(() {
  //         _latestUri = uri;
  //         _err = null;
  //       });
  //     }, onError: (Object err) {
  //       if (!mounted) return;
  //       print('got err: $err');
  //       setState(() {
  //         _latestUri = null;
  //         if (err is FormatException) {
  //           _err = err;
  //         } else {
  //           _err = null;
  //         }
  //       });
  //     });
  //
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.colorPrimary));
    FlutterStatusbarcolor.setStatusBarColor(AppColors.colorPrimary);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      builder: () => GetMaterialApp(
          navigatorKey: _navKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.getRoutes,

          theme: ThemeData(
              accentColor: AppColors.colorAccent,
              primaryColor: AppColors.colorPrimary,
              fontFamily: AppFonts.FONTFAMILY_NAME,
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  color: AppColors.black,
                ),
                bodyText2: TextStyle(
                  color: AppColors.black,
                ),
              )),
          home: widget.userloggedin == null
              ? SplashScreen()
              : widget.userloggedin
                  ? HomeScreen(selectPage: 0)
                  : SplashScreen()),
    );
  }

  Future addUserToCircle(String circleId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "circle_id": circleId
    };

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.ADD_USER_TO_CIRCLE,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));

    if (response.statusCode == 200) {
      _navKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (c) => HomeScreen(
                selectPage: 1,
              )));
      // ReusableWidgets.showInfo(
      //     _scaffoldKey, context, "User Successfully Added in the Circle");
      // selectedPage = 1;
      // setState(() {});
    }
  }
}

Future _showNotification(
    String title, String description, String message) async {
  Map<String, String> circleMap = {"circleId": message};

  print("mymap" + message + "aa");

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: title,
          body: description,
          payload: circleMap,
          displayOnBackground: true,
          autoCancel: true,

          color: AppColors.colorPrimary),
      actionButtons: [
        if (message != "null" && message != "")
          NotificationActionButton(
            enabled: true,
            label: "No",
            buttonType: ActionButtonType.Default,
            key: "Cancel",
          ),
        if (message != "null" && message != "")
          NotificationActionButton(
              enabled: true,
              label: "Yes",
              buttonType: ActionButtonType.Default,
              key: "Yes")
      ],


  );
}
