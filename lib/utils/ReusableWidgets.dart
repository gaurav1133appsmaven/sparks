import 'package:flutter/material.dart';
import 'package:sparks/utils/AppFonts.dart';

class ReusableWidgets {
  static showInfo(GlobalKey<ScaffoldState> key,BuildContext context,String message)
  {
    final snackBar = SnackBar(
      content: Text(message,style: TextStyle(
          fontFamily: AppFonts.FONTFAMILY_ROBOTO
      ),),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(

        label: 'Cancel',

        onPressed: (){},
        //
        // onPressed: () {
        //   Scaffold.of(context).showSnackBar(SnackBar(
        //     content:  Text(message,style: TextStyle(
        //       fontFamily: AppFonts.FONTFAMILY_ROBOTO
        //     ),),
        //     duration: const Duration(milliseconds: 500),
        //     action: SnackBarAction(
        //       label: 'Cancel',
        //
        //       onPressed: () { },
        //     ),
        //   ));
          // Some code to undo the change.
        //},
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
   key.currentState.showSnackBar(snackBar);
  }

}