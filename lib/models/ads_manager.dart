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
  static String get profileBannerId{
    if(testMode){
      print('test mode ON');
      return AdmobBanner.testAdUnitId;
    }else{
      return 'ca-app-pub-8571844432257036/3460142676';
    }
  }
  static String get intersitialAdId{
    if(testMode){
      print('test mode ON');
      return 'ca-app-pub-3940256099942544/1033173712';
    }else{
      return 'ca-app-pub-8571844432257036/2835017218';
    }
  }

}