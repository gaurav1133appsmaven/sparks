import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sparks/models/RegisterModel.dart';
import 'package:sparks/repository/RegisterationRepo.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/SessionManger.dart';
import 'package:sparks/utils/Validations.dart';

class RegisterationBloc {
  SessionManager prefs = SessionManager();
  final repo = RegisterationRepo();
  var m_email = BehaviorSubject<String>();
  var m_password = BehaviorSubject<String>();
  var _username = BehaviorSubject<String>();
  var _showLoader = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get showLoader => _showLoader.stream;

  Stream<String> get email => m_email.stream.transform(_validateEmail);

  Function(String) get emailChanged => m_email.sink.add;

  Stream<String> get password => m_password.stream.transform(_validatePassword);

  Function(String) get passwordChanged => m_password.sink.add;

  Stream<String> get username => _username.stream.transform(_validateUsername);

  Function(String) get usernameChanged => _username.sink.add;

  String validateFields() {
    if (m_email.value == null) {
      return AppStrings.EMAIL_BLANK;
    } else if (!Validations.validateEmail(m_email.value)) {
      return AppStrings.EMAIL_VALIDATION;
    } else if (m_password.value == null) {
      return AppStrings.PASSOWRD_BLANK;
    } else if (m_password.value.length < 8) {
      return AppStrings.PASSWORD_VALIDATION;
    } else {
      return null;
    }
  }

  String validateUsername() {

    if (_username.value == null ||
        _username.value.replaceAll(new RegExp(r"\s+"), "") == null ||
        _username.value.replaceAll(new RegExp(r"\s+"), "") == "") {
      return AppStrings.USERNAME_BLANK;
    } else {
      usernameChanged(_username.value.trim());
      if(_username.value.isEmpty)
        return AppStrings.USERNAME_BLANK;
      return null;
    }
  }

  // bool checkSpace()
  // {
  //   if(_username.value.trim()=="")
  //     {
  //      _username.sink.add(event)
  //     }
  //
  //
  // }

  Future<RegisterModel> registerUser() async {
    _showLoader.sink.add(true);

    var result = await repo.regiserUser(
        m_email.value, m_password.value, _username.value);
    debugPrint("resultValue"+result.status.toString());
    // prefs.setUserEmail(result.data.email);
    // prefs.setUserid(result.data.userId);
    if(result.status==200)
      {
        Helpers.prefrences.setString(AppStrings.USER_ID, result.data.userId);
        Helpers.prefrences.setString(AppStrings.USER_EMAIL, result.data.email);
        Helpers.prefrences.setString(AppStrings.USER_USERNAME, result.data.userName);
      }

    _showLoader.sink.add(false);
    return result;

//  await  prefs.setUserLoginStatus(true);
  }

  dispose() async {
    await m_email.drain();
    m_email.close();

    await m_password.drain();
    m_password.close();

    await _username.drain();
    _username.close();
  }

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length < 0) {
      sink.addError(AppStrings.EMAIL_BLANK);
    } else if (!Validations.validateEmail(email)) {
      sink.addError(AppStrings.EMAIL_VALIDATION);
    } else {
      sink.add(email);
    }
  });

  final _validateUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.length < 0) {
      sink.addError(AppStrings.USERNAME_BLANK);
    }
    // else if(username.startsWith(" "))
    //   {
    //   //  sink.add(username.trimLeft());
    //     sink.add(username.trimLeft());
    //   }
    else {
      sink.add(username);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length < 0) {
      sink.addError(AppStrings.PASSOWRD_BLANK);
    } else if (password.length < 8) {
      sink.addError(AppStrings.PASSWORD_VALIDATION);
    } else {
      sink.add(password);
    }
  });
}
