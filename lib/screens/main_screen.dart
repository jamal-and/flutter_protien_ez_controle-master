import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/ads_manager.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_protien_ez_controle/models/data_for_sql.dart';
import 'package:flutter_protien_ez_controle/screens/set_name_dialog.dart';
import 'package:provider/provider.dart';
import 'add_protein_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_weight_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'set_goal_dialog.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  String preference = 'kg!';
  SharedPreferences prefs;
  AdmobInterstitial interstitialAd;
  // Future<void> getPrefs(context)async {
  //   prefs = await SharedPreferences.getInstance();
  //   if(prefs.getBool('kg')==true){
  //     Provider.of<Data>(context,listen: false).setKg('kg');
  //   }else{
  //     Provider.of<Data>(context,listen: false).setKg('Ibs');
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: AdsManager.intersitialAdId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
  }
  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var myProvider = Provider.of<Data>(context);
    preference = myProvider.kg;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: SizedBox(
          height: 55,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            clipBehavior: Clip.antiAlias,
            child: BottomNavigationBar(

              selectedItemColor: Color(0xff70e1f1),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
              backgroundColor: Color(0xff0B203D),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Dashboard',
                    backgroundColor: Color(0xff0E284D)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                    backgroundColor: Color(0xff0E284D)),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FutureBuilder(
          future: myProvider.getWeight(),
          builder: (context, snapshot) => FloatingActionButton(
            backgroundColor: (myProvider.nowProtein.protein) <=(myProvider.proteinDaily)
                ? Color(0xCC70E1F1)
                : Colors.teal[300],
            onPressed: myProvider.nowProtein.isDone == 0
                ? () async{
                    if(await interstitialAd.isLoaded&&myProvider.nowProtein.protein>=1){
                      interstitialAd.show();
                    }
                    //myProvider.addProtein(30);
                    showDialog(
                        context: context,
                        builder: (context) => AddProteinDialog());
                  }
                : () {
                    final snackBar = SnackBar(
                        content: Text(
                            'You did it! good job for today, see you tomorrow'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
            child: Icon(
              myProvider.nowProtein.isDone == 1 ? Icons.done : Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Protein Tracker',
            style: GoogleFonts.lato(
                textStyle: TextStyle(fontWeight: FontWeight.w600)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xff0E284C),
        body: IndexedStack(
          index: currentIndex,
          children: [
            Dashboard(myProvider: myProvider, height: height, width: width),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                ),
                Container(
                  child: AdmobBanner(
                    adUnitId: AdsManager.profileBannerId,
                    adSize: AdmobBannerSize.LARGE_BANNER,
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: ()async{
                    final getImage=await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(getImage!=null){
                      myProvider.setImagePath(getImage.path);
                    }
                  },
                  child: CircleAvatar(
                    child: myProvider.imagePath==null?Icon(
                      Icons.person,
                      size: 120,
                      color: Colors.white,
                    ):Container(),
                    backgroundImage: myProvider.imagePath!=null?FileImage(File(myProvider.imagePath)):null,
                    radius: 80,
                    backgroundColor: Color(0xff243C5F),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) => EditNameDialog());
                    //Provider.of<Data>(context,listen: false).setGoal(200);

                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 6,),
                      Icon(Icons.edit,color: Color(0xff0E284D),size: 18,),
                      Text(
                        myProvider.userName==null?'User Name':'${myProvider.userName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6,),
                      Icon(Icons.edit,color: Colors.white54,size: 18,),
                    ],
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
                      'The informations',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Colors.white70),
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
crossAxisAlignment:   CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => EditWeightDialog());
                          },
                          child: Column(
                            children: [
                              Text(
                                'Weight',
                                style: TextStyle(
                                    color: Color(0xff70E1F1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${myProvider.weight}$preference',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 6,),
                              Icon(Icons.edit,color: Colors.white54,size: 18,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 30, child: VerticalDivider()),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
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
                                    color: Color(0xff70E1F1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${myProvider.proteinDaily}g',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 6,),
                              Icon(Icons.edit,color: Colors.white54,size: 18,),
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
                              Provider.of<Data>(context, listen: false)
                                  .setKg('Ibs');
                            } else {
                              prefs.setBool('kg', true);
                              Provider.of<Data>(context, listen: false)
                                  .setKg('kg');
                            }
                            //getPrefs(context);
                          },
                          child: Column(
                            children: [
                              Text(
                                'Preference',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff70E1F1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '$preference',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6,),
                              Icon(Icons.switch_left_outlined,color: Colors.white54,size: 18,),

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
                )
              ],
            )
          ],
        )
        //currentIndex ==0? Dashboard(myProvider: myProvider, height: height, width: width):Container(),
        );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key key,
    @required this.myProvider,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final Data myProvider;
  final double height;
  final double width;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<SingleProtein> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          child: Center(
            child: FutureBuilder(
              future: widget.myProvider.getWeight(),
              builder: (context, snapshot) => Column(
                children: [
                  Container(

                    width: widget.width * 0.9,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff0B203D),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3)
                          ]),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'PROTEIN',
                            style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 3),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CircularPercentIndicator(
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Color(0xff0E284D),
                            progressColor: (widget.myProvider.nowProtein.protein /
                                widget.myProvider.proteinDaily)<1?Color(0xff70E1F1):Colors.teal[300],
                            radius: widget.height*0.28,
                            lineWidth: widget.height*0.015,
                            animation: true,
                            percent: (widget.myProvider.nowProtein.protein /
                                widget.myProvider.proteinDaily)<=1?(widget.myProvider.nowProtein.protein /
                                widget.myProvider.proteinDaily):1,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.myProvider.nowProtein.protein}g',
                                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(thickness: 1,color: Color(0xff70E1F1),)),
                                Text(
                                  "${widget.myProvider.nowProtein.protein * 100 ~/ widget.myProvider.proteinDaily}%",
                                  style: new TextStyle(
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,

                                  child:
                                    Text('Goal: ${widget.myProvider.proteinDaily}g'
                                      ,style:TextStyle(fontSize: 16,fontWeight: FontWeight.normal) ,),

                                ),
                              ),
                              Text('  |  ',style:TextStyle(fontSize: 16,fontWeight: FontWeight.normal) ,),
                              Expanded(
                                child: Text('Remaining: ${widget.myProvider.kalanDaily>0?widget.myProvider.kalanDaily:0}g'
                                  ,style:TextStyle(fontSize: 14,fontWeight: FontWeight.normal) ,),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  //Container(height: height * 0.25, child: ProteinGraph(height)),
                  SizedBox(
                    height: widget.height * 0.01,
                  ),
                   Container(
                     padding: EdgeInsets.only(top: 8),
                     height: widget.height*0.135,
                       width: widget.width*0.6,
                       child: FutureBuilder(
                         future: widget.myProvider.getSingleProteins(),
                         builder:(s,a){
                           items=widget.myProvider.items.reversed.toList();
                           if(items.length==0){
                             return ProteinCard(width: widget.width,height: widget.height,text: 'Your meals will show here',number: 0,);
                           }
                           return ListView.builder(
                           itemCount: items.length,
                             itemBuilder: (s,index){
                             return ProteinCard(
                               width: widget.width,
                             height: widget.height,
                             number: items[index].number,
                             text: items[index].text,);
                         }
                         );},
                       )),
                  //ProteinCardsList(widget: widget,),
                  SizedBox(height: 10,),
                  Container(
                    child: AdmobBanner(
                      adUnitId: AdsManager.bannerId,
                      adSize: AdmobBannerSize.BANNER,
                    ),
                  ),
                  // Container(
                  //   width: width * 0.8,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Expanded(
                  //         child: Container(
                  //           margin: EdgeInsets.only(right: 16),
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 16, horizontal: 8),
                  //           decoration: BoxDecoration(
                  //               color: Color(0xff223D5D),
                  //               borderRadius: BorderRadius.circular(20)),
                  //           child: Column(
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text('Goal: ',
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.bold)),
                  //                   Text(
                  //                     '${myProvider.proteinDaily}gr',
                  //                     style: TextStyle(
                  //                         color: Color(0xfff27095),
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                 ],
                  //               ),
                  //               SizedBox(
                  //                 height: height * 0.015,
                  //               ),
                  //               GestureDetector(
                  //                 onTap: () {
                  //                   showDialog(
                  //                       context: context,
                  //                       builder: (context) =>
                  //                           EditWeightDialog());
                  //                 },
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Text(
                  //                       'Weight: ',
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                     Text(
                  //                       '${myProvider.weight}${myProvider.kg}',
                  //                       style: TextStyle(
                  //                           color: Color(0xff70e1f1),
                  //                           fontWeight: FontWeight.bold),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           margin: EdgeInsets.only(left: 16),
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 16, horizontal: 8),
                  //           decoration: BoxDecoration(
                  //               color: Color(0xff223D5D),
                  //               borderRadius: BorderRadius.circular(20)),
                  //           child: Column(
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text('Taken: ',
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.bold)),
                  //                   Text(
                  //                     '${myProvider.nowProtein.protein}gr',
                  //                     style: TextStyle(
                  //                         color: Color(0xfff27095),
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                 ],
                  //               ),
                  //               SizedBox(
                  //                 height: height * 0.015,
                  //               ),
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Flexible(
                  //                     child: Text('Remaining: ',
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.bold)),
                  //                   ),
                  //                   Text(
                  //                     '${myProvider.kalanDaily}gr',
                  //                     style: TextStyle(
                  //                         color: Color(0xff70e1f1),
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //Spacer(),
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FutureBuilder(
                        future: widget.myProvider.get7DaysState(),
                        builder:(context, snapshot) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 16,),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 6)).weekday),proteinV: widget.myProvider.protein6.protein,myProvider: widget.myProvider,height: widget.height,)),
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 5)).weekday),proteinV: widget.myProvider.protein5.protein,myProvider: widget.myProvider,height: widget.height)),
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 4)).weekday),proteinV: widget.myProvider.protein4.protein,myProvider: widget.myProvider,height: widget.height)),
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 3)).weekday),proteinV: widget.myProvider.protein3.protein,myProvider: widget.myProvider,height: widget.height)),
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 2)).weekday),proteinV: widget.myProvider.protein2.protein,myProvider: widget.myProvider,height: widget.height)),
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 1)).weekday),proteinV: widget.myProvider.protein1.protein,myProvider: widget.myProvider,height: widget.height)),
                              Expanded(child: OneDayGraph(day: (DateTime.now().subtract(Duration(days: 0)).weekday),proteinV: widget.myProvider.nowProtein.protein,myProvider: widget.myProvider,height: widget.height)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,)
                  //Last7Days(width: width, myProvider: myProvider, height: height)
                ],
              ),
            ),
          ),
        ),
      ],
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
    return Container(
      width: widget.width*0.7,
      height: widget.height*0.15,
      child: FutureBuilder(

        future: widget.myProvider.getSingleProteins(),
        builder: (context,snapshot){
          List<SingleProtein> items=widget.myProvider.items;
          return ListWheelScrollView(
          diameterRatio: 2.2,
          itemExtent: widget.height*0.11,
          children: items.length!=0?List.generate(items.length, (index) {
            print('${items.length}');
            return ProteinCard(width: widget.width,text: items[index].text,number: items[index].number,height: widget.height,);
          }):[ProteinCard(width: widget.width,height: widget.height,text: 'No thing to view',number: 0,)], //[

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
  ProteinCard({this.width,this.text,this.number,this.height});
  final String text;
  final int number;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
    width: width*0.65,


    decoration: BoxDecoration(
        color: Color(0xff0B203D),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5)
        ]
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 12,),
        Text('${number}g',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        Container(width:60,child: Divider(thickness: 1,color: Color(0xff70E1F1),)),
        Text('$text',style: TextStyle(fontSize: 16),),
        SizedBox(height: 10,),
      ],),
                      );
  }
}

class OneDayGraph extends StatelessWidget {
  final  proteinV;
  final int day;
  final Data myProvider;
  final double height;
  String dayInString;
  OneDayGraph({this.day,this.proteinV,this.myProvider,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.17,
      child: Column( mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('$proteinV',style: TextStyle(color: (proteinV /
          myProvider.proteinDaily)<1?Color(0xffffffff):Colors.teal[200],fontWeight: FontWeight.bold),),
          Flexible(
            child: FractionallySizedBox(
              heightFactor: ((proteinV /
                  myProvider.proteinDaily)<=1.0?(proteinV /
                  myProvider.proteinDaily):1.0),

              child: Container(
                width: 7,
                height: 50,
                decoration: BoxDecoration(
                  color: (proteinV /
                      myProvider.proteinDaily)<1?Color(0xff70E1F1):Colors.teal[200],
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ),
          SizedBox(height: 6,),
          Text('${day==1?'Mn':day==2?'Te':day==3?'Wd':day==4?'Tu':day==5?'Fr':day==6?'St':day==7?'Sn':''}',
          style: TextStyle(color: (proteinV /
              myProvider.proteinDaily)<1?Color(0xffffffff):Colors.teal[200]),)
        ],
      ),
    );
  }
}

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
