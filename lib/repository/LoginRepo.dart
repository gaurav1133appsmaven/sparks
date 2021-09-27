import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sparks/models/LoginModel.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';

class LoginRepo {
  Future<Either<String, LoginModel>> loginUser(
      String email, String password) async {
    var data = {
      "email": email,
      "password": password,
      "device_token": Helpers.prefrences.getString(AppStrings.DEVICE_TOKEN)
    };
    // "device_token": Helpers.prefrences.getString(AppStrings.DEVICE_TOKEN)};

    debugPrint(data.toString());
    var response = await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.LOGIN,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",

        }),
        data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = LoginModel.fromJson(response.data);
      if (result.status == 200) {
        return Right<String, LoginModel>(LoginModel.fromJson(response.data));
      }

      return Left<String, LoginModel>(result.message);

      // return LoginModel.fromJson(response.data);
    } else {
      return Left<String, LoginModel>(response.statusMessage);
    }
  }
}
