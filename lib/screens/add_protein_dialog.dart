import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'new_screen.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class AddProteinDialog extends StatefulWidget {
  @override
  _AddProteinDialogState createState() => _AddProteinDialogState();
}

class _AddProteinDialogState extends State<AddProteinDialog> {
  //AdmobInterstitial interstitialAd;
  String tZone;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    googlePlayIdentifier: 'com.jamal.protein',
    minDays: 2, // Show rate popup on first day of install.
    minLaunches: 10, // Show rate popup after 5 launches of app after minDays is passed.
    remindDays: 4,
    remindLaunches: 10,
  );
  @override
  void dispose() {
    //interstitialAd.dispose();
    super.dispose();
  }
getTimeZone()async{  tZone = await FlutterNativeTimezone.getLocalTimezone();}
@override
  void initState() {

    super.initState();
    tz.initializeTimeZones();
    getTimeZone();

    // interstitialAd = AdmobInterstitial(
    //   adUnitId: AdsManager.intersitialAdId,
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) interstitialAd.load();
    //   },
    // );
    // interstitialAd.load();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_stat');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

  }
  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }
  bool addCommentVis=true;
  bool commentVis=false;
  TextEditingController controller=TextEditingController();
  TextEditingController controller2=TextEditingController();
  @override
  Widget build(BuildContext context) {

    String text;


    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      backgroundColor: Color(0xff243c5e),
      content: Container(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 10,),
            Text(
              'Add Protein with gram',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10,),
            TextField(
              autofocus: true,
              maxLength: 3,
              controller: controller,
                onChanged: (v) {
                  // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                  //mv=int.parse(v);
                },
                style: TextStyle(fontSize: 20),
                cursorColor: Color(0xff70E1F1),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Protein with gram',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff70E1F1)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff70E1F1)),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff70E1F1)),
                  ),
                )),
            SizedBox(height: 6,),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    print('clicked');
                    print(addCommentVis);
                    print(commentVis);
                    setState(() {
                      addCommentVis=false;
                      commentVis=true;
                    });
                    print(addCommentVis);
                    print(commentVis);

                  },
                  child: Visibility(
                      visible: addCommentVis,
                      child: Text('Add comment',style: TextStyle(color: Color(0xff70E1F1),fontSize: 14 ),)),
                ),
              ],
            ),
            Visibility(
              visible: commentVis,
                child: TextField(
                  controller: controller2,
                    onChanged: (v) {
                      // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                      text=(v);
                    },
                    style: TextStyle(fontSize: 20),
                    cursorColor: Color(0xff70E1F1),
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'chicken...',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff70E1F1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff70E1F1)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff70E1F1)),
                      ),
                    )),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: Color(0xff70E1F1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                GestureDetector(
                  onTap: ()async{
                    // if((Provider.of<Data>(context,listen: false).nowProtein.protein)>10) {
                    //   if (await interstitialAd.isLoaded) {
                    //     interstitialAd.show();
                    //   }else{
                    //     print('No ad');
                    //   }
                    // }

                    //showBigPictureNotification();
                    //showNotification();
                    if(controller.text!=null) {
                      if(text==null){
                        await Provider.of<Data>(context,listen: false).addProtein(int.parse(controller.text),'-');
                      }else {
                        await Provider.of<Data>(context, listen: false)
                            .addProtein(int.parse(controller.text), controller2.text);
                      }
                      Navigator.pop(context);
                    }else{
                      print(controller.text);
                      final snackBar = SnackBar(content: Text('You forgot put a number!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    if(Provider.of<Data>(context, listen: false).kalanDaily>0){
                      await scheduleNotification();
                    }
                    await showDailyAtTime();

                    if((Provider.of<Data>(context,listen: false).nowProtein.protein+int.parse(controller.text))>=(Provider.of<Data>(context,listen: false).proteinDaily)/2){
                      await rateMyApp.init();
                      if (mounted && rateMyApp.shouldOpenDialog) {
                        print('Review us');
                        rateMyApp.showRateDialog(context);
                      }
                    }



                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xff70E1F1),),
                    child: Text('Add',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff223D5D)),),
                  ),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(primary: Color(0xfff27095)),
                //   onPressed: () {
                //     if(mv!=null) {
                //       Provider.of<Data>(context,listen: false).addProtein(mv);
                //       Navigator.pop(context);
                //     }else{
                //       final snackBar = SnackBar(content: Text('You forgot put a number!'));
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     }
                //   },
                //   child: Text('Add'),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
  // showNotification() async {
  //   var android = AndroidNotificationDetails(
  //       'id', 'channel ', 'description',
  //       priority: Priority.High, importance: Importance.Max);
  //   var iOS = IOSNotificationDetails();
  //   var platform = new NotificationDetails(android, iOS);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
  //       payload: 'Welcome to the Local Notification demo'
  //   );
  // }
  Future<void> scheduleNotification() async {

    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    tz.setLocalLocation(tz.getLocation(tZone));
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Protein Reminder',
        'Take protein to get your goal, ${Provider.of<Data>(context,listen: false).kalanDaily}g remaining',
        tz.TZDateTime.now(tz.local).add(const Duration(hours: 3)),
        // scheduledNotificationDateTime,
        platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> showDailyAtTime() async {
    //var time = Time(12, 0, 0);

    // var androidChannelSpecifics = AndroidNotificationDetails(
    //   'repeating channel id',
    //   'repeating channel name212',
    //   'repeating description',
    //   //importance: Importance.Max,
    //   //priority: Priority.High,
    //   //playSound: true,
    //   //timeoutAfter: 5000,
    //   //enableLights: true,
    //   icon: 'ic_stat',
    //   largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    // );
    // var iosChannelSpecifics = IOSNotificationDetails();
    // var platformChannelSpecifics =
    // NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(99,
        'Daily Reminder', 'Good morning! ,'
            'Don\'t forget to Take Protein',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
      android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          'daily notification description'),

    ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    // await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Don\'t miss your target',
    //     'Reach your goal, you have ${Provider.of<Data>(context).kalanDaily}g protein to get', RepeatInterval.daily, platformChannelSpecifics,
    //     androidAllowWhileIdle: true);
    // await flutterLocalNotificationsPlugin.showDailyAtTime(
    //   0,
    //   'Don\'t miss your target',
    //   'Reach your goal', //null
    //   time,
    //   platformChannelSpecifics,
    //   payload: 'New Payload'
    //
    // );
  }
  tz.TZDateTime _nextInstanceOfTenAM() {
    if(tZone!=null) {
      tz.setLocalLocation(tz.getLocation(tZone));
    }
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  // Future<void> showBigPictureNotification() async {
  //   var bigPictureStyleInformation = BigPictureStyleInformation(
  //     DrawableResourceAndroidBitmap("ic_launcher"),
  //     largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
  //     contentTitle: 'flutter devs',
  //     summaryText: 'summaryText',
  //   );
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'big text channel id',
  //       'big text channel name',
  //       'big text channel description',
  //       styleInformation: bigPictureStyleInformation);
  //   var platformChannelSpecifics =
  //   NotificationDetails(androidPlatformChannelSpecifics, null);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'big text title', 'silent body', platformChannelSpecifics,
  //       payload: "big image notifications");
  // }
}
