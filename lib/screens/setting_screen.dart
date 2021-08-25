import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_protien_ez_controle/screens/feedback_dialog.dart';
import 'package:flutter_protien_ez_controle/screens/main_screen.dart';
import 'package:flutter_protien_ez_controle/screens/personal_inofrmation_screen.dart';
import 'package:flutter_protien_ez_controle/screens/premium_screen.dart';
import 'package:flutter_protien_ez_controle/screens/rating_dialog.dart';
import 'package:flutter_protien_ez_controle/screens/set_goal_dialog.dart';
import 'package:provider/provider.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key,this.reLoadAds}) : super(key: key);
  final Function reLoadAds;
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {



  @override
  void initState() {
    var provider = Provider.of<Data>(context, listen: false);
    provider.initialize();
    // TODO: implement initState
    super.initState();
  }
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    MyColors.defaultMode=Provider.of<Data>(context).darkTheme;
  }
  @override
  Widget build(BuildContext context) {
    print('length is ${Provider.of<Data>(context,listen: false).products.length} for ${Provider.of<Data>(context,listen: false).products} cuz ${Provider.of<Data>(context,listen: false).available}');
    for( var prod in Provider.of<Data>(context,listen: false).products){
      print('prod is $prod and lenght is ${Provider.of<Data>(context,listen: false).products.length} for ${Provider.of<Data>(context,listen: false).products} ');
    }
    return ListView(
      children:
      ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, PersonalInformationScreen.id).then((value) =>  setState(() {}));
            },
            leading: Icon(Icons.person_outline,color: MyColors.textColor,),
            title: Text('Personal Information',style: TextStyle(color: MyColors.textColor,),),
            trailing: Icon(Icons.chevron_right,color: MyColors.textColor,),

          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditGoalDialog(),
              );
            },
            child: ListTile(
              leading: Icon(Icons.adjust_outlined,color: MyColors.textColor,),
              title: Text('Goal',style: TextStyle(color: MyColors.textColor,)),
              trailing: Icon(Icons.chevron_right,color: MyColors.textColor,),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SendFeedBackDialog(),
              );
            },
            child: ListTile(
              leading: Icon(Icons.feedback_outlined,color: MyColors.textColor,),
              title: Text('Feedback',style: TextStyle(color: MyColors.textColor,)),
              trailing: Icon(Icons.chevron_right,color: MyColors.textColor,),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => MyRatingDialog(),
              );
            },
            child: ListTile(
              leading: Icon(Icons.star_rate_outlined,color: MyColors.textColor,),
              title: Text('Rate us',style: TextStyle(color: MyColors.textColor,)),
              trailing: Icon(Icons.chevron_right,color: MyColors.textColor,),
            ),
          ),
          for( var prod in Provider.of<Data>(context,listen: false).products)ListTile(
            onTap: (){
              Navigator.pushNamed(context, PremiumScreen.id);
              //_buyProduct(prod);
            },
            leading: Text('Pro',style: TextStyle(color: MyColors.textColor,fontWeight: FontWeight.bold,fontSize: 18),),
            title: Text(Provider.of<Data>(context,listen: false).isPurchased?'Premium':'Go Premium!',style: TextStyle(color: MyColors.accentColor,fontWeight: FontWeight.bold,)),
            subtitle: Text(Provider.of<Data>(context,listen: false).isPurchased?'You already Premium':'Start for free! tap to see the features',style: TextStyle(color: MyColors.textColor.withOpacity(0.8)),),

            trailing: Icon(Icons.chevron_right,color: MyColors.accentColor),
          ),
          ListTile(
            title:Text('Dark mode',style: TextStyle(color: MyColors.textColor),),
            leading: Icon(Icons.dark_mode,color: MyColors.textColor,),

            trailing: Switch(
              activeColor: MyColors.accentColor,

                inactiveThumbColor: MyColors.accentColor,
                inactiveTrackColor: MyColors.darkBackGround,
                value: Provider.of<Data>(context).darkTheme,
                onChanged: (value){
              Provider.of<Data>(context, listen: false).switchTheme(value);

             // widget.reLoadAds();
              Navigator.popAndPushNamed(context,MainScreen.id);



            }),
          ),
          Visibility(
            visible: false,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium Features :',style: TextStyle(color: Colors.cyanAccent,fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  Container(padding:EdgeInsets.only(left: 8),child: Text('✓ No ads \n✓ Adding protein for previous days\n✓ Edit your meals after adding them \n And so many features will come in future',style: TextStyle(color: Colors.white70,fontSize: 14),))
                ],
              ),
            ),
          )

        ],


      ).toList(),



    );
  }
}
