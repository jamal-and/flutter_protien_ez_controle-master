import 'package:admob_flutter/admob_flutter.dart';

class AdsManager{
  static bool testMode=false;
  static String get appId{
      return 'ca-app-pub-8571844432257036~3219853575';
  }
  static String get bannerId{
      if(testMode){
        print('test mode ON');
        return AdmobBanner.testAdUnitId;
      }else{
        return 'ca-app-pub-8571844432257036/4218128521';
      }
  }

}