//import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_consent/admob_consent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/screens/add_meal_screen.dart';
import 'package:flutter_protien_ez_controle/screens/main_screen.dart';
import 'package:flutter_protien_ez_controle/screens/meals_screen.dart';
import 'package:flutter_protien_ez_controle/screens/personal_inofrmation_screen.dart';
import 'package:flutter_protien_ez_controle/screens/premium_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'models/data.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

bool isLoggedIn = false;
bool isDarkTheme = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  //Admob.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isLoggedIn = prefs.getInt('weight') != null ? true : false;
  isDarkTheme = prefs.getBool('dark');
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
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  AdmobConsent _admobConsent = AdmobConsent();
  Future<void> showAdmobConsent() async {
    if (!Provider.of<Data>(context, listen: false).isPurchased) {
      _admobConsent.show();
      _admobConsent.onConsentFormObtained.listen((o) {
        // Obtained consent
      });
    }
  }

  void ss() async {
    var s = await GdprDialog.instance.getConsentStatus();
    print('hehe $s');
  }

  void kk() async {
    await Provider.of<Data>(context, listen: false).initialize();
    print('${Provider.of<Data>(context, listen: false).isPurchased} asdd');
    if (!Provider.of<Data>(context, listen: false).isPurchased) {
      //AppOpenAdManager().loadAd();
      showAdmobConsent();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //ss();
    // GdprDialog.instance.showDialog(isForTest: true,)
    //     .then((onValue) {
    //   print('result === $onValue');
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      kk();
    }); //appOpenAdManager.showAdIfAvailable();
    // WidgetsBinding.instance
    //     .addObserver(AppLifecycleReactor(appOpenAdManager: appOpenAdManager));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Protein Tracker',

      theme: Provider.of<Data>(context).darkTheme
          ? ThemeData.dark().copyWith(
              textTheme: TextTheme(
                bodyText2: GoogleFonts.lato(),
                bodyText1: GoogleFonts.lato(),
              ),
            )
          : ThemeData.light().copyWith(
              textTheme: TextTheme(
                bodyText2: GoogleFonts.lato(),
                bodyText1: GoogleFonts.lato(),
              ),
            ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: isLoggedIn ? MainScreen.id : WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MainScreen.id: (context) => MainScreen(),
        PremiumScreen.id: (context) => PremiumScreen(),
        PersonalInformationScreen.id: (context) => PersonalInformationScreen(),
        MealsScreen.id: (context) => MealsScreen(),
        AddMealScreen.id: (context) => AddMealScreen(),
      },
    );
  }
}
