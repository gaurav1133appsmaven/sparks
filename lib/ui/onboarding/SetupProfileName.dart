import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:sparks/utils/AppColors.dart';
import 'package:sparks/utils/AppStrings.dart';
import 'package:sparks/utils/CustomDropdownButton.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import '../HomeScreen.dart';

class SetupProfileName extends StatefulWidget {
  @override
  _SetupProfileNameState createState() => _SetupProfileNameState();
}

class _SetupProfileNameState extends State<SetupProfileName> {
  double _lowerValue = 50;
  double _upperValue = 180;
  DateTime selectedDate = DateTime.now();
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<ListItem> _list = [
    ListItem(0, "Grid"),
    ListItem(1, "Picture"),
    ListItem(2, "Pin Board"),
    ListItem(3, "List")
  ];

  int _selectedList = 0;

  var occupationSelected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          setupName(_controller),
          setupPhone(_controller),
          setupLocation(_controller),
          setupDob(_controller),
          setupGender(_controller),
          setupOccupation(_controller),
          setPostingEstimate(_controller),
        ],
      )),
    );
  }

  setPostingEstimate(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Last one!",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: ScreenUtil().setSp(40.0)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      Text("Time frame you have the most free time?"),
                      Container(
                        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [Text("0"), Spacer(), Text("24")],
                            ),
                            FlutterSlider(
                              values: [4],
                              max: 10,
                              min: 1,
                              handler: FlutterSliderHandler(
                                decoration: BoxDecoration(),
                                child: ImageIcon(AssetImage(
                                    "assets/images/ic_slidermarker.png")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      Text("How many ideas you generate a month?"),
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text("0"),
                            ],
                          ),
                          Column(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text("1-3"),
                            ],
                          ),
                          Column(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text("4-7"),
                            ],
                          ),
                          Column(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text("8-14"),
                            ],
                          ),
                          Column(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text("15+"),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _controller.previousPage(
                                duration: new Duration(seconds: 1),
                                curve: Curves.easeIn);
                            // _controller.nextPage(duration:  new Duration(seconds: 1),
                            //     curve: Curves.easeIn);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(44.0)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.black,
                        height: 20,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contxt) => HomeScreen(selectPage: 0,)));
                            // _controller.nextPage(duration:  new Duration(seconds: 1),
                            //     curve: Curves.easeIn);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Finished",
                              style: TextStyle(
                                  color: AppColors.NextButton_color,
                                  fontWeight: FontWeight.w900,
                                  fontSize: ScreenUtil().setSp(44.0)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  setupOccupation(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(40),
                      ),
                      child: Text(
                        "Setup your profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: ScreenUtil().setSp(40.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text("Status"),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                occupationSelected = !occupationSelected;
                              });
                            },
                            child: Container(
                                color: occupationSelected ? null : Colors.white,
                                child: Text("Aspiring Enterpreneur",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(26)),
                                    textAlign: TextAlign.center)),
                          )),
                          Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      occupationSelected = !occupationSelected;
                                    });
                                  },
                                  child: Container(
                                      color: occupationSelected
                                          ? Colors.white
                                          : null,
                                      child: Text(
                                        "Entrepreneur",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(26)),
                                        textAlign: TextAlign.center,
                                      ))))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(4)),
                      child: Text("Occupation"),
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(4)),
                      child: Text("Interests"),
                    ),
                    TextField(
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                      height: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.nextPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.NextButton_color,
                                fontWeight: FontWeight.w900,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setupGender(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Setup your profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: ScreenUtil().setSp(40.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(14)),
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(34),
                            height: ScreenUtil().setHeight(34),
                            child: Image.asset(
                              "assets/images/ic_male.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text("Male"),
                          Spacer(),
                          Image(
                              image: AssetImage("assets/images/ic_checked.png"))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(14)),
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(34),
                            height: ScreenUtil().setHeight(34),
                            child: Image.asset(
                              "assets/images/ic_female.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text("Female"),
                          Spacer(),
                          Image(
                              image:
                                  AssetImage("assets/images/ic_unchecked.png"))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(14)),
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(34),
                            height: ScreenUtil().setHeight(34),
                            child: Image.asset(
                              "assets/images/ic_other.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text("Other"),
                          Spacer(),
                          Image(
                              image:
                                  AssetImage("assets/images/ic_unchecked.png"))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                      height: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.nextPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.NextButton_color,
                                fontWeight: FontWeight.w900,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setupDob(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Setup your profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: ScreenUtil().setSp(40.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Text("Birthdate"),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                height: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .height /
                                    3,
                                color: Colors.white,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (picked) {
                                    if (picked != null &&
                                        picked != selectedDate) {
                                      // debugPrint("debugprint" +
                                      //     picked.toString());
                                      // _dobController.text=Utils.getFormattedDob(
                                      //     picked.toString());
                                      // _profileBloc
                                      //     .setDob(Utils.getFormattedDob(
                                      //     picked.toString()));
                                    }
                                    // setState(() {
                                    //   selectedDate = picked;
                                    // });
                                  },
                                  initialDateTime: selectedDate,
                                  minimumYear: 1931,
                                  maximumYear: 2021,
                                ),
                              );
                            });
                      },
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "mm/dd/yyyy"),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Text("Ethnicity"),
                    Container(
                      color: Colors.white,
                      child: DropdownButtonHideUnderline(
                        child: CustomDropdownButton(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _list[_selectedList].name,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: ScreenUtil().setSp(30)),
                            ),
                          ),
                          items: _list
                              .map((e) => DropdownMenuItem(
                                  value: e.value, child: Text(e.name)))
                              .toList(),
                          onChanged: (value) {
                            debugPrint(value.toString());

                            setState(() {
                              _selectedList = value;
                            });
                          },
                        ),
                      ),
                      height: ScreenUtil().setHeight(80),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                      height: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.nextPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.NextButton_color,
                                fontWeight: FontWeight.w900,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setupLocation(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                      child: Text(
                        "Setup your profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: ScreenUtil().setSp(40.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(60),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(4)),
                      child: Text("Country"),
                    ),
                    Container(
                      child: Container(


                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(ScreenUtil().setHeight(10))
                        ),
                        child: DropdownButtonHideUnderline(
                          child: CustomDropdownButton(
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                _list[_selectedList].name,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: ScreenUtil().setSp(30)),
                              ),
                            ),
                            items: _list
                                .map((e) => DropdownMenuItem(
                                    value: e.value, child: Text(e.name)))
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
                      height: ScreenUtil().setHeight(60),
                      color: AppColors.onBoardingColor,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(4)),
                      child: Text("State"),
                    ),
                    Container(
                      color: Colors.white,
                      child: DropdownButtonHideUnderline(
                        child: CustomDropdownButton(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _list[_selectedList].name,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: ScreenUtil().setSp(30)),
                            ),
                          ),
                          items: _list
                              .map((e) => DropdownMenuItem(
                                  value: e.value, child: Text(e.name)))
                              .toList(),
                          onChanged: (value) {
                            debugPrint(value.toString());

                            setState(() {
                              _selectedList = value;
                            });
                          },
                        ),
                      ),
                      height: ScreenUtil().setHeight(60),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(4)),
                      child: Text("City"),
                    ),
                    Container(
                      color: Colors.white,
                      child: DropdownButtonHideUnderline(
                        child: CustomDropdownButton(
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              _list[_selectedList].name,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: ScreenUtil().setSp(30)),
                            ),
                          ),
                          items: _list
                              .map((e) => DropdownMenuItem(
                                  value: e.value, child: Text(e.name)))
                              .toList(),
                          onChanged: (value) {
                            debugPrint(value.toString());

                            setState(() {
                              _selectedList = value;
                            });
                          },
                        ),
                      ),
                      height: ScreenUtil().setHeight(60),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                      height: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.nextPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.NextButton_color,
                                fontWeight: FontWeight.w900,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setupName(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
                child: Text(
                  "Setup your profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: ScreenUtil().setSp(40.0)),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(50),
                    vertical: ScreenUtil().setHeight(4)),
                child: Text("First Name"),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: AppStrings.FIRST_NAME_HINT),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(50),
                    vertical: ScreenUtil().setHeight(4)),
                child: Text("Last Name"),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: AppStrings.LAST_NAME_HINT),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  _controller.nextPage(
                      duration: new Duration(seconds: 1), curve: Curves.easeIn);
                  // _controller.nextPage(duration:  new Duration(seconds: 1),
                  //     curve: Curves.easeIn);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: AppColors.NextButton_color,
                        fontWeight: FontWeight.w900,
                        fontSize: ScreenUtil().setSp(44.0)),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  setupPhone(PageController _controller) {
    return
      Container(
      padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.onBoardingColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(40),
                ),
                child: Text(
                  "Setup your profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: ScreenUtil().setSp(40.0)),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(50),
                    vertical: ScreenUtil().setHeight(4)),
                child: Text("Phone Number"),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "###-###-####"),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.previousPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Back",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      color: Colors.black,
                      height: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _controller.nextPage(
                              duration: new Duration(seconds: 1),
                              curve: Curves.easeIn);
                          // _controller.nextPage(duration:  new Duration(seconds: 1),
                          //     curve: Curves.easeIn);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.NextButton_color,
                                fontWeight: FontWeight.w900,
                                fontSize: ScreenUtil().setSp(44.0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
