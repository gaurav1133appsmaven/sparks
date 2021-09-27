import 'package:flutter/material.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sparks/utils/AppFonts.dart';

class FullscreenImage extends StatelessWidget {
  String image;

  FullscreenImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Preview",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
              fontSize: ScreenUtil().setSp(40)),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: ImageIcon(
            AssetImage("assets/images/ic_close.png"),
            color: AppColors.white,
          ),
        ),
      ),
      body: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
              backgroundColor: AppColors.colorPrimary,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
