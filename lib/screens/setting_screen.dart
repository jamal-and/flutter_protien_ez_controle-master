import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_protien_ez_controle/screens/feedback_dialog.dart';
import 'package:flutter_protien_ez_controle/screens/main_screen.dart';
import 'package:flutter_protien_ez_controle/screens/personal_inofrmation_screen.dart';
import 'package:flutter_protien_ez_controle/screens/premium_screen.dart';
import 'package:flutter_protien_ez_controle/screens/rating_dialog.dart';
import 'package:flutter_protien_ez_controle/screens/set_goal_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen(
      {Key key, this.reLoadAds,})
      : super(key: key);
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
    MyColors.defaultMode = Provider.of<Data>(context).darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    print(
        'length is ${Provider.of<Data>(context, listen: false).products.length} for ${Provider.of<Data>(context, listen: false).products} cuz ${Provider.of<Data>(context, listen: false).available}');
    for (var prod in Provider.of<Data>(context, listen: false).products) {
      print(
          'prod is $prod and lenght is ${Provider.of<Data>(context, listen: false).products.length} for ${Provider.of<Data>(context, listen: false).products} ');
    }
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [

          ListTile(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalInformationScreen()));
              setState(() {});
            },
            leading: Icon(
              Icons.person_outline,
              color: MyColors.textColor,
            ),
            title: Text(
              'Personal Information',
              style: TextStyle(
                color: MyColors.textColor,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: MyColors.textColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditGoalDialog(),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.adjust_outlined,
                color: MyColors.textColor,
              ),
              title: Text('Goal',
                  style: TextStyle(
                    color: MyColors.textColor,
                  )),
              trailing: Icon(
                Icons.chevron_right,
                color: MyColors.textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: ()  async {
              // Data myProvider = Provider.of<Data>(context, listen: false);
              //
              //   if (myProvider.userName == null || myProvider.email == null|| myProvider.email.isEmpty) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Row(
              //           children: [
              //             Text('You need email to make conversation'),
              //             Spacer(),
              //             GestureDetector(
              //               onTap: (){
              //                 Navigator.pushNamed(context, PersonalInformationScreen.id);
              //                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //               },
              //               child: Text('Add email',style: TextStyle(color: MyColors.accentColor,fontWeight: FontWeight.bold),),
              //             )
              //           ],
              //         ),
              //       ),
              //     );
              //     return;
              //   }
                showDialog(context: context, builder: (s){
                  return SendFeedBackDialog();
                });
            },
            child: ListTile(
              leading: Icon(
                Icons.feedback_outlined,
                color: MyColors.textColor,
              ),
              title: Text('Feedback',
                  style: TextStyle(
                    color: MyColors.textColor,
                  )),
              trailing: Icon(
                Icons.chevron_right,
                color: MyColors.textColor,
              ),
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
              leading: Icon(
                Icons.star_rate_outlined,
                color: MyColors.textColor,
              ),
              title: Text('Rate us',
                  style: TextStyle(
                    color: MyColors.textColor,
                  )),
              trailing: Icon(
                Icons.chevron_right,
                color: MyColors.textColor,
              ),
            ),
          ),
          for (ProductDetails prod in Provider.of<Data>(context, listen: false).products)
            ListTile(
              onTap: () async{
                String s=await BillingClient((s){}).queryPurchaseHistory(SkuType.subs).then((value) {print('GGG+${value.purchaseHistoryRecordList.length}');return null;});
                print('ss');
                print(prod.skuDetail.freeTrialPeriod);
                Navigator.pushNamed(context, PremiumScreen.id);
                //_buyProduct(prod);
              },
              leading: Text(
                'Pro',
                style: TextStyle(
                    color: MyColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              title: Text(
                  Provider.of<Data>(context, listen: false).isPurchased
                      ? 'Premium'
                      :Provider.of<Data>(context, listen: false).hasFreeTrial?'Free Trial Premium': 'Upgrade Premium!',
                  style: TextStyle(
                    color: MyColors.accentColor,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text(
                Provider.of<Data>(context, listen: false).isPurchased
                    ? 'You already Premium'
                    : Provider.of<Data>(context, listen: false).hasFreeTrial?"Your free trial didn't used yet":'tap to see the features',
                style: TextStyle(color: MyColors.textColor.withOpacity(0.8)),
              ),
              trailing: Icon(Icons.chevron_right, color: MyColors.accentColor),
            ),
          ListTile(
            title: Text(
              'Dark mode',
              style: TextStyle(color: MyColors.textColor),
            ),
            leading: Icon(
              Icons.dark_mode,
              color: MyColors.textColor,
            ),
            trailing: Switch(
                activeColor: MyColors.accentColor,

                //inactiveThumbColor: MyColors.accentColor,
                inactiveTrackColor: MyColors.darkBackGround,
                value: Provider.of<Data>(context).darkTheme,
                onChanged: (value) {
                  Provider.of<Data>(context, listen: false).switchTheme(value);

                  // widget.reLoadAds();
                  Navigator.popAndPushNamed(context, MainScreen.id);
                }),
          ),
          GestureDetector(
            onTap: () {
              launch('https://www.instagram.com/protein_tracker/');
            },
            child: ListTile(
              leading: SvgPicture.asset('assets/instagram.svg',color: Color(0xffE4405F),height: 24,width: 24,),
              title: Text('Follow us',
                  style: TextStyle(
                    color: MyColors.textColor,
                  )),
              trailing: Icon(
                Icons.chevron_right,
                color: MyColors.textColor,
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Features :',
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        '✓ No ads \n✓ Adding protein for previous days\n✓ Edit your meals after adding them \n And so many features will come in future',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ))
                ],
              ),
            ),
          )
        ],
      ).toList(),
    );
  }
}
