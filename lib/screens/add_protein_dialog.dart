import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'new_screen.dart';

class AddProteinDialog extends StatefulWidget {
  @override
  _AddProteinDialogState createState() => _AddProteinDialogState();
}

class _AddProteinDialogState extends State<AddProteinDialog> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
@override
  void initState() {

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    int mv;
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
              'Add Protein with gr',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10,),
            TextField(
                onChanged: (v) {
                  // Provider.of<Data>(context).proteinWillBeAdded = int.parse(v);
                  mv=int.parse(v);
                },
                style: TextStyle(fontSize: 20),
                cursorColor: Color(0xff70E1F1),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Protein with gr',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff27095)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff27095)),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfff27095)),
                  ),
                )),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: Color(0xfff27095)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                GestureDetector(
                  onTap: ()async{
                    showDailyAtTime();
                    //showBigPictureNotification();
                    //showNotification();
                    if(mv!=null) {
                      await Provider.of<Data>(context,listen: false).addProtein(mv);
                      Navigator.pop(context);
                    }else{
                      final snackBar = SnackBar(content: Text('You forgot put a number!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    if((Provider.of<Data>(context,listen: false).nowProtein.isDone)!=1){
                      print('is not Done');
                      if(DateTime.now().hour<23){
                        scheduleNotification();
                      }else{
                        print('its late');
                      }
                    }



                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xfff27095),),
                    child: Text('Add',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
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
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(hours: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Protein tracker',
        'Take protein to get your goal',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  Future<void> showDailyAtTime() async {
    var time = Time(12, 0, 0);

    var androidChannelSpecifics = AndroidNotificationDetails(
      'channel id 1',
      'channel name 2',
      'channel description 3',
      //importance: Importance.Max,
      //priority: Priority.High,
      //playSound: true,
      //timeoutAfter: 5000,
      //enableLights: true,
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
    NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Don\'t miss your target',
      'Reach your goal', //null
      time,
      platformChannelSpecifics,
      payload: 'New Payload'

    );
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
