import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sparks/models/LoginModel.dart';
import 'package:sparks/models/RegisterModel.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:dio/dio.dart';
import 'package:sparks/utils/Helpers.dart';

class RegisterationRepo {
  Future<RegisterModel> regiserUser(String email, String password,String username) async {
    var data = {"email": email, "password": password, "username": username,
      "device_token": Helpers.prefrences.getString(AppStrings.DEVICE_TOKEN)};
    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.REGSITER,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {

      debugPrint("!!!!"+response.data.toString());


      return RegisterModel.fromJson(response.data);
    }
  }
}
