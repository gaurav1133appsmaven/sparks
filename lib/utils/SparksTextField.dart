import 'package:flutter/material.dart';
import 'package:sparks/utils/AppFonts.dart';

import 'AppColors.dart';

class SparksTextField extends StatelessWidget {
  SparksTextField(this.stream, this._textEditingController, this.valueChanged,
      this.hintText, this.inputType);

  TextInputType inputType;
  TextEditingController _textEditingController;
  String hintText;
  Stream<String> stream;
  Function(String value) valueChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        return
          TextField(
            controller: _textEditingController,

            onChanged: valueChanged,
            cursorHeight: 20,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            keyboardType: inputType == null ? TextInputType.text : inputType,
            style: TextStyle(
              fontFamily: AppFonts.FONTFAMILY_ROBOTO
            ),

            decoration: new InputDecoration(
              errorText: snapshot.error,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.colorPrimary, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.colorPrimary, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.colorPrimary, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.colorPrimary, width: 2.0),
              ),
              hintStyle: TextStyle(
                  fontFamily: AppFonts.FONTFAMILY_ROBOTO
              ),
              errorStyle: TextStyle(
                  fontFamily: AppFonts.FONTFAMILY_ROBOTO
              ),
              hintText: hintText,
            ));
      },
    );
  }
}
