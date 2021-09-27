import 'dart:io';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers
{
    static  SharedPreferences  prefrences;
  static Future<bool> checkInternet() async
  {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       return true;
      }
    } on SocketException catch (_) {
     return false;
    }

  }

  static showPremiumContent(ScrollController _controller,double scrollValue)
  {
    _controller.animateTo(scrollValue,
        curve: Curves.fastOutSlowIn, duration: Duration (milliseconds: 1000));
  }
  static  String getDayOfMonthSuffix(int dayNum) {
      if(!(dayNum >= 1 && dayNum <= 31)) {
        throw Exception('Invalid day of month');
      }

      if(dayNum >= 11 && dayNum <= 13) {
        return 'th';
      }

      switch(dayNum % 10) {
        case 1: return 'st';
        case 2: return 'nd';
        case 3: return 'rd';
        default: return 'th';
      }
    }
    static openUrl(String url) async
    {

      if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
    }

}