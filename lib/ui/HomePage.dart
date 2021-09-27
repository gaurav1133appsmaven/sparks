import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparks/models/HomePageModel.dart';
import 'package:sparks/models/IdeasListModel.dart';
import 'package:sparks/models/QuickIdeaModel.dart';
import 'package:sparks/models/SimpleResponse.dart';
import 'package:sparks/models/TopSuggestionModel.dart';
import 'package:sparks/ui/FullscreenImage.dart';
import 'package:sparks/ui/HomeScreen.dart';
import 'package:sparks/ui/IdeaDetails.dart';
import 'package:sparks/ui/Limit2Screen.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:sparks/utils/ApiEndpoints.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppFonts.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/CustomDropdownButton.dart';
import 'package:sparks/utils/Helpers.dart';
import 'package:sparks/utils/ReusableWidgets.dart';
import 'package:sparks/utils/SessionManger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'QuickAdd.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cloudinary =
      CloudinaryPublic(AppStrings.CLOUD_NAME, AppStrings.UPLOAD_PRESET, cache: false);
  final picker = ImagePicker();
  var ideaslist = List<Data2>();
  bool showloader = false;
  SessionManager prefs = SessionManager();
  List<ListItem> _list = [
    ListItem(0, "Grid"),
    ListItem(1, "Picture list"),
    ListItem(2, "Pin Board"),
    ListItem(3, "List")
  ];
  String formattedDate = "";

  List<ListItem> _filters = [
    ListItem(0, "Newest"),
    ListItem(1, "Oldest"),
    ListItem(2, "Alphabetically"),
  ];

  int _selectedList = 0;
  int _selectedFilter = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String searcKeyword = "";

  String imageToAdd = "";

  String memo = "";

  String filterName = "Newest";

  @override
  void initState() {
    debugPrint(Helpers.prefrences.getString(AppStrings.DEVICE_TOKEN));
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-dd-yyyy');
    formattedDate = formatter.format(now);
    AppStrings.firsTimeVisit=false;
    Future.delayed(Duration(seconds: 1), () {
      Helpers.checkInternet().then((value) {
        if (!value)
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Please connect to the internet!");
      });
    });

    super.initState();
  }

  Future<HomePageModel> getIdeasList(String keyword, String filter) async {
    debugPrint("mykeyword " + keyword);

    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "search": keyword.trim(),
      "filter": filter.trim()
    };
    debugPrint("data " + data.toString());

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.HOMESCREEN_DATA_LIST,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.toString());
// json.decode(response.data);
      return HomePageModel.fromJson(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("selected list"+_selectedList.toString());
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: AppColors.colorPrimary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(


                        child: Container(
                          color: AppColors.colorPrimary,
                          width: double.infinity,
                          child: Image.asset("assets/images/ic_homebanner.png"),
                        ),
                        onTap: () async{
                          PackageInfo packageInfo = await PackageInfo.fromPlatform();
                          String version = packageInfo.version;
                          String code = packageInfo.buildNumber;


                          debugPrint("version code"+version+"====="+code);
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(50)),
                          child: Text(
                            AppStrings.STARTUP_SUGGESTION.toUpperCase(),
                            style: TextStyle(
                                color: AppColors.YELLOW,
                                fontFamily: AppFonts.Comfortaa_Bold,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      FutureBuilder<TopSuggestionModel>(
                        builder: (contxt, snapshot) {
                          if (!snapshot.hasData) {
                            return Center();

                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20),
                                vertical: ScreenUtil().setHeight(10)),
                            child: InkWell(
                              onTap: ()async {
                               await Navigator.push(context, MaterialPageRoute(builder: (builder)=>IdeaDetails(postId: snapshot.data.data.id
                                  ,)));
                               setState(() {

                               });
                              },
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setHeight(20))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: ScreenUtil().setHeight(200),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.backgoundLight,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            padding: EdgeInsets.only(
                                                top:
                                                    ScreenUtil().setHeight(12),
                                                bottom:
                                                ScreenUtil().setWidth(0),
                                                left:
                                                    ScreenUtil().setWidth(4), right:
                                            ScreenUtil().setWidth(4)),
                                            child: Container(

                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom:4.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Container(

                                                      child: Align(
                                                          alignment:
                                                              Alignment.centerLeft,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: ScreenUtil()
                                                                    .setWidth(14)),
                                                            child: Text(
                                                              snapshot.data.data.title,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  fontSize: ScreenUtil()
                                                                      .setSp(32),


                                                                  fontFamily: AppFonts
                                                                      .FONTFAMILY_ROBOTO_MEDIUM),
                                                            ),
                                                          )),
                                                    ),
                                                    Text(
                                                      AppStrings.ALGOTITHM_SCORE,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          AppFonts.Comfortaa_Bold,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.white,
                                                          fontSize:
                                                          ScreenUtil().setSp(50)),
                                                    ),
                                                    Container(

                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal:4.0),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            InkWell(onTap: (){
                                                              UpdateTopIdeaPopup(snapshot.data.data);
                                                            },
                                                              child: Container(
                                                                height: ScreenUtil()
                                                                    .setHeight(46),
                                                                width: ScreenUtil()
                                                                    .setWidth(70),
                                                                child: Image.asset(
                                                                  "assets/images/ic_camera.png",fit: BoxFit.fill,),),
                                                            ),
                                                            Expanded(
                                                              child: Container(

                                                                child: Column(
                                                                  children: [

                                                                    Text(
                                                                      snapshot.data.data.score
                                                                          .toString() +
                                                                          "%",
                                                                      textAlign:
                                                                      TextAlign.center,
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .colorAccent,
                                                                          fontFamily: AppFonts.Comfortaa_Regular,
                                                                          fontSize: ScreenUtil()
                                                                              .setSp(60)),
                                                                    )

                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                String data =
                                                                await showModalBottomSheet(
                                                                  context: context,
                                                                  builder: (_) =>
                                                                      MyBottomSheet(),
                                                                );

                                                                if (data != null) {
                                                                  setState(() {
                                                                    showloader = true;
                                                                  });
                                                                  uploadTopscoreMemo(
                                                                      data,
                                                                      snapshot.data
                                                                          .data)
                                                                      .then((value) {
                                                                    setState(() {
                                                                      showloader =
                                                                      false;
                                                                    });
                                                                  });
                                                                }
                                                              },

                                                              child: Container(
                                                                height: ScreenUtil()
                                                                    .setHeight(46),
                                                                width: ScreenUtil()
                                                                    .setWidth(50),
                                                                child: Image.asset(
                                                                  "assets/images/ic_mic.png",fit: BoxFit.contain,),),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(250),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot.data.data.coverImg,
                                                  ),
                                                  fit: BoxFit.fill)),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data.data.coverImg,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: ScreenUtil().setWidth(250),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                                // borderRadius: BorderRadius.all(
                                                //     Radius.circular(
                                                //         ScreenUtil().setHeight(20))),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      AppColors.colorPrimary,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors.colorAccent)),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        },
                        future: getTopScorer(),
                      ),
                      Container(
                          color: AppColors.search_background,
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(40)),
                          child: Column(
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(70),
                                margin: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(10)),
                                color: AppColors.white,
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  cursorHeight: 10,
                                  onSubmitted: (a) {
                                    //getIdeas("ok");
                                    //   getIdeasList(a);
                                    setState(() {
                                      searcKeyword = a;
                                    });
                                  },
                                  style: TextStyle( fontFamily: AppFonts
                                      .FONTFAMILY_ROBOTO_MEDIUM,
                                    height: ScreenUtil().setHeight(1),
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 12.0, bottom: 6.0),
                                      hintText: "Search...",
                                      hintStyle: TextStyle( fontFamily: AppFonts
                                          .FONTFAMILY_ROBOTO_MEDIUM,)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: DropdownButtonHideUnderline(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            canvasColor:
                                                AppColors.backgoundLight,
                                          ),
                                          child: CustomDropdownButton(
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _list[_selectedList].name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppColors.white,
                                                      fontFamily: AppFonts
                                                          .FONTFAMILY_ROBOTO_MEDIUM,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: ScreenUtil()
                                                          .setSp(30)),
                                                ),
                                              ),
                                            ),
                                            items: _list
                                                .map((e) => DropdownMenuItem(
                                                    value: e.value,
                                                    child: Text(
                                                      e.name,
                                                      style: TextStyle(
                                                        color: AppColors.black,
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO,
                                                      ),
                                                    )))
                                                .toList(),
                                            onChanged: (value) {
                                              debugPrint(value.toString());

                                              setState(() {
                                                _selectedList = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      height: ScreenUtil().setHeight(50),
                                      color: AppColors.backgoundLight,
                                    )),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(20),
                                    ),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        ReusableWidgets.showInfo(
                                            _scaffoldKey,
                                            context,
                                            "Temporary not available!");
                                      },
                                      child: Container(
                                        child: DropdownButtonHideUnderline(
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              canvasColor:
                                                  AppColors.backgoundLight,
                                            ),
                                            child: CustomDropdownButton(
                                              hint: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    _filters[_selectedFilter]
                                                        .name,
                                                    style: TextStyle(
                                                        color: AppColors.white,
                                                        fontFamily: AppFonts
                                                            .FONTFAMILY_ROBOTO_MEDIUM,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: ScreenUtil()
                                                            .setSp(30)),
                                                  ),
                                                ),
                                              ),
                                              items: _filters
                                                  .map((e) => DropdownMenuItem(
                                                      value: e.value,
                                                      child: Text(
                                                        e.name,
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.black,
                                                          fontFamily: AppFonts
                                                              .FONTFAMILY_ROBOTO,
                                                        ),
                                                      )))
                                                  .toList(),
                                              onChanged: (value) {
                                                debugPrint(value.toString());
                                                _selectedFilter = value;
                                                setState(() {
                                                  filterName =
                                                      _filters[value].name;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        height: ScreenUtil().setHeight(50),
                                        color: AppColors.backgoundLight,
                                      ),
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),

                getList(_selectedList, searcKeyword, filterName)
              ],
            ),
            if (showloader)
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppColors.colorPrimary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getList(int index, String keyword, String filter) {
    debugPrint("selected filter is " + filter);
    switch (index) {
      case 0:
        return Flexible(
          fit: FlexFit.loose,
          child: FutureBuilder<HomePageModel>(
            future: getIdeasList(keyword, filterName),
            builder: (contxt, snapshot) {
              if (!snapshot.hasData) {
                debugPrint("loader" + snapshot.data.toString());
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppColors.colorPrimary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.colorAccent)),
                );
              } else if (snapshot.hasData && snapshot.data.data.isEmpty) {
                return Center(
                  child: Text("No posts yet!",style: TextStyle(
                    fontFamily: AppFonts.FONTFAMILY_ROBOTO,fontSize: ScreenUtil().setSp(30)
                  ),),
                );
              }

              return Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(2)),
                child: GridView.builder(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        deleteConfirmation(snapshot.data.data[index].id);
                      },
                      onTap: () async{
                      await  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IdeaDetails(
                                    postId: snapshot.data.data[index].id,
                                   )));
                        setState(() {

                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Stack(
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data.data[index].coverImg,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    // borderRadius: BorderRadius.all(
                                    //     Radius.circular(
                                    //         ScreenUtil().setHeight(20))),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: AppColors.colorPrimary,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.colorAccent)),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  height: ScreenUtil().setHeight(100),
                                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                                  color: Colors.white.withOpacity(0.5),
                                  child: Center(
                                      child: Text(
                                    snapshot.data.data[index].title,
                                    maxLines:2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily:
                                            AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(32)),
                                  )),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          addImage(snapshot, index);
                                        },
                                        child: ImageIcon(
                                          AssetImage(
                                              "assets/images/ic_camera.png"),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          String data =
                                              await showModalBottomSheet(
                                            context: context,
                                            builder: (_) => MyBottomSheet(),
                                          );

                                          if (data != null) {
                                            setState(() {
                                              showloader = true;
                                            });
                                            uploadFile(data,
                                                    snapshot.data.data[index])
                                                .then((value) {
                                              setState(() {
                                                showloader = false;
                                              });
                                            });
                                          }
                                        },
                                        child: ImageIcon(
                                          AssetImage(
                                              "assets/images/ic_mic.png"),
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data.data.length,
                ),
              );
            },
          ),
        );
      case 1:
        return Flexible(
          fit: FlexFit.loose,
          child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(2)),
              child: FutureBuilder<HomePageModel>(
                  future: getIdeasList(keyword, filterName),
                  builder: (contxt, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: AppColors.colorPrimary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorAccent)),
                      );
                    } else if (snapshot.hasData && snapshot.data.data.isEmpty) {
                      return Center(
                        child: Text("No posts yet!"),
                      );
                    }

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            deleteConfirmation(snapshot.data.data[index].id);
                          },
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IdeaDetails(
                                        postId: snapshot.data.data[index].id,
                                      )));
                            setState(() {

                            });
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(200),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(20),
                                  vertical: ScreenUtil().setHeight(10)),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setHeight(20))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    height: ScreenUtil().setHeight(200),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.backgoundLight,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    ScreenUtil().setHeight(10),
                                                horizontal:
                                                    ScreenUtil().setWidth(4)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: ScreenUtil()
                                                              .setWidth(10)),
                                                      child: Text(
                                                        snapshot.data
                                                            .data[index].title,

                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily: AppFonts
                                                                .FONTFAMILY_ROBOTO_MEDIUM),
                                                      ),
                                                    )),
                                                Text(
                                                  AppStrings.ALGOTITHM_SCORE,
                                                  style: TextStyle(
                                                      fontFamily: AppFonts
                                                          .Comfortaa_Bold,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(40)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          addImage(
                                                              snapshot, index);
                                                        },
                                                        child: Container(
                                                            height: ScreenUtil()
                                                                .setHeight(50),
                                                            width: ScreenUtil()
                                                                .setWidth(50),
                                                            child: ImageIcon(
                                                              AssetImage(
                                                                  "assets/images/ic_camera.png"),
                                                              color: AppColors
                                                                  .colorPrimary,
                                                            )),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        snapshot
                                                            .data
                                                            .data[index]
                                                            .percentage
                                                            .toString()+"%",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .colorAccent,
                                                            fontFamily: AppFonts.Comfortaa_Regular,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(60)),
                                                      )),
                                                      InkWell(
                                                        onTap: () async {
                                                          String data =
                                                              await showModalBottomSheet(
                                                            context: context,
                                                            builder: (_) =>
                                                                MyBottomSheet(),
                                                          );

                                                          if (data != null) {
                                                            setState(() {
                                                              showloader = true;
                                                            });
                                                            uploadFile(
                                                                    data,
                                                                    snapshot.data
                                                                            .data[
                                                                        index])
                                                                .then((value) {
                                                              setState(() {
                                                                showloader =
                                                                    false;
                                                              });
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                            child: ImageIcon(
                                                          AssetImage(
                                                              "assets/images/ic_mic.png"),
                                                          color: AppColors
                                                              .colorPrimary,
                                                        )),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenUtil().setWidth(250),
                                          // decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.only(
                                          //         topRight: Radius.circular(10),
                                          //         bottomRight: Radius.circular(10)),
                                          //     image: DecorationImage(
                                          //         image: AssetImage(
                                          //           "assets/images/splash_background.png",
                                          //         ),
                                          //         fit: BoxFit.fill)),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot
                                                .data.data[index].coverImg,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      AppColors.colorPrimary,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors
                                                              .colorAccent)),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                    );
                  })),
        );
      case 2:
        return Flexible(
          fit: FlexFit.loose,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<HomePageModel>(
                future: getIdeasList(keyword, filterName),
                builder: (contxt, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AppColors.colorPrimary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorAccent)),
                    );
                  } else if (snapshot.hasData && snapshot.data.data.isEmpty) {
                    return Center(
                      child: Text("No posts yet!"),
                    );
                  }

                  return GridView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          deleteConfirmation(snapshot.data.data[index].id);
                        },
                        onTap: () async{
                         await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IdeaDetails(
                                      postId: snapshot.data.data[index].id,
                                    )));
                         setState(() {

                         });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setHeight(10)),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setHeight(6))),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          ScreenUtil().setHeight(6)),
                                      topRight: Radius.circular(
                                          ScreenUtil().setHeight(6)),
                                      bottomLeft: Radius.circular(
                                          ScreenUtil().setHeight(2)),
                                      bottomRight: Radius.circular(
                                          ScreenUtil().setHeight(2)),
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        snapshot.data.data[index].coverImg,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              ScreenUtil().setHeight(2)),
                                          topRight: Radius.circular(
                                              ScreenUtil().setHeight(2)),
                                          bottomLeft: Radius.circular(
                                              ScreenUtil().setHeight(2)),
                                          bottomRight: Radius.circular(
                                              ScreenUtil().setHeight(2)),
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                          backgroundColor:
                                              AppColors.colorPrimary,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.colorAccent)),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: ScreenUtil().setHeight(100),
                                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                                      color: Colors.white.withOpacity(0.5),
                                      child: Center(
                                          child: Text(
                                        snapshot.data.data[index].title,

                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: AppFonts
                                                .FONTFAMILY_ROBOTO_MEDIUM,
                                            fontWeight: FontWeight.w700,
                                            fontSize: ScreenUtil().setSp(32)),
                                      )),
                                    ),
                                    Spacer(),
                                    Divider(
                                      thickness: 2.0,
                                      height: 0,
                                      color: AppColors.black,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.PIN_BARCOLOR,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              ScreenUtil().setHeight(2)),
                                          bottomRight: Radius.circular(
                                              ScreenUtil().setHeight(2)),
                                          topLeft: Radius.circular(
                                              ScreenUtil().setHeight(0)),
                                          topRight: Radius.circular(
                                              ScreenUtil().setHeight(0)),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(
                                          ScreenUtil().setHeight(10)),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              addImage(snapshot, index);
                                            },
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/ic_camera.png"),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              String data =
                                                  await showModalBottomSheet(
                                                context: context,
                                                builder: (_) => MyBottomSheet(),
                                              );

                                              if (data != null) {
                                                setState(() {
                                                  showloader = true;
                                                });
                                                uploadFile(
                                                        data,
                                                        snapshot
                                                            .data.data[index])
                                                    .then((value) {
                                                  setState(() {
                                                    showloader = false;
                                                  });
                                                });
                                              }
                                            },
                                            child: ImageIcon(
                                              AssetImage(
                                                  "assets/images/ic_mic.png"),
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: snapshot.data.data.length,
                  );
                },
              )),
        );
      case 3:
        return Flexible(
          fit: FlexFit.loose,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<HomePageModel>(
                  future: getIdeasList(keyword, filterName),
                  builder: (contxt, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: AppColors.colorPrimary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorAccent)),
                      );
                    } else if (snapshot.hasData && snapshot.data.data.isEmpty) {
                      return Center(
                        child: Text("No posts yet!"),
                      );
                    }

                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.backgoundLight,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            deleteConfirmation(snapshot.data.data[index].id);
                          },
                          onTap: () async{
                         await   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IdeaDetails(
                                        postId: snapshot.data.data[index].id,
                                       )));
                         setState(() {

                         });
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(70),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(26),
                                    height: ScreenUtil().setHeight(26),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index % 2 == 0
                                            ? AppColors.colorAccent50
                                            : AppColors.colorPrimary),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data.data[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily:
                                              AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                                          fontWeight: FontWeight.w700,
                                          fontSize: ScreenUtil().setSp(30)),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      addImage(snapshot, index);
                                    },
                                    child: ImageIcon(
                                      AssetImage("assets/images/ic_camera.png"),
                                      color: AppColors.colorPrimary,
                                      size: ScreenUtil().setHeight(60),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(60),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      String data = await showModalBottomSheet(
                                        context: context,
                                        builder: (_) => MyBottomSheet(),
                                      );

                                      if (data != null) {
                                        setState(() {
                                          showloader = true;
                                        });
                                        uploadFile(
                                                data, snapshot.data.data[index])
                                            .then((value) {
                                          setState(() {
                                            showloader = false;
                                          });
                                        });
                                      }
                                    },
                                    child: ImageIcon(
                                      AssetImage("assets/images/ic_mic.png"),
                                      color: AppColors.colorPrimary,
                                      size: ScreenUtil().setHeight(60),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                    );
                  })),
        );
    }
  }

  Future<TopSuggestionModel> getTopScorer() async {
    var data = {"user_id": Helpers.prefrences.getString(AppStrings.USER_ID)};

    var response =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.TOP_SUGGESTION,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.toString());

      return TopSuggestionModel.fromJson(response.data);
    }
  }
  Future updateTopIdeaImage(ImageSource source, Data model) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        showloader = true;
      });
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );
        print("response data is");
        print("from2" + response.secureUrl);
        imageToAdd = response.secureUrl;

        //update the data
        String images = model.gallery;
        if (images == "") {
          images = imageToAdd;
        } else {
          images = images + "," + imageToAdd;
        }

        var data = {
          "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
          "idea_id": model.id,
          "title": model.title,
          "cover_image": model.coverImg,
          "voice_message": model.voiceMsg,
          "insert_type": "Detailed Add",
          "description": model.description,
          "gallery": images,
          "notes": model.notes,
          "interest": model.interests.toString(),
          "priority": model.priority.toString(),
          "solution_type": model.solutionType
        };

        print(data.toString());

        bool result = await Helpers.checkInternet();
        if (result) {
          setState(() {
            showloader = true;
          });
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, AppStrings.INTERNET_NOT_CONNECTED);
          return;
        }

        var response2 =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_IDEA,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
        setState(() {
          showloader = false;
        });

        if (response2.statusCode == 200) {

          var result = QuickIdeaModel.fromJson(response2.data);
          if (result.status == 200) {
            if (result.success == 1) {
              Future.delayed(const Duration(seconds: 1), () {
// Here you can write your code
              setState(() {

              });
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => HomeScreen(
//                           selectPage: 0,
//                         )),
//                         (Route<dynamic> route) => false);
              });

              ReusableWidgets.showInfo(
                  _scaffoldKey, context, "Your idea is updated successfully!");
            } else {
              ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
            }
          }

          // return LoginModel.fromJson(response.data);
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Something went wrong!");
        }
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }
      setState(() {
        showloader = false;
      });
    }
  }

  Future getImage(ImageSource source, HomeData model) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        showloader = true;
      });
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedFile.path,
              resourceType: CloudinaryResourceType.Image),
        );
        print("response data is");
        print("from2" + response.secureUrl);
        imageToAdd = response.secureUrl;

        //update the data
        String images = model.gallery;
        if (images == "") {
          images = imageToAdd;
        } else {
          images = images + "," + imageToAdd;
        }
        String voiceMessages="";
        if (model.voiceMsg.isNotEmpty) {
      for(int i=0;i<model.voiceMsg.length;i++)
        {
          voiceMessages=voiceMessages+model.voiceMsg[i]+",";
        }
      voiceMessages=voiceMessages.substring(0, voiceMessages.length - 1);
        }

        var data = {
          "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
          "idea_id": model.id,
          "title": model.title,
          "cover_image": model.coverImg,
          "voice_message": voiceMessages,
          "insert_type": "Detailed Add",
          "description": model.description,
          "gallery": images,
          "notes": model.notes,
          "interest": model.interests.toString(),
          "priority": model.priority.toString(),
          "solution_type": model.solutionType
        };

        print(data.toString());

        bool result = await Helpers.checkInternet();
        if (result) {
          setState(() {
            showloader = true;
          });
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, AppStrings.INTERNET_NOT_CONNECTED);
          return;
        }

        var response2 =
            await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_IDEA,
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                }),
                data: jsonEncode(data));
        setState(() {
          showloader = false;
        });

        if (response2.statusCode == 200) {
          debugPrint(
              "response getting rawzzzz data= " + response2.data.toString());
          var result = QuickIdeaModel.fromJson(response2.data);
          if (result.status == 200) {
            if (result.success == 1) {
              Future.delayed(const Duration(seconds: 1), () {
// Here you can write your code
              setState(() {

              });
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => HomeScreen(
//                               selectPage: 0,
//                             )),
//                     (Route<dynamic> route) => false);
              });

              ReusableWidgets.showInfo(
                  _scaffoldKey, context, "Your idea is updated successfully!");
            } else {
              ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
            }
          }

          // return LoginModel.fromJson(response.data);
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Something went wrong!");
        }
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }
      setState(() {
        showloader = false;
      });
    }
  }

  Future uploadFile(String file, HomeData model) async {

    if (file != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file,
              resourceType: CloudinaryResourceType.Raw),
        );

        debugPrint("inside memo received" + memo);

        //update the data

        if (model.voiceMsg.isEmpty) {
          memo = response.secureUrl+"date"+formattedDate;
          debugPrint("first");
        } else {
          String urls = "";
          debugPrint("second");
          for (int i = 0; i < model.voiceMsg.length; i++) {
            urls = urls + model.voiceMsg[i] + ",";
          }

          memo = urls + response.secureUrl+"date"+formattedDate;
        }

        var data = {
          "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
          "idea_id": model.id,
          "title": model.title,
          "cover_image": model.coverImg,
          "voice_message": memo,
          "insert_type": "Detailed Add",
          "description": model.description,
          "gallery": model.gallery,
          "notes": model.notes,
          "interest": model.interests.toString(),
          "priority": model.priority.toString(),
          "solution_type": model.solutionType
        };

        print(data.toString());

        bool result = await Helpers.checkInternet();
        if (result) {
          setState(() {
            showloader = true;
          });
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, AppStrings.INTERNET_NOT_CONNECTED);
          return;
        }

        var response2 =
            await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_IDEA,
                options: Options(headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                }),
                data: jsonEncode(data));
        setState(() {
          showloader = false;
        });

        if (response2.statusCode == 200) {
          debugPrint(
              "response getting rawzzzz data= " + response2.data.toString());
          var result = QuickIdeaModel.fromJson(response2.data);
          if (result.status == 200) {
            if (result.success == 1) {
              Future.delayed(const Duration(seconds: 1), () {
// Here you can write your code
              setState(() {

              });
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => HomeScreen(
//                               selectPage: 0,
//                             )),
//                     (Route<dynamic> route) => false);
              });

              ReusableWidgets.showInfo(
                  _scaffoldKey, context, "Your idea is updated successfully!");
            } else {
              ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
            }
          }

          // return LoginModel.fromJson(response.data);
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Something went wrong!");
        }
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }

      // showProgress=false;

    }
  }
  Future uploadTopscoreMemo(String file, Data model) async {

    if (file != null) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file,
              resourceType: CloudinaryResourceType.Raw),
        );

        debugPrint("inside memo received" + memo);

        //update the data

        if (model.voiceMsg=="") {
          memo = response.secureUrl+"date"+formattedDate;
        } else {




          memo = model.voiceMsg+"," + response.secureUrl+"date"+formattedDate;
        }

        var data = {
          "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
          "idea_id": model.id,
          "title": model.title,
          "cover_image": model.coverImg,
          "voice_message": memo,
          "insert_type": "Detailed Add",
          "description": model.description,
          "gallery": model.gallery,
          "notes": model.notes,
          "interest": model.interests.toString(),
          "priority": model.priority.toString(),
          "solution_type": model.solutionType
        };

        print(data.toString());

        bool result = await Helpers.checkInternet();
        if (result) {
          setState(() {
            showloader = true;
          });
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, AppStrings.INTERNET_NOT_CONNECTED);
          return;
        }

        var response2 =
        await Dio().post(ApiEndpoints.BASE_URL + ApiEndpoints.UPDATE_IDEA,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
        setState(() {
          showloader = false;
        });

        if (response2.statusCode == 200) {
          debugPrint(
              "response getting rawzzzz data= " + response2.data.toString());
          var result = QuickIdeaModel.fromJson(response2.data);
          if (result.status == 200) {
            if (result.success == 1) {
              Future.delayed(const Duration(seconds: 1), () {
// Here you can write your code
              setState(() {

              });
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => HomeScreen(
//                           selectPage: 0,
//                         )),
//                         (Route<dynamic> route) => false);
              });

              ReusableWidgets.showInfo(
                  _scaffoldKey, context, "Your idea is updated successfully!");
            } else {
              ReusableWidgets.showInfo(_scaffoldKey, context, result.message);
            }
          }

          // return LoginModel.fromJson(response.data);
        } else {
          ReusableWidgets.showInfo(
              _scaffoldKey, context, "Something went wrong!");
        }
      } on Exception catch (e) {
        print("from2 " + e.toString());
      }

      // showProgress=false;

    }
  }
  void UpdateTopIdeaPopup(Data model) {
    showDialog(
        context: context,
        builder: (build) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: AppColors.colorPrimary,
                ),
                padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                child: Center(
                  child: Text(
                    "Add Photo",
                    style: TextStyle(
                        fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        fontSize: ScreenUtil().setSp(36)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                child: Text(
                  "Choose Image Source",
                  style: TextStyle(
                      fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                      fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(20)),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          FocusScope.of(context)
                              .requestFocus(new FocusNode());

                          updateTopIdeaImage(ImageSource.camera,
                              model);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          FocusScope.of(context)
                              .requestFocus(new FocusNode());

                          updateTopIdeaImage(ImageSource.gallery,
                              model);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void addImage(AsyncSnapshot<HomePageModel> snapshot, int index) {
    showDialog(
        context: context,
        builder: (build) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: AppColors.colorPrimary,
                    ),
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Center(
                      child: Text(
                        "Add Photo",
                        style: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            fontSize: ScreenUtil().setSp(36)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                    child: Text(
                      "Choose Image Source",
                      style: TextStyle(
                          fontFamily: AppFonts.FONTFAMILY_ROBOTO,
                          fontSize: ScreenUtil().setSp(30)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              getImage(ImageSource.camera,
                                  snapshot.data.data[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Camera",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              getImage(ImageSource.gallery,
                                  snapshot.data.data[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Gallery",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  void deleteConfirmation(String ideaId) {
    showDialog(
        context: context,
        builder: (build) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Center(
                      child: Text(
                        "Delete idea",
                        style: TextStyle(
                            fontFamily: AppFonts.FONTFAMILY_ROBOTO_MEDIUM,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            fontSize: ScreenUtil().setSp(36)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                    child: Text(
                      "Are you sure you want to \ndelete this idea?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: AppFonts.FONTFAMILY_ROBOTO,fontSize: ScreenUtil().setSp(34)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "No",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              deleteIdea(ideaId).then((value) {
                                showIdeaDeleteDialog();
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: AppFonts.FONTFAMILY_ROBOTO),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Future<SimpleResponse> deleteIdea(String ideaId) async {
    var data = {
      "user_id": Helpers.prefrences.getString(AppStrings.USER_ID),
      "idea_id": ideaId
    };

    var response = await Dio()
        .post(ApiEndpoints.BASE_URL + ApiEndpoints.DELETE_SINGLE_IDEA,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }),
            data: jsonEncode(data));
    if (response.statusCode == 200) {
      debugPrint("!!!!" + response.toString());

      return SimpleResponse.fromJson(response.data);
    }
  }

  Widget showIdeaDeleteDialog() {
    return Dialog(
      child: Text("Idea deleted successfully!"),
    );
  }
}
