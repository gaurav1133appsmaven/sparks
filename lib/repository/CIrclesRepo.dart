import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sparks/models/CirclesListModel.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';

class CirclesRepo {
  Future<Either<String, CirclesListModel>> getCirclesData() async {
    var data = {"user_id": "1"};


    print("data isss"+data.toString());
    var response = await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.SHOW_CIRCLES,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("response getting raw data= " + response.data.toString());
      var result = CirclesListModel.fromJson(response.data);
      if (result.status == 200) {
        return Right<String, CirclesListModel>(
            CirclesListModel.fromJson(response.data));
      }

      return Left<String, CirclesListModel>(result.message);

      // return LoginModel.fromJson(response.data);
    } else {
      return Left<String, CirclesListModel>(response.statusMessage);
    }
  }
}
