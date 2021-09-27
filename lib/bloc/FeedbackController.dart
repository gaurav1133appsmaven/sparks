import 'package:get/get.dart';

class FeedbackController extends GetxController
{

  var showLoading=false.obs;




  chnageLoadingStatus()
  {
    showLoading.toggle();
  }




}