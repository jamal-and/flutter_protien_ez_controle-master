import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/screens/main_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'models/data.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedIn=false;
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn= prefs.getInt('weight')!=null?true:false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return ChangeNotifierProvider(
      create: (BuildContext context) => Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Protein Tracker',
        theme: ThemeData.dark().copyWith(textTheme: TextTheme(bodyText2: GoogleFonts.lato(),bodyText1: GoogleFonts.lato(),)),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute:isLoggedIn?MainScreen.id: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id:(context)=>WelcomeScreen(),
          MainScreen.id:(context)=>MainScreen(),
        },
      ),
    );
  }
}

