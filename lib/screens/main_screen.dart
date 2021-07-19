import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/ads_manager.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_protien_ez_controle/models/protien_graph.dart';
import 'package:flutter_protien_ez_controle/models/last7day_graph.dart';
import 'add_protein_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_weight_dialog.dart';


class MainScreen extends StatelessWidget {
  static String id = 'main_screen';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var myProvider = Provider.of<Data>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FutureBuilder(
        future: myProvider.getWeight(),
        builder:(context,snapshot)=> FloatingActionButton(

          backgroundColor:myProvider.nowProtein.isDone==0? Color(0x9970E1F1):Color(0xfff27095),
          onPressed:myProvider.nowProtein.isDone==0? () {
            //myProvider.addProtein(30);
            showDialog(context: context, builder: (context)=>AddProteinDialog());
          }:(){
            final snackBar = SnackBar(content: Text('You did it! good job for today, see you tomorrow'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Icon(
            myProvider.nowProtein.isDone==1?Icons.done:Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Protein Tracker',style: GoogleFonts.lato(textStyle: TextStyle(fontWeight: FontWeight.w600)),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff0E284D),
      body: Column(
        children: [
          Container(

            child: AdmobBanner(
              adUnitId: AdsManager.bannerId,
              adSize: AdmobBannerSize.LARGE_BANNER,
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder(
                future: myProvider.getWeight(),
                builder:(context,snapshot)=> Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(height: height*0.25, child: ProteinGraph(height)),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      width: width*0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 16),
                              padding:
                                  EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Color(0xff223D5D),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Goal: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)
                                      ),
                                      Text(
                                        '${myProvider.proteinDaily}gr',
                                        style: TextStyle(
                                            color: Color(0xfff27095),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      showDialog(context: context, builder: (context)=>EditWeightDialog());
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Weight: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                        Text(
                                          '${myProvider.weight}kg',
                                          style: TextStyle(
                                              color: Color(0xff70e1f1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 16),
                              padding:
                                  EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Color(0xff223D5D),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Taken: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '${myProvider.nowProtein.protein}gr',
                                        style: TextStyle(
                                            color: Color(0xfff27095),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text('Remaining: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(
                                        '${myProvider.kalanDaily}gr',
                                        style: TextStyle(
                                            color: Color(0xff70e1f1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff223D5D),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(16),
                      width: width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last 7 days :',
                            style: TextStyle(

                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                            future: myProvider.get7DaysState(),
                            builder:(context,snapshot)=> Container(
                              child: Last7DaysGraph(),
                              height: height*0.12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
