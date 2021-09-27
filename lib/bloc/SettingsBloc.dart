import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';

class SettingsBloc {
  var _editDetails = BehaviorSubject<bool>.seeded(false);
  var _showloader = BehaviorSubject<bool>.seeded(false);
  var _firstName = BehaviorSubject<String>();
  var _lastName = BehaviorSubject<String>();
  var _email = BehaviorSubject<String>();
  var _userName = BehaviorSubject<String>();
  var _phone = BehaviorSubject<String>();
  var _country = BehaviorSubject<String>();
  var _state = BehaviorSubject<String>();
  var _city = BehaviorSubject<String>();
  var _birthday = BehaviorSubject<String>();
  var _ethnicity = BehaviorSubject<String>();
  var _gender = BehaviorSubject<String>();



  //Observable streams

  Stream<String> get email => _email.stream;

  Stream<String> get firstName => _firstName.stream;

  Stream<String> get lastName => _lastName.stream;

  Stream<String> get country => _country.stream;

  Stream<String> get state => _state.stream;

  Stream<String> get city => _city.stream;

  Stream<String> get birthday => _birthday.stream;

  Stream<String> get ethnicity => _ethnicity.stream;

  Stream<String> get phone => _phone.stream;

  Stream<String> get username => _userName.stream;

  Stream<String> get gender => _gender.stream;

  Stream<bool> get showLoader => _showloader.stream;

  //value updation

  Function(String) get emailChanged => _email.sink.add;

  Function(String) get phoneChanged => _phone.sink.add;

  Function(String) get firstnameChanged {

    return _firstName.sink.add;
  }

  Function(String) get countryChanged => _country.sink.add;

  Function(String) get birthdayChanged => _birthday.sink.add;

  Function(String) get ethnicityChanged => _ethnicity.sink.add;

  Function(String) get lastNameChanged => _lastName.sink.add;

  Function(String) get stateChanged => _state.sink.add;

  Function(String) get cityChanged => _city.sink.add;

  Function(String) get userNameChanged => _userName.sink.add;

  Function(String) get genderChanged => _gender.sink.add;
}