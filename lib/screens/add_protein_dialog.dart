import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddProteinDialog extends StatefulWidget {
  final Function showInter;
  AddProteinDialog({this.showInter});
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
    minLaunches:
        5, // Show rate popup after 5 launches of app after minDays is passed.
    remindDays: 4,
    remindLaunches: 5,
  );
  @override
  void dispose() {
    //interstitialAd.dispose();
    if (Provider.of<Data>(context, listen: false).isPurchased == false) {
      widget.showInter();
    }
    super.dispose();
  }

  getTimeZone() async {
    tZone = await FlutterNativeTimezone.getLocalTimezone();
  }

  @override
  void initState() {
    super.initState();
    rateMyApp.init();
    tz.initializeTimeZones();
    getTimeZone();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  bool addCommentVis = true;
  bool commentVis = false;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String text;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: MyColors.background,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Add Protein',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: MyColors.textColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 24,
            ),
            TextField(
                autofocus: true,
                maxLength: 3,
                controller: controller,
                onChanged: (v) {
                  // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                  //mv=int.parse(v);
                },
                style: TextStyle(fontSize: 20, color: MyColors.textColor),
                cursorColor: MyColors.accentColor,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Protein with gram',
                  labelStyle: TextStyle(color: MyColors.accentColor),
                  hintText: '30',
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.accentColor),
                  ),
                )),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print('clicked');
                    print(addCommentVis);
                    print(commentVis);
                    setState(() {
                      addCommentVis = false;
                      commentVis = true;
                    });
                    print(addCommentVis);
                    print(commentVis);
                  },
                  child: Visibility(
                      visible: addCommentVis,
                      child: Text(
                        'Add Food Name',
                        style: TextStyle(
                            color: MyColors.accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            Visibility(
              visible: commentVis,
              child: TextField(
                  controller: controller2,
                  onChanged: (v) {
                    // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                    text = (v);
                  },
                  style: TextStyle(fontSize: 20),
                  cursorColor: MyColors.accentColor,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  maxLength: 30,
                  decoration: InputDecoration(
                    hintText: 'Chicken',
                    labelText: 'Food name',
                    labelStyle: TextStyle(color: MyColors.accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.accentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.accentColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.accentColor),
                    ),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: MyColors.accentColor),
                  onPressed: () {
                    if (Provider.of<Data>(context, listen: false).isPurchased ==
                        false) {
                      widget.showInter();
                    }
                    // if(widget.interstitialAd!=null){
                    //
                    //   //widget.interstitialAd.show();
                    // }
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                GestureDetector(
                  onTap: () async {
                    if (Provider.of<Data>(context, listen: false).kalanDaily >
                        0) {
                      await scheduleNotification();
                    }
                    await scheduleNotification2();
                    await scheduleNotification3();
                    await scheduleNotification4();
                    await showDailyAtTime();
                    if (Provider.of<Data>(context,
                                    listen: false)
                                .protein1
                                .protein !=
                            0 ||
                        Provider.of<Data>(context,
                                    listen: false)
                                .protein2
                                .protein !=
                            0 ||
                        Provider.of<Data>(context,
                                    listen: false)
                                .protein3
                                .protein !=
                            0 ||
                        Provider.of<Data>(context,
                                    listen: false)
                                .protein6
                                .protein !=
                            0 ||
                        Provider.of<Data>(context,
                                    listen: false)
                                .protein4
                                .protein !=
                            0 ||
                        Provider.of<Data>(context, listen: false)
                                .protein5
                                .protein !=
                            0 ||
                        !rateMyApp.shouldOpenDialog) {
                      if (Provider.of<Data>(context, listen: false)
                              .isPurchased ==
                          false) {
                        widget.showInter();
                      }
                    }
                    if (controller.text != null &&
                        controller.text.isNotEmpty &&
                        int.parse(controller.text) > 0) {
                      if ((Provider.of<Data>(context, listen: false)
                                  .nowProtein
                                  .protein +
                              int.parse(controller.text)) >=
                          (Provider.of<Data>(context, listen: false)
                                  .proteinDaily) /
                              2) {
                        await rateMyApp.init();
                        if (mounted && rateMyApp.shouldOpenDialog) {
                          print('Review us');
                          await rateMyApp.showRateDialog(context);
                        }
                      }
                      if (text == null) {
                        await Provider.of<Data>(context, listen: false)
                            .addProtein(int.parse(controller.text), '-');
                      } else {
                        await Provider.of<Data>(context, listen: false)
                            .addProtein(
                                int.parse(controller.text), controller2.text);
                      }
                      Navigator.pop(context);
                    } else {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message: "Please enter valid protein value!",
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MyColors.accentColor,
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> scheduleNotification() async {
    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 21',
      'channel name',
      channelDescription: 'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    tz.setLocalLocation(tz.getLocation(tZone));
    bool isLateTime =
        (tz.TZDateTime.now(tz.local).add(const Duration(hours: 3)).day) ==
            (tz.TZDateTime.now(tz.local).add(Duration(days: 1)).day);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        21,
        'Protein Reminder',
        isLateTime
            ? 'Lets start new day Progress!'
            : 'Take protein to get your goal, ${Provider.of<Data>(context, listen: false).kalanDaily}g remaining',
        isLateTime
            ? tz.TZDateTime.now(tz.local).add(const Duration(hours: 12))
            : tz.TZDateTime.now(tz.local).add(const Duration(hours: 3)),
        // scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> scheduleNotification2() async {
    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 22',
      'channel name',
      channelDescription: 'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    tz.setLocalLocation(tz.getLocation(tZone));
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        22,
        'Don\'t give up!',
        'That was 1 day without tracking your protein! don\'t give up!',
        tz.TZDateTime.now(tz.local).add(const Duration(days: 1)),
        // scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> scheduleNotification3() async {
    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 33',
      'channel name',
      channelDescription: 'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    tz.setLocalLocation(tz.getLocation(tZone));
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        33,
        'Never give up!',
        'That was 2 day without tracking your protein! don\'t give up!',
        tz.TZDateTime.now(tz.local).add(const Duration(days: 2)),
        // scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> scheduleNotification4() async {
    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 44',
      'channel name',
      channelDescription: 'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    tz.setLocalLocation(tz.getLocation(tZone));
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        44,
        'That Was 3 Days!',
        'That was 3 day without tracking your protein! did you give up?',
        tz.TZDateTime.now(tz.local).add(const Duration(days: 3)),
        // scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showDailyAtTime() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        99,
        'Daily Reminder',
        'Good morning! ,'
            'Don\'t forget to Take Protein',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    if (tZone != null) {
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
}
