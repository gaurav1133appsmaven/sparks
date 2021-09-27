import 'package:get/get.dart';

class IdeaDetailController extends GetxController
{
  var showPremium=false.obs;
  var showProgress=false.obs;


  changePremiumStatus()
  {
    showPremium.toggle();
  }
  changeLoader()
  {
    showProgress.toggle();
  }



}