import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sparks/ui/CreatePost.dart';
import 'package:sparks/ui/HomePage.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sparks/ui/ProfileScreen.dart';
import 'package:sparks/ui/SettingsScreen.dart';
import 'package:sparks/ui/CircleScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:sparks/utils/SessionManger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) {
  return _HomeScreenState()._showNotification(message);
}

class HomeScreen extends StatefulWidget {
  int selectPage = 0;

  HomeScreen({this.selectPage});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "";
  String description = "";
  String circleId = "";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging;
  SessionManager prefs = SessionManager();
  int count = 1;
  var pages = [
    HomePage(),
    CircleScreen(),
    CreatePost(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  int selectedPage = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  Future selectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  @override
  void dispose() {
debugPrint("dispose called");
    super.dispose();
  }

  @override
  void initState() {
    selectedPage = widget.selectPage;
    if(!AppStrings.firsTimeVisit)
      {
        return;
      }



      AwesomeNotifications().actionStream.listen((receivedNotification)async {
      if (receivedNotification.payload["circleId"] != null &&
          receivedNotification.payload["circleId"] != "") {
        if (receivedNotification.buttonKeyPressed == "Yes") {
          addUserToCircle(receivedNotification.payload['circleId']);
        }
        else if (receivedNotification.buttonKeyPressed == "" &&
            receivedNotification.payload["circleId"] != "") {
          debugPrint("target1");
          await Future.delayed(Duration(milliseconds: 500));
          debugPrint("target 2");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.QUICK_IDEA_BACKGROUND,
                  title: Text(
                    receivedNotification.title,
                    style: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_BOLD,
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.w900),
                  ),
                  content: Text(
                    receivedNotification.body,
                    style: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(36)),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorPrimary,
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        addUserToCircle(
                            receivedNotification.payload['circleId']);
                      },
                    ),
                  ],
                );
              });
        }
      }


    }
      );

    super.initState();
    }

        Future _showNotification(Map<String, dynamic > message)
    async {
      var initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_launcher_playstore');

      var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);

      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel desc',
        importance: Importance.max,
        priority: Priority.high,
      );

      var platformChannelSpecifics =
      new NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message['data']['title'] + "3",
        message['data']['body'],
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
          child: Scaffold(
              key: _scaffoldKey,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: 0,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: selectedPage == 0
                          ? ImageIcon(AssetImage("assets/images/ic_home.png"),
                          color: AppColors.colorAccent)
                          : ImageIcon(AssetImage("assets/images/ic_home.png")),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: selectedPage == 1
                          ? ImageIcon(AssetImage("assets/images/ic_share.png"),
                          color: AppColors.colorAccent)
                          : ImageIcon(
                        AssetImage("assets/images/ic_share.png"),
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: Image.asset("assets/images/ic_add.png"), label: ""),
                  BottomNavigationBarItem(
                      icon: selectedPage == 3
                          ? ImageIcon(
                          AssetImage("assets/images/ic_profile.png"),
                          color: AppColors.colorAccent)
                          : ImageIcon(
                        AssetImage("assets/images/ic_profile.png"),
                      ),
                      label: ""),
                  BottomNavigationBarItem(
                      icon: selectedPage == 4
                          ? ImageIcon(
                        AssetImage("assets/images/ic_settings.png"),
                        color: AppColors.colorAccent,
                      )
                          : ImageIcon(
                        AssetImage("assets/images/ic_settings.png"),
                      ),
                      label: "")
                ],
              ),
              body: pages[selectedPage]));
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
        // ReusableWidgets.showInfo(
        //     _scaffoldKey, context, "User Successfully Added in the Circle");
        selectedPage = 1;
        setState(() {

        });
      }
    }
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print('AppPushs myBackgroundMessa');
    print('AppPushs myBackgroundMessageHandler : $message');
    print('AppPushs myBackgroundMessageHandler : $message');
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }