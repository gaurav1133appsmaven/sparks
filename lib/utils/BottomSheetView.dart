import 'package:flutter/material.dart';
import 'package:sparks/ui/QuickAdd.dart';
import 'package:sparks/utils/AppColors.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/SessionManger.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomSheetView extends StatefulWidget {
  String path;

  BottomSheetView({this.path});

  @override
  _BottomSheetViewState createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {

  AudioPlayer audioPlayer = AudioPlayer();
  int playerID;

  List<Color> colors = [
    AppColors.colorPrimary,
    AppColors.colorPrimary,
    AppColors.colorPrimary,
    AppColors.colorPrimary
  ];
  List<int> duration = [900, 700, 600, 800, 500];

  bool startanim = false;


  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();

debugPrint("dispose called");

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  String recordFilePath;
  String statusText = "";
  bool isComplete = false;
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  SessionManager prefs = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(480),
      color: AppColors.LIGHT_GREY,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (startanim)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(120),
                    vertical: ScreenUtil().setHeight(20)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        20,
                            (index) => AnimWidget(
                            duration: duration[index % 5],
                            color: colors[index % 4]))),
              ),

            if (!startanim) GestureDetector(
              child:
              Padding(
                padding:  EdgeInsets.all(ScreenUtil().setHeight(40)),
                child: ClipOval(
                  child: Container(
                    width: 54,
                    height: 54,
                    color: AppColors.colorPrimary,
                    child: Column(
                      children: [
                        Container(
                          height: 30.0,
                          //      decoration: BoxDecoration(color: Colors.red.shade300),
                          child: Center(
                              child: Icon(
                                Icons.preview_outlined,
                                color: AppColors.white,
                              )),
                        ),
                        Text(
                          "Preview",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:
                            AppFonts.FONTFAMILY_ROBOTO,
                            fontSize: ScreenUtil().setSp(24),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {



                try {
                  setState(() {
                    startanim = true;
                  });


                  audioPlayer.play(widget.path);

                  audioPlayer.onPlayerCompletion.listen((event) {

                    audioPlayer.stop();
                    setState(() {
                      startanim = false;


                    });
                  });


                } catch (t) {
                  //mp3 unreachable
                }
              },
            ),



            Container(
              width: double.infinity,
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
              child: RaisedButton(
                color: AppColors.colorPrimary,
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.pop(context, "0");
                },
                child: Text(
                  "Back",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  // void play() {
  //   if (recordFilePath != null && File(recordFilePath).existsSync()) {
  //     setState(() {
  //       startanim = true;
  //     });
  //     AudioPlayer audioPlayer = AudioPlayer();
  //
  //     audioPlayer.play(recordFilePath, isLocal: true);
  //   }
  // }

}
