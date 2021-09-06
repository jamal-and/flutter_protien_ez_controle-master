import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_protien_ez_controle/models/data_for_sql.dart';
import 'package:flutter_protien_ez_controle/screens/add_meal_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  static String id = 'MealScreen';

  const MealsScreen({Key key,this.interstitialAd}) : super(key: key);
  final Function interstitialAd;
  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  String tZone;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    getTimeZone();

  }
  getTimeZone()async{  tZone = await FlutterNativeTimezone.getLocalTimezone();}
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // var oldList=[
  //   MealCard(mealColor: Colors.pink,
  //   description: 'chicken with rice that contain 30g of protein ',
  //   value: 45,
  //   title: 'Chicken',),
  //   MealCard(mealColor: Colors.blue,
  //     description: 'one scope of whey protein',
  //     value: 30,
  //     title: 'Whey Protein Protein',),
  //   MealCard(mealColor: Colors.deepPurple,
  //     description: 'chicken with rice that contain 30g of protein',
  //     value: 45,
  //     title: 'chicken',),
  //   MealCard(mealColor: Colors.cyan,
  //     description: 'chicken with rice that contain 30g of protein',
  //     value: 45,
  //     title: 'chicken',),
  //   MealCard(mealColor: Colors.orange,
  //     description: 'chicken with rice that contain 30g of protein',
  //     value: 45,
  //     title: 'chicken',),
  //   MealCard(mealColor: Colors.teal,
  //     description: 'chicken with rice that contain 30g of protein',
  //     value: 45,
  //     title: 'chicken',),];
  @override
  Widget build(BuildContext context) {
    Data myProvider=Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        actions: [IconButton(icon:Icon(Icons.add), onPressed: () { Navigator.pushNamed(context, AddMealScreen.id); },)],
        iconTheme: Provider.of<Data>(context).darkTheme?ThemeData.dark().iconTheme:ThemeData.light().iconTheme,
        backgroundColor: MyColors.background,
        title: Text('Meals',style: TextStyle(color: MyColors.textColor),),
      ),
      body: Column(

        children: [

          FutureBuilder(
            future: Provider.of<Data>(context).getMeals(),
            builder: (context,builder) {
              if(Provider.of<Data>(context).mealList.length==0){
                return Expanded(child: Center(child: Text('add meals to show here',style: TextStyle(color: MyColors.textColor),),));
              }
              return Expanded(

                child: GridView.count(
                padding: EdgeInsets.all(16),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
                children: Provider.of<Data>(context).mealList.map((e) => MealCard(description: e.description,title: e.name,value: e.protein,color: e.color,id: e.id,interstitialAd: widget.interstitialAd,notF: makeNotfi,)).toList(),
            ),
              );}
          ),
        ],
      ),
    );
  }
  void makeNotfi(){
    scheduleNotification();
    scheduleNotification2();
    scheduleNotification3();
    scheduleNotification4();
    showDailyAtTime();
  }
  Future<void> scheduleNotification() async {

    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 21',
      'channel name',
      'channel description',
      icon: 'ic_stat',
      largeIcon: DrawableResourceAndroidBitmap('ic_stat'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    tz.setLocalLocation(tz.getLocation(tZone));
    bool isLateTime=(tz.TZDateTime.now(tz.local).add(const Duration(hours: 3)).day)==(tz.TZDateTime.now(tz.local).add(Duration(days: 1)).day);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        21,
        'Protein Reminder',
        isLateTime?'Lets start new day Progress!':'Take protein to get your goal, ${Provider.of<Data>(context,listen: false).kalanDaily}g remaining',
        isLateTime? tz.TZDateTime.now(tz.local).add(const Duration(hours: 12)):tz.TZDateTime.now(tz.local).add(const Duration(hours: 3)) ,
        // scheduledNotificationDateTime,
        platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> scheduleNotification2() async {

    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 22',
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
        22,
        'Don\'t give up!',
        'That was 1 day without tracking your protein! don\'t give up!',
        tz.TZDateTime.now(tz.local).add(const Duration(days: 1)) ,
        // scheduledNotificationDateTime,
        platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> scheduleNotification3() async {

    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 33',
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
        33,
        'Never give up!',
        'That was 2 day without tracking your protein! don\'t give up!',
        tz.TZDateTime.now(tz.local).add(const Duration(days: 2)) ,
        // scheduledNotificationDateTime,
        platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> scheduleNotification4() async {

    // var scheduledNotificationDateTime =
    // DateTime.now().add(Duration(seconds: 3));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id 44',
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
        44,
        'That Was 3 Days!',
        'That was 3 day without tracking your protein! did you give up?',
        tz.TZDateTime.now(tz.local).add(const Duration(days: 3)) ,
        // scheduledNotificationDateTime,
        platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> showDailyAtTime() async {

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

}

class MealCard extends StatelessWidget {
  const MealCard({
    Key key,
    this.color,
    this.title,
    this.description,
    this.value,
    this.id,
    this.interstitialAd,
    this.notF,
  }) : super(key: key);
  final String color;
  final int  id;
  final String title;
  final String description;
  final int value;
  final Function interstitialAd;
  final Function notF;
  @override
  Widget build(BuildContext context) {
    Color mealColor;
    if(color=='pink'){
      mealColor=Colors.pink;
    }else if(color=='orange'){
      mealColor=Colors.orange;
    }else if(color=='teal'){
      mealColor=Colors.teal;
    }else if(color=='blue'){
      mealColor=Colors.blue;
    }else if(color=='cyan'){
      mealColor=Colors.cyan;
    }else if(color=='purple'){
      mealColor=Colors.purple;
    }


    return GestureDetector(
      onTap: (){

        if(Provider.of<Data>(context, listen: false).isPurchased==false){interstitialAd();}
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMealScreen(meal: Meal(name: title,protein: value,description: description,color: color,id: id),)));
      },
      child: Card(
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(12),
        ),
        color: mealColor,
        elevation: 8,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 36),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '$title',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
            Align(alignment: Alignment.topRight, child: GestureDetector(onTap: (){

              Provider.of<Data>(context,listen: false).addProtein(value, title);
              notF();
              if(Provider.of<Data>(context, listen: false).isPurchased==false){interstitialAd();}
              Navigator.pop(context);
            },child: Container(child: Icon(Icons.add,color: Colors.white,),padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),))),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(  color: MyColors.darkBackGround,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10), )),
                    padding: EdgeInsets.only(top: 36,bottom: 4,right: 8,left: 8),

                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Text('${description.isEmpty?'no description':description}',overflow: TextOverflow.ellipsis,maxLines:2,textAlign: TextAlign.center,style: TextStyle(color: MyColors.textColor.withOpacity(0.9),fontSize: 12),)),
                  )),
            ),
            Align(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15), spreadRadius: 4,)],
                  ),
                  child: CircleAvatar(
              radius: 33,
              backgroundColor: mealColor.withOpacity(1),
              child: Text(
                  '${value}g',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
              ),
            ),
                )),
          ],
        ),
      ),
    );
  }

}
