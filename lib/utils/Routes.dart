import 'package:flutter/material.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/LoginScreen.dart';
import 'package:sparks/ui/RegisterUsername.dart';
import 'package:sparks/ui/RegisterScreen.dart';

class Routes {
  static const String SplashRoute = "/";
  static const String LoginRoute = "/login";
  static const String RegisterationRoute = "/registeration";
  static const String QuestionnaireRoute = "/questionnaire";
  static const String HomeScreenRoute = "/homescreen";

  static Route<dynamic> getRoutes(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case LoginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegisterationRoute:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      // case QuestionnaireRoute:
      //   return MaterialPageRoute(builder: (_) => RegisterUsername());
      case HomeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen(selectPage: 0));
    }
  }
}
