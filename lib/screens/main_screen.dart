import 'dart:io';
import 'dart:math';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_protien_ez_controle/screens/add_protein_date.dart';
import 'package:flutter_protien_ez_controle/screens/premium_screen.dart';
import 'package:flutter_protien_ez_controle/screens/setting_screen.dart';
import 'package:flutter_protien_ez_controle/screens/update_meal_dialog.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/ads_manager.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_protien_ez_controle/models/data_for_sql.dart';
import 'package:flutter_protien_ez_controle/screens/set_name_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'add_protein_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_weight_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'set_goal_dialog.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:new_version/new_version.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NativeAd myNative;
  NativeAd myNative2;
  NativeAd myNative3;
  int maxFailedLoadAttempts = 9000;
  RewardedAd myRewarded;
  int currentIndex = 0;
  String preference = 'kg!';
  SharedPreferences prefs;
  InterstitialAd myInterstitialAd;
  BannerAd myBanner;
  int _numRewardedLoadAttempts = 0;
  BannerAd myProfileBanner;
  bool isBannerReady = false;
  bool isProfileBannerReady = false;
  bool isIntLoaded = false;
  bool isNativeReady = false;
  bool isNativeReady2 = false;
  bool isNativeReady3 = false;
  final newVersion = NewVersion(
    androidId: 'com.jamal.protein',
  );

  //AdmobInterstitial interstitialAd;

  // Future<void> getPrefs(context)async {
  //   prefs = await SharedPreferences.getInstance();
  //   if(prefs.getBool('kg')==true){
  //     Provider.of<Data>(context,listen: false).setKg('kg');
  //   }else{
  //     Provider.of<Data>(context,listen: false).setKg('Ibs');
  //   }
  // }
  void loadAd() {
    InterstitialAd.load(
        adUnitId: AdsManager.intersitialAdId,
        request: AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          setState(() {
            myInterstitialAd = ad;
            isIntLoaded = true;
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          print('ad Loading Error $error');
          setState(() {
            isIntLoaded = false;
          });
        }));
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-8571844432257036/2586187895',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            myRewarded = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            myRewarded = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd(
      {Protein protein, String text, String hour, String date, int number}) {
    if (myRewarded == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    myRewarded.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    myRewarded.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      if (protein != null) {
        showDialog(
            context: context,
            builder: (c) {
              return AddProteinDateDialog(protein.date);
            });
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return UpdateMealDialog(
                hour: hour,
                text: text,
                date: date,
                number: number,
              );
            });
      }
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    myRewarded = null;
  }

  void showInterstitialAd() {
    if (myInterstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    myInterstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadAd();
      },
    );
    if (Provider.of<Data>(context, listen: false).isPurchased == false) {
      myInterstitialAd.show();
    }
    myInterstitialAd = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<Data>(context, listen: false).initialize();
    super.initState();
    _createRewardedAd();
    loadAd();

    // InterstitialAd.load(
    //     adUnitId: AdsManager.intersitialAdId,
    //     request: AdRequest(),
    //     adLoadCallback:
    //         InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
    //       setState(() {
    //         myInterstitialAd = ad;
    //       });
    //     }, onAdFailedToLoad: (LoadAdError error) {
    //       print('ad Loading Error $error');
    //     }));

    myBanner = BannerAd(
      adUnitId: AdsManager.bannerId,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (x) {
          print('banner Loaded $x');
          setState(() {
            isBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerReady = false;
          ad.dispose();
        },
      ),
    );

    myProfileBanner = BannerAd(
      adUnitId: AdsManager.profileBannerId,
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (x) {
          print('banner Loaded $x');
          setState(() {
            isProfileBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isProfileBannerReady = false;
          ad.dispose();
        },
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadAds();
    });

    //advancedStatusCheck(newVersion);
    newVersion.showAlertIfNecessary(context: context);
  }

  loadAds() async {
    prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('dark') ?? true;
    myNative = NativeAd(
      adUnitId: 'ca-app-pub-8571844432257036/9146930659',
      factoryId: isDark ? 'adFactoryExample' : 'adFactoryExample4',
      request: AdRequest(),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          setState(() {
            isNativeReady = true;
          });
          print('Ad loaded!!.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.

          ad.dispose();
          print('Native Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened!!.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed!!.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
        onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
      ),
    );
    myNative3 = NativeAd(
      adUnitId: 'ca-app-pub-8571844432257036/7656828978',
      factoryId: isDark ? 'adFactoryExample2' : 'adFactoryExample3',
      request: AdRequest(),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          setState(() {
            isNativeReady3 = true;
          });
          print('Ad loaded!!.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Native Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened!!.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed!!.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
        onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
      ),
    );
    myNative2 = NativeAd(
      adUnitId: 'ca-app-pub-8571844432257036/5144068475',
      factoryId: isDark ? 'adFactoryExample2' : 'adFactoryExample3',
      request: AdRequest(),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          setState(() {
            isNativeReady2 = true;
          });
          print('Ad loaded!!. 22');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Native Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened!!.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed!!.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
        onNativeAdClicked: (NativeAd ad) => print('Ad clicked.'),
      ),
    );
    if (Provider.of<Data>(context, listen: false).isPurchased == false) {
      myNative3.load();
      myProfileBanner.load();
      myNative2.load();
      myNative.load();
      myBanner.load();

    }

  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'Custom Title',
      dialogText: 'Custom Text',
    );
  }

  @override
  void dispose() {
    //interstitialAd.dispose();
    Provider.of<Data>(context, listen: false).subscription.cancel();
    myNative.dispose();
    myNative3.dispose();
    myNative2.dispose();
    myRewarded.dispose();
    myInterstitialAd.dispose();
    myBanner.dispose();
    myProfileBanner.dispose();
    super.dispose();
  }

  PageController pageController = PageController(
    initialPage: 0,
  );
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  int pos;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var myProvider = Provider.of<Data>(context);
    preference = myProvider.kg;
    var random = Random();
    pos == null ? pos = random.nextInt(3) : pos = pos;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: MyColors.background,
          selectedIndex: currentIndex,
          showElevation: true,
          // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(myProvider.isPurchased
                    ? Icons.star_rate_outlined
                    : Icons.home_outlined),
                title: Text('Home'),
                activeColor: MyColors.accentColor,
                inactiveColor: MyColors.inActiveItemColor),
            BottomNavyBarItem(
                icon: Icon(Icons.analytics_outlined),
                title: Text('Statistic'),
                activeColor: MyColors.accentColor,
                inactiveColor: MyColors.inActiveItemColor),
            BottomNavyBarItem(
                icon: Icon(Icons.person_outline),
                title: Text('Profile'),
                activeColor: MyColors.accentColor,
                inactiveColor: MyColors.inActiveItemColor),
            BottomNavyBarItem(
                icon: Icon(Icons.settings_outlined),
                title: Text('Settings'),
                activeColor: MyColors.accentColor,
                inactiveColor: MyColors.inActiveItemColor),
          ],
        ),
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                currentIndex == 1
                    ? 'Last 7 days'
                    : currentIndex == 2
                        ? 'Profile'
                        : currentIndex == 3
                            ? 'Settings'
                            : myProvider.isPurchased
                                ? 'PREMIUM'
                                : 'Protein Tracker',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: MyColors.textColor)),
              ),
              Spacer(),
              if(!myProvider.isPurchased)TextButton(
                  onPressed: () {Navigator.pushNamed(context, PremiumScreen.id);},
                  child: Text(
                    myProvider.hasFreeTrial?'Free Premium':'Go Premium',
                    style: TextStyle(color: MyColors.accentColor,fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: MyColors.background,
        body: PageView(

          onPageChanged: (page) {
            setState(() {
              currentIndex = page;
            });
          },
          controller: pageController,
          children: [
            Dashboard(
              nativeAd: myNative,
              isNativeReady: isNativeReady,
              myProvider: myProvider,
              height: height,
              width: width,
              pageController: pageController,
              isBannerReady: isBannerReady,
              myBanner: myBanner,
              show: showInterstitialAd,
              rewardedAd: _showRewardedAd,
            ),
            StatisticsScreen(
              myProvider: myProvider,
              isBannerReady: isProfileBannerReady,
              myBanner: myProfileBanner,
              nativeAd: myNative2,
              isNativeReady: isNativeReady2,
              width: width,
              pos: pos,
              showRewardedAd: _showRewardedAd,
            ),
            ProfileScreen(
              myProvider: myProvider,
              nativeAd: myNative3,
              isNativeReady: isNativeReady3,
              myInterstitialAd: myInterstitialAd,
              isProfileBannerReady: isProfileBannerReady,
              myProfileBanner: myProfileBanner,
              show: showInterstitialAd,
              preference: preference,
            ),
            SettingScreen(
              reLoadAds: loadAds,
            )
          ],
        )
        //currentIndex ==0? Dashboard(myProvider: myProvider, height: height, width: width):Container(),
        );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard(
      {Key key,
      @required this.myProvider,
      @required this.height,
      @required this.width,
      @required this.isBannerReady,
      @required this.myBanner,
      @required this.isNativeReady,
      @required this.nativeAd,
      @required this.pageController,
      @required this.show,
      this.rewardedAd})
      : super(key: key);

  final Data myProvider;
  final double height;
  final double width;
  final bool isBannerReady;
  final BannerAd myBanner;
  final bool isNativeReady;
  final NativeAd nativeAd;
  final Function show;
  final PageController pageController;
  final Function rewardedAd;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<SingleProtein> items;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AddProteinDialog(
                    showInter: widget.show,
                  ));
        },
        backgroundColor: MyColors.accentColor.withOpacity(0.85),
        child: Icon(
          Icons.add,
          color: MyColors.textColor,
          size: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: FutureBuilder(
                future: widget.myProvider.getWeight(),
                builder: (context, snapshot) => Column(
                  children: [
                    Column(
                      children: [
                        if(widget.isBannerReady&&!widget.myProvider.isPurchased)Container(height: widget.myBanner.size.height.toDouble(),width:widget.width,child: AdWidget(ad: widget.myBanner,),),
                        SizedBox(
                          height: 16,
                        ),
                        CircularPercentIndicator(
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor:
                              MyColors.accentColor.withOpacity(0.1),
                          progressColor: MyColors.accentColor,
                          radius: widget.height * 0.28,
                          lineWidth: widget.height * 0.015,
                          animation: true,
                          percent: (widget.myProvider.nowProtein.protein /
                                      widget.myProvider.proteinDaily) <=
                                  1
                              ? (widget.myProvider.nowProtein.protein /
                                  widget.myProvider.proteinDaily)
                              : 1,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.myProvider.nowProtein.protein}g',
                                style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.textColor),
                              ),
                              Container(
                                  width: 60,
                                  child: Divider(
                                    thickness: 1,
                                    color: MyColors.accentColor,
                                  )),
                              Text(
                                "of ${widget.myProvider.proteinDaily}g",
                                style: new TextStyle(
                                    fontSize: 18.0, color: MyColors.textColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.adjust_outlined,
                              color: MyColors.accentColor,
                            ),
                            Text(
                              '${widget.myProvider.proteinDaily}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: MyColors.textColor),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.local_fire_department_outlined,
                              color: MyColors.fireColor,
                            ),
                            Text('${widget.myProvider.proteinDaily * 4}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: MyColors.textColor)),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Expanded(
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      '${widget.myProvider.nowProtein.protein}g',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.accentColor),
                                    ),
                                    Text(
                                      'Consumed',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: MyColors.textColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 32,
                            ),
                            Expanded(
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      '${widget.myProvider.kalanDaily > 0 ? widget.myProvider.kalanDaily : 0}g',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.accentColor),
                                    ),
                                    Text(
                                      'Remaining',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: MyColors.textColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 32,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${widget.myProvider.nowProtein.protein * 4}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.accentColor),
                                  ),
                                  Text(
                                    'Cal',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.textColor),
                                  ),
                                ],
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    //Container(height: height * 0.25, child: ProteinGraph(height)),
                    //!!! Native ad here !!!
                    SizedBox(
                      height: widget.height * 0.02,
                    ),


                    GestureDetector(
                      onTap: () {
                        widget.pageController.animateToPage(1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: Container(
                        width: widget.width * 0.9,
                        decoration: BoxDecoration(
                            color: MyColors.darkBackGround,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black.withOpacity(0.0),
                                  spreadRadius: 2,
                                  blurRadius: 5)
                            ]),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Last 7 days',
                                  style: TextStyle(
                                      color: MyColors.textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Your daily goals',
                                style: TextStyle(
                                  color: MyColors.textColor.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            FutureBuilder(
                              future: widget.myProvider.get7DaysState(),
                              builder: (context, s) {
                                int howManyGoals = 0;
                                if (widget.myProvider.protein6.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                if (widget.myProvider.protein5.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                if (widget.myProvider.protein4.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                if (widget.myProvider.protein3.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                if (widget.myProvider.protein2.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                if (widget.myProvider.protein1.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                if (widget.myProvider.nowProtein.protein >=
                                    widget.myProvider.proteinDaily) {
                                  howManyGoals++;
                                }
                                return Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$howManyGoals/7',
                                          style: TextStyle(
                                              color: MyColors.accentColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Achieved',
                                          style: TextStyle(
                                            color: MyColors.accentColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    OneDayCircle(
                                      proteinDaily:
                                          widget.myProvider.proteinDaily,
                                      proteinValue:
                                          widget.myProvider.protein6.protein,
                                      day: DateTime.now()
                                          .subtract(Duration(days: 6))
                                          .weekday,
                                    ),
                                    OneDayCircle(
                                      proteinDaily:
                                          widget.myProvider.proteinDaily,
                                      proteinValue:
                                          widget.myProvider.protein5.protein,
                                      day: DateTime.now()
                                          .subtract(Duration(days: 5))
                                          .weekday,
                                    ),
                                    OneDayCircle(
                                        proteinDaily:
                                            widget.myProvider.proteinDaily,
                                        proteinValue:
                                            widget.myProvider.protein4.protein,
                                        day: DateTime.now()
                                            .subtract(Duration(days: 4))
                                            .weekday),
                                    OneDayCircle(
                                        proteinDaily:
                                            widget.myProvider.proteinDaily,
                                        proteinValue:
                                            widget.myProvider.protein3.protein,
                                        day: DateTime.now()
                                            .subtract(Duration(days: 3))
                                            .weekday),
                                    OneDayCircle(
                                        proteinDaily:
                                            widget.myProvider.proteinDaily,
                                        proteinValue:
                                            widget.myProvider.protein2.protein,
                                        day: DateTime.now()
                                            .subtract(Duration(days: 2))
                                            .weekday),
                                    OneDayCircle(
                                        proteinDaily:
                                            widget.myProvider.proteinDaily,
                                        proteinValue:
                                            widget.myProvider.protein1.protein,
                                        day: DateTime.now()
                                            .subtract(Duration(days: 1))
                                            .weekday),
                                    OneDayCircle(
                                      proteinDaily:
                                          widget.myProvider.proteinDaily,
                                      proteinValue:
                                          widget.myProvider.nowProtein.protein,
                                      day: DateTime.now().weekday,
                                      color: MyColors.textColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //ProteinCardsList(widget: widget,),
                    SizedBox(
                      height: 16,
                    ),
                    if (widget.myProvider.isPurchased == false)
                      widget.isNativeReady
                          ? Container(
                          alignment: Alignment.center,
                          height:
                          widget.myBanner.size.height.toDouble() + 20,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              color: MyColors.darkBackGround,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black.withOpacity(0.0),
                                    spreadRadius: 2,
                                    blurRadius: 5)
                              ]),
                          width: widget.width * 0.9,
                          child: AdWidget(
                            ad: widget.nativeAd,
                          ))
                          : SizedBox(),


                    //Spacer(),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: widget.width * 0.9,
                      decoration: BoxDecoration(
                          color: MyColors.darkBackGround,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withOpacity(0.0),
                                spreadRadius: 2,
                                blurRadius: 5)
                          ]),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.brunch_dining,
                                  color: MyColors.textColor,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Last Meals',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.textColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: FutureBuilder(
                                future: widget.myProvider.getSingleProteins(),
                                builder: (context, snapshot) {
                                  var random = Random();
                                  List<Color> colors = [
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.cyan,
                                    Colors.orange,
                                    Colors.purple
                                  ];
                                  items =
                                      widget.myProvider.items.reversed.toList();

                                  if (items.length == 0) {
                                    return Center(
                                      child: Text(
                                        'Add meal to show here',
                                        style: TextStyle(
                                            color: MyColors.textColor),
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                      itemCount: items.length,
                                      itemBuilder: (s, index) {
                                        return Dismissible(
                                          onDismissed: (s) async {
                                            if (s ==
                                                DismissDirection.endToStart) {
                                              await Provider.of<Data>(context,
                                                      listen: false)
                                                  .deleteDismiss(
                                                      items[index].text,
                                                      items[index].number,
                                                      items[index].hour);
                                              setState(() {
                                                items.removeAt(index);
                                              });
                                            } else {
                                              await Provider.of<Data>(context,
                                                      listen: false)
                                                  .addProtein(
                                                      items[index].number,
                                                      items[index].text);
                                            }
                                          },
                                          background: Container(
                                            color: Colors.cyan,
                                            padding: EdgeInsets.only(left: 24),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                    Icons
                                                        .control_point_duplicate,
                                                    size: 32)),
                                          ),
                                          secondaryBackground: Container(
                                            color: Colors.pink,
                                            padding: EdgeInsets.only(right: 24),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 32,
                                                )),
                                          ),
                                          key: UniqueKey(),
                                          child: ListTile(
                                            onTap: () {
                                              if (widget
                                                  .myProvider.isPurchased) {
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return UpdateMealDialog(
                                                        text: items[index].text,
                                                        number:
                                                            items[index].number,
                                                        date: items[index].date,
                                                        hour: items[index].hour,
                                                      );
                                                    });
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoAlertDialog(
                                                      title: Text(
                                                          'Premium Feature',
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      content: Text(
                                                          'Watch an ad to edit the meal for free or go premium'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'go premium'
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.pink,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pushNamed(
                                                                    context,
                                                                    PremiumScreen
                                                                        .id)
                                                                .then((value) =>
                                                                    setState(
                                                                        () {}));
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child: Text(
                                                            'watch ad'
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .accentColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            widget.rewardedAd(
                                                              text: items[index]
                                                                  .text,
                                                              number:
                                                                  items[index]
                                                                      .number,
                                                              date: items[index]
                                                                  .date,
                                                              hour: items[index]
                                                                  .hour,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            leading: CircleAvatar(
                                              backgroundColor: colors[random
                                                  .nextInt(colors.length)],
                                              child: Text(
                                                '${items[index].number}g',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            title: Text(
                                              items[index].text == '-'
                                                  ? 'No food name'
                                                  : '${items[index].text}',
                                              style: TextStyle(
                                                  color: MyColors.textColor),
                                            ),
                                            subtitle: Text(
                                              items[index].hour != null
                                                  ? 'Today at: ${items[index].hour.substring(0, 5)}'
                                                  : '',
                                              style: TextStyle(
                                                  color: MyColors.textColor
                                                      .withOpacity(0.8)),
                                            ),
                                            trailing: GestureDetector(
                                                onTap: () {
                                                  widget.myProvider
                                                      .deleteDismiss(
                                                          items[index].text,
                                                          items[index].number,
                                                          items[index].hour);
                                                },
                                                child: Icon(Icons.remove,
                                                    color: MyColors.textColor)),
                                          ),
                                        );
                                      });
                                }),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Container(
                          padding: EdgeInsets.only(top: 8),
                          height: widget.height * 0.135,
                          width: widget.width * 0.6,
                          child: FutureBuilder(
                            future: widget.myProvider.getSingleProteins(),
                            builder: (s, a) {
                              items = widget.myProvider.items.reversed.toList();
                              if (items.length == 0) {
                                return ListView(
                                  children: [
                                    ProteinCard(
                                      width: widget.width,
                                      height: widget.height,
                                      text: 'Your meals will show here',
                                      number: 0,
                                    )
                                  ],
                                );
                              }
                              return ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (s, index) {
                                    return ProteinCard(
                                      width: widget.width,
                                      height: widget.height,
                                      number: items[index].number,
                                      text: items[index].text,
                                      hour: items[index].hour,
                                    );
                                  });
                            },
                          )),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 30,
                    )
                    //Last7Days(width: width, myProvider: myProvider, height: height)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen(
      {Key key,
      @required this.myProvider,
      @required this.width,
      @required this.nativeAd,
      @required this.isNativeReady,
      this.showRewardedAd,
        this.myBanner,
        this.isBannerReady,
      this.pos})
      : super(key: key);

  final Data myProvider;
  final isNativeReady;
  final nativeAd;
  final double width;
  final int pos;
  final BannerAd myBanner;
  final bool isBannerReady;

  final Function showRewardedAd;

  @override
  Widget build(BuildContext context) {
    print(pos);
    return Container(
        color: MyColors.background,
        child: ListView(
          children: [
            if(isBannerReady&&!myProvider.isPurchased)Container(height:myBanner.size.height.toDouble(),width:width,child: AdWidget(ad: myBanner)),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your daily goals',
                      style: TextStyle(
                        color: MyColors.textColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: myProvider.get7DaysState(),
                    builder: (context, s) {
                      int howManyGoals = 0;
                      if (myProvider.protein6.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      if (myProvider.protein5.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      if (myProvider.protein4.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      if (myProvider.protein3.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      if (myProvider.protein2.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      if (myProvider.protein1.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      if (myProvider.nowProtein.protein >=
                          myProvider.proteinDaily) {
                        howManyGoals++;
                      }
                      return Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$howManyGoals/7',
                                style: TextStyle(
                                    color: MyColors.accentColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Achieved',
                                style: TextStyle(
                                  color: MyColors.accentColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          OneDayCircle(
                            proteinDaily: myProvider.proteinDaily,
                            proteinValue: myProvider.protein6.protein,
                            day: DateTime.now()
                                .subtract(Duration(days: 6))
                                .weekday,
                          ),
                          OneDayCircle(
                            proteinDaily: myProvider.proteinDaily,
                            proteinValue: myProvider.protein5.protein,
                            day: DateTime.now()
                                .subtract(Duration(days: 5))
                                .weekday,
                          ),
                          OneDayCircle(
                              proteinDaily: myProvider.proteinDaily,
                              proteinValue: myProvider.protein4.protein,
                              day: DateTime.now()
                                  .subtract(Duration(days: 4))
                                  .weekday),
                          OneDayCircle(
                              proteinDaily: myProvider.proteinDaily,
                              proteinValue: myProvider.protein3.protein,
                              day: DateTime.now()
                                  .subtract(Duration(days: 3))
                                  .weekday),
                          OneDayCircle(
                              proteinDaily: myProvider.proteinDaily,
                              proteinValue: myProvider.protein2.protein,
                              day: DateTime.now()
                                  .subtract(Duration(days: 2))
                                  .weekday),
                          OneDayCircle(
                              proteinDaily: myProvider.proteinDaily,
                              proteinValue: myProvider.protein1.protein,
                              day: DateTime.now()
                                  .subtract(Duration(days: 1))
                                  .weekday),
                          OneDayCircle(
                            proteinDaily: myProvider.proteinDaily,
                            proteinValue: myProvider.nowProtein.protein,
                            day: DateTime.now().weekday,
                            color: MyColors.textColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.end,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 28,
            ),
            FutureBuilder(
              future: myProvider.get7DaysState(),
              builder: (s, a) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      OneDayListItem(
                        protein: myProvider.protein1,
                        dailyProtein: myProvider.proteinDaily,
                        rewardedAd: showRewardedAd,
                      ),
                      if (myProvider.isPurchased == false)
                        isNativeReady && pos == 0
                            ? Container(
                                alignment: Alignment.center,
                                height: 84,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.darkBackGround,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black.withOpacity(0.0),
                                          spreadRadius: 2,
                                          blurRadius: 5)
                                    ]),
                                width: width,
                                child: isNativeReady
                                    ? AdWidget(
                                        ad: nativeAd,
                                      )
                                    : SizedBox(
                                        height: 20,
                                      ),
                              )
                            : Container(),
                      OneDayListItem(
                        protein: myProvider.protein2,
                        dailyProtein: myProvider.proteinDaily,
                        rewardedAd: showRewardedAd,
                      ),
                      if (myProvider.isPurchased == false)
                        isNativeReady && pos == 1
                            ? Container(
                                alignment: Alignment.center,
                                height: 84,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.darkBackGround,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black.withOpacity(0.0),
                                          spreadRadius: 2,
                                          blurRadius: 5)
                                    ]),
                                width: width,
                                child: isNativeReady
                                    ? AdWidget(
                                        ad: nativeAd,
                                      )
                                    : SizedBox(
                                        height: 20,
                                      ),
                              )
                            : Container(),
                      OneDayListItem(
                        protein: myProvider.protein3,
                        dailyProtein: myProvider.proteinDaily,
                        rewardedAd: showRewardedAd,
                      ),
                      if (myProvider.isPurchased == false)
                        isNativeReady && pos == 2
                            ? Container(
                                alignment: Alignment.center,
                                height: 84,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.darkBackGround,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black.withOpacity(0.0),
                                          spreadRadius: 2,
                                          blurRadius: 5)
                                    ]),
                                width: width,
                                child: isNativeReady
                                    ? AdWidget(
                                        ad: nativeAd,
                                      )
                                    : SizedBox(
                                        height: 20,
                                      ),
                              )
                            : Container(),
                      OneDayListItem(
                        protein: myProvider.protein4,
                        dailyProtein: myProvider.proteinDaily,
                        rewardedAd: showRewardedAd,
                      ),
                      if (myProvider.isPurchased == false)
                        isNativeReady && pos == 3
                            ? Container(
                                alignment: Alignment.center,
                                height: 84,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.darkBackGround,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black.withOpacity(0.0),
                                          spreadRadius: 2,
                                          blurRadius: 5)
                                    ]),
                                width: width,
                                child: isNativeReady
                                    ? AdWidget(
                                        ad: nativeAd,
                                      )
                                    : SizedBox(
                                        height: 20,
                                      ),
                              )
                            : Container(),
                      OneDayListItem(
                        protein: myProvider.protein5,
                        dailyProtein: myProvider.proteinDaily,
                        rewardedAd: showRewardedAd,
                      ),
                      OneDayListItem(
                        protein: myProvider.protein6,
                        dailyProtein: myProvider.proteinDaily,
                        rewardedAd: showRewardedAd,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}

class OneDayListItem extends StatefulWidget {
  const OneDayListItem({
    Key key,
    this.protein,
    this.dailyProtein,
    this.rewardedAd,
  }) : super(key: key);
  final Protein protein;
  final int dailyProtein;
  final Function rewardedAd;

  @override
  _OneDayListItemState createState() => _OneDayListItemState();
}

class _OneDayListItemState extends State<OneDayListItem> {
  List getTheDay() {
    String stringDay;
    Color color;
    bool isFull = false;
    if (widget.protein.protein >= widget.dailyProtein) {
      isFull = true;
    }
    int x = DateTime.parse(widget.protein.date).weekday;
    switch (x) {
      case 1:
        {
          stringDay = 'Mn';
          color = Color(0xff3F27095);
          break;
        }
      case 2:
        {
          stringDay = 'Tu';
          color = Colors.blue;
          break;
        }
      case 3:
        {
          stringDay = 'We';
          color = Colors.pink;
          break;
        }
      case 4:
        {
          stringDay = 'Th';
          color = Colors.teal;
          break;
        }
      case 5:
        {
          stringDay = 'Fr';
          color = Colors.deepOrangeAccent;
          break;
        }
      case 6:
        {
          stringDay = 'St';
          color = Colors.deepPurple;
          break;
        }
      case 7:
        {
          stringDay = 'Sn';
          color = Colors.cyan;
          break;
        }
      default:
        stringDay = '';
        color = Colors.black;
    }
    return [stringDay, color, isFull];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: MyColors.darkBackGround,
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                getTheDay()[0],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: getTheDay()[1],
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '${widget.protein.protein} of ${widget.dailyProtein}',
                style: TextStyle(color: MyColors.textColor),
              ),
            ),
            subtitle: LinearPercentIndicator(
              animationDuration: 500,
              animation: true,
              lineHeight: 8.0,
              percent: getTheDay()[2] == true
                  ? 1
                  : widget.protein.protein / widget.dailyProtein,
              progressColor: MyColors.accentColor,
              backgroundColor: MyColors.accentColor.withOpacity(0.2),
            ),
            trailing: GestureDetector(
                onTap: () {
                  if (Provider.of<Data>(context, listen: false).isPurchased) {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return AddProteinDateDialog(widget.protein.date);
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('Premium Feature',
                              style: TextStyle(
                                  color: MyColors.accentColor,
                                  fontWeight: FontWeight.bold)),
                          content: Text(
                              'Watch an ad to add protein for free or go premium'),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Go premium'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, PremiumScreen.id)
                                    .then((value) => setState(() {}));
                                ;
                              },
                            ),
                            TextButton(
                              child: Text(
                                'watch ad'.toUpperCase(),
                                style: TextStyle(
                                    color: MyColors.accentColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                widget.rewardedAd(protein: widget.protein);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  // rewardedAd(protein);
                  // showDialog(
                  //     context: context,
                  //     builder: (c) {
                  //       return AddProteinDateDialog(protein.date);
                  //     });
                },
                child: Icon(
                  Icons.add,
                  color: MyColors.textColor,
                )),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class OneDayCircle extends StatelessWidget {
  const OneDayCircle(
      {Key key, this.proteinDaily, this.proteinValue, this.day, this.color})
      : super(key: key);
  final int proteinValue;
  final int day;
  final int proteinDaily;
  final Color color;

  String whichDay() {
    switch (day) {
      case 1:
        return 'M';
        break;
      case 2:
        return 'T';
        break;
      case 3:
        return 'W';
        break;
      case 4:
        return 'T';
        break;
      case 5:
        return 'F';
        break;
      case 6:
        return 'S';
        break;
      case 7:
        return 'S';
        break;
      default:
        return '';
    }
  }

  bool shouldVisible() {
    if (proteinValue >= proteinDaily) {
      return true;
    } else {
      return false;
    }
  }

  bool wrongValue() {
    if (proteinValue < 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3),
      child: Column(
        children: [
          Visibility(
              visible: shouldVisible(),
              child: Icon(
                Icons.done,
                size: 16,
                color: MyColors.accentColor,
              )),
          CircularPercentIndicator(
            animation: true,
            animationDuration: 500,
            radius: 20,
            circularStrokeCap: CircularStrokeCap.round,
            percent: wrongValue()
                ? 0
                : shouldVisible()
                    ? 1
                    : proteinValue / proteinDaily,
            progressColor: MyColors.accentColor,
            backgroundColor: MyColors.accentColor.withOpacity(0.2),
            lineWidth: 3,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '${whichDay()}',
            style: TextStyle(
                color: color ?? MyColors.textColor.withOpacity(0.7),
                fontSize: 12,
                fontWeight:
                    color == null ? FontWeight.normal : FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ProteinCardsList extends StatelessWidget {
  const ProteinCardsList({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final Dashboard widget;

  @override
  Widget build(BuildContext context) {
    print('My Hour ${widget.myProvider.items[0].hour}');
    return Container(
      width: widget.width * 0.7,
      height: widget.height * 0.15,
      child: FutureBuilder(
        future: widget.myProvider.getSingleProteins(),
        builder: (context, snapshot) {
          List<SingleProtein> items = widget.myProvider.items;
          return ListWheelScrollView(
            diameterRatio: 2.2,
            itemExtent: widget.height * 0.11,
            children: items.length != 0
                ? List.generate(items.length, (index) {
                    return ProteinCard(
                      protviedr: widget,
                      width: widget.width,
                      text: items[index].text,
                      number: items[index].number,
                      hour: items[index].hour,
                      height: widget.height,
                    );
                  })
                : [
                    ProteinCard(
                      protviedr: widget,
                      width: widget.width,
                      height: widget.height,
                      text: 'No thing to view',
                      number: 0,
                    )
                  ], //[

            // ...widget.myProvider.items.map((e) {
            //   return ProteinCard(width: widget.width,text: e.text,number: e.number,height: widget.height,);
            // })
            //],

            // children: [
            //   ProteinCard(width: width,height: height,text: 'Milk',number: 30,),
            //   ProteinCard(width: width,height: height,text: 'Chicken',number: 60,),
            //   ProteinCard(width: width,height: height,text: 'Milk',number: 30,),
            //
            // ],
          );
        },
      ),
    );
  }
}

class ProteinCard extends StatelessWidget {
  ProteinCard(
      {this.width,
      this.text,
      this.number,
      this.height,
      this.protviedr,
      this.hour});

  final String text;
  final int number;
  final double width;
  final double height;
  final Dashboard protviedr;
  final String hour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: width * 0.65,
      height: 86,
      decoration: BoxDecoration(
        color: MyColors.darkBackGround,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Dismissible(
        onDismissed: (s) async {
          if (s == DismissDirection.startToEnd) {
            await Provider.of<Data>(context, listen: false)
                .deleteDismiss(text, number, hour);
          } else {
            await Provider.of<Data>(context, listen: false)
                .addProtein(number, text);
          }
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.only(left: 24),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                size: 32,
              )),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.only(right: 24),
          child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.control_point_duplicate, size: 32)),
        ),
        key: UniqueKey(),
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  '${number}g',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.textColor),
                ),
                Container(
                    width: 60,
                    child: Divider(
                      thickness: 1,
                      color: MyColors.accentColor,
                    )),
                Text(
                  '$text',
                  style: TextStyle(fontSize: 16, color: MyColors.textColor),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  hour == null ? '' : hour.substring(0, 5),
                  style: TextStyle(fontSize: 10, color: MyColors.textColor),
                )),
          )
        ]),
      ),
    );
  }
}

// class OneDayGraph extends StatefulWidget {
//   final proteinV;
//   final int day;
//   final Data myProvider;
//   final double height;
//   final int duration;
//
//   OneDayGraph(
//       {this.day, this.proteinV, this.myProvider, this.height, this.duration});
//
//   @override
//   _OneDayGraphState createState() => _OneDayGraphState();
// }
//
// class _OneDayGraphState extends State<OneDayGraph> {
//   String dayInString;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height * 0.17,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(
//             '${widget.proteinV}',
//             style: TextStyle(
//                 color: (widget.proteinV / widget.myProvider.proteinDaily) < 1
//                     ? Color(0xffffffff)
//                     : Color(0xffffffff),
//                 fontWeight: FontWeight.bold),
//           ),
//           Flexible(
//             child: AnimatedSize(
//               vsync: this,
//               curve: Curves.easeInQuart,
//               duration: Duration(milliseconds: widget.duration),
//               child: FractionallySizedBox(
//                 heightFactor:
//                     ((widget.proteinV / widget.myProvider.proteinDaily) <= 1.0
//                         ? (widget.proteinV / widget.myProvider.proteinDaily)
//                         : 1.0),
//                 child: Container(
//                   width: 8,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color:
//                           (widget.proteinV / widget.myProvider.proteinDaily) < 1
//                               ? Color(0xff70E1F1)
//                               : Colors.teal[200],
//                       borderRadius: BorderRadius.circular(50)),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 6,
//           ),
//           Text(
//             '${widget.day == 1 ? 'Mn' : widget.day == 2 ? 'Te' : widget.day == 3 ? 'Wd' : widget.day == 4 ? 'Tu' : widget.day == 5 ? 'Fr' : widget.day == 6 ? 'St' : widget.day == 7 ? 'Sn' : ''}',
//             style: TextStyle(
//                 color: (widget.proteinV / widget.myProvider.proteinDaily) < 1
//                     ? Colors.white70
//                     : Colors.white70),
//           )
//         ],
//       ),
//     );
//   }
// }

// class Last7Days extends StatelessWidget {
//   const Last7Days({
//     Key key,
//     @required this.width,
//     @required this.myProvider,
//     @required this.height,
//   }) : super(key: key);
//
//   final double width;
//   final Data myProvider;
//   final double height;
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Container(
//         decoration: BoxDecoration(
//           // boxShadow: [
//           //   BoxShadow(
//           //       offset: Offset(0, 2),
//           //       color: Colors.black.withOpacity(0.1),
//           //       spreadRadius: 2,
//           //       blurRadius: 7)
//           // ],
//            // color: Color(0xff223D5D),
//             borderRadius: BorderRadius.circular(10)),
//
//         padding: EdgeInsets.all(16),
//         width: width * 0.95,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Text(
//             //   'Last 7 days :',
//             //   style: TextStyle(
//             //       fontSize: 18, fontWeight: FontWeight.bold),
//             //   textAlign: TextAlign.left,
//             // ),
//             SizedBox(
//               height: 20,
//             ),
//             FutureBuilder(
//               future: myProvider.get7DaysState(),
//               builder: (context, snapshot) => Flexible(
//                 child: Container(
//                   child: Last7DaysGraph(),
//                   height: height * 0.13,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ProfileScreen extends StatelessWidget {
  const ProfileScreen(
      {Key key,
      this.myProvider,
      this.myInterstitialAd,
      this.myProfileBanner,
      this.show,
      this.isProfileBannerReady,
      this.dialog,
      this.preference,
      this.isNativeReady,
      this.nativeAd})
      : super(key: key);
  final bool isProfileBannerReady;
  final BannerAd myProfileBanner;
  final Data myProvider;
  final InterstitialAd myInterstitialAd;
  final Function show;
  final String preference;
  final dialog;
  final isNativeReady;
  final NativeAd nativeAd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
        ),

        if (myProvider.isPurchased == false)
          isNativeReady
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: MyColors.darkBackGround),
                  child: AdWidget(
                    ad: nativeAd,
                  ),
                  height: 84,
                  width: MediaQuery.of(context).size.width * 0.9,
                )
              : isProfileBannerReady && myProvider.isPurchased == false
                  ? Container(
                      child: AdWidget(
                        ad: myProfileBanner,
                      ),
                      height: myProfileBanner.size.height.toDouble(),
                      width: myProfileBanner.size.width.toDouble(),
                    )
                  : Container(
                      height: myProfileBanner.size.height.toDouble(),
                    ),
        Divider(),
        // Container(
        //   child: AdmobBanner(
        //     adUnitId: AdsManager.profileBannerId,
        //     adSize: AdmobBannerSize.LARGE_BANNER,
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            final getImage =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (getImage != null) {
              myProvider.setImagePath(getImage.path);
            }
          },
          child: CircleAvatar(
            child: myProvider.imagePath == null
                ? Icon(
                    Icons.person,
                    size: 120,
                    color: MyColors.textColor,
                  )
                : Container(),
            backgroundImage: myProvider.imagePath != null
                ? FileImage(File(myProvider.imagePath))
                : null,
            radius: 80,
            backgroundColor: MyColors.darkBackGround,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            // if (await interstitialAd.isLoaded &&
            //     myProvider.nowProtein.protein >= 1) {
            //   interstitialAd.show();
            // }
            if (myInterstitialAd != null) {
              show();
            }
            showDialog(
                context: context, builder: (context) => EditNameDialog());
            //Provider.of<Data>(context,listen: false).setGoal(200);
          },
          child: Text(
            myProvider.userName == null
                ? 'User Name'
                : '${myProvider.userName}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: MyColors.textColor),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        myProvider.isPurchased
            ? Text(
                '☆ Premium ☆',
                style: TextStyle(
                    color: MyColors.accentColor, fontWeight: FontWeight.bold),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PremiumScreen.id);
                },
                child: Text(
                  'Go Premium',
                  style: TextStyle(
                      color: MyColors.accentColor, fontWeight: FontWeight.bold),
                ),
              ),
        Spacer(
          flex: 1,
        ),
        Row(
          children: [
            Expanded(child: Divider()),
            SizedBox(
              width: 20,
            ),
            Text(
              'The information',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: MyColors.textColor),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(child: Divider()),
          ],
        ),
        Spacer(
          flex: 1,
        ),
        //SizedBox(height: 40,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    // if (await interstitialAd.isLoaded && myProvider
                    //     .nowProtein.protein >= 1) {
                    //   interstitialAd.show();
                    // }
                    if (myInterstitialAd != null) {
                      show();
                    }
                    showDialog(
                        context: context,
                        builder: (context) => EditWeightDialog());
                  },
                  child: Column(
                    children: [
                      Text(
                        'Weight',
                        style: TextStyle(
                            color: MyColors.accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${myProvider.weight}$preference',
                        style:
                            TextStyle(fontSize: 20, color: MyColors.textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: 30, child: VerticalDivider()),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    // if (await interstitialAd.isLoaded && myProvider
                    //     .nowProtein.protein >= 1) {
                    //   interstitialAd.show();
                    // }
                    if (myInterstitialAd != null) {
                      show();
                    }
                    showDialog(
                        context: context,
                        builder: (context) => EditGoalDialog());
                    //Provider.of<Data>(context,listen: false).setGoal(200);
                  },
                  child: Column(
                    children: [
                      Text(
                        'Goal',
                        style: TextStyle(
                            color: MyColors.accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${myProvider.proteinDaily}g',
                        style:
                            TextStyle(fontSize: 20, color: MyColors.textColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: 30, child: VerticalDivider()),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.getBool('kg')) {
                      prefs.setBool('kg', false);
                      Provider.of<Data>(context, listen: false).setKg('Ibs');
                    } else {
                      prefs.setBool('kg', true);
                      Provider.of<Data>(context, listen: false).setKg('kg');
                    }
                    //getPrefs(context);
                  },
                  child: Column(
                    children: [
                      Text(
                        'Preference',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyColors.accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$preference',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MyColors.textColor),
                      ),

                      //FutureBuilder(
                      //future: getPrefs(context),
                      // builder:(context, snapshot) => Text('$preference',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                      //child: Text('kg',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),

        Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
