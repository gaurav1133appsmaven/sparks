import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:dio/dio.dart';

class NetworkCalls {
  //users who want to opt for premium
  static Future upgradeToPremium() async {
    var data = {"user_id": Helpers.prefrences.getString(AppStrings.USER_ID)};

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.GET_SUBSCRIPTION,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));

    if (response.statusCode == 200) {
      debugPrint("Success");
    }
    return;
  }

  static Future submitIdeaVote(String ideaId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": ideaId,
    };

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SUBMIT_VOTE_IDEA,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));

    if (response.statusCode == 200) {
debugPrint("Success");
    }
    return;
  }

  static Future submitIdea(String ideaId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": ideaId,
    };

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SUBMIT_IDEA,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));

    if (response.statusCode == 200) {
      debugPrint("Success");

    }
    return;
  }
}
