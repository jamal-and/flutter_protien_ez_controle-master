//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
class MyColors{
  static bool defaultMode=true;
  static Color get background{
    if(defaultMode) {
      return Color(0xff0B203D);
    }else{
      return Color(0xffFFFFFF);
    }
  }
  static Color get darkBackGround{
    if(defaultMode) {
      return Color(0xff0E284B) ;
    }else{
      return Color(0xffECF0F1);
      //return Color(0xffdfe4e3);
    }
  }
  static Color get accentColor{
    if(defaultMode){

      return Color(0xff70E1F1);
    }else{
      return Color(0xff25c0b7);
    }
  }
  static Color get textColor{
    if(defaultMode){

      return Color(0xffffffff);
    }else{
      return Color(0xff21302f);
    }
  }
  static Color get fireColor{
    if(defaultMode){

      return Color(0xffF27096);
    }else{
      return Color(0xfff8b34b);
    }
  }
  static Color get inActiveItemColor{
    if(defaultMode){

      return Colors.white30;
    }else{
      return Colors.black26;
    }
  }

}