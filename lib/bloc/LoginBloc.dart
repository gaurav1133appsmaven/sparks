import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sparks/models/LoginModel.dart';
import 'package:sparks/repository/LoginRepo.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/SessionManger.dart';
import 'package:sparks/utils/Validations.dart';
import 'package:dartz/dartz.dart';

class LoginBloc {
  bool initialCount = false; //if
  var repo = LoginRepo();
  var _email = BehaviorSubject<String>();
  var _password = BehaviorSubject<String>();
  var _showLoader = BehaviorSubject<bool>();

  LoginBloc() {
    _showLoader.add(false);
  }

  Stream<bool> get showLoader => _showLoader.stream;

//  Function(bool) get loaderValueChanged => _showLoader.sink.add;

  Stream<String> get email => _email.stream.transform(_validateEmail);

  Function(String) get emailChanged => _email.sink.add;

  Stream<String> get password => _password.stream.transform(_validatePassword);

  Function(String) get passwordChanged => _password.sink.add;

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

  dispose() async {
    await _email.drain();
    _email.close();

    await _password.drain();
    _password.close();
  }

  Future<Either<String, LoginModel>> loginUser() async {
    _showLoader.sink.add(true);
    Either<String, LoginModel> result =
        await repo.loginUser(_email.value, _password.value);
    // var result = await repo.loginUser(_email.value, _password.value);

    result.fold((l) {
      _showLoader.sink.add(false);
      Left<String, LoginModel>(l);
    }, (r) {

      _showLoader.sink.add(false);

      Right<String, LoginModel>(r);
    });
    return result;
  }

  String validateFields() {
    if (_email.value == null) {
      return AppStrings.EMAIL_BLANK;
    } else if (_password.value == null) {
      return AppStrings.PASSOWRD_BLANK;
    } else {
      return null;
    }
  }
}
