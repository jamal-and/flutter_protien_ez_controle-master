import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  static void getPrefs(context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('weight')!=null){
      if((await Provider.of<Data>(context,listen: false).getWeight())!=null){
      }
      // await Provider.of<Data>(context,listen: false).getWeight();
      // await Provider.of<Data>(context,listen: false).get7DaysState();
      //Navigator.pushReplacementNamed(context, MainScreen.id);
    }
    if(prefs.getBool('kg')==null){
      prefs.setBool('kg', true);
    }
  }

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int weight;

  bool kg=false;

  final controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    WelcomeScreen.getPrefs(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff0E284D),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.15,
                ),
                Text(
                  'Your current weight',
                  style: TextStyle(

                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('kg', false);
                        setState(() {

                          kg=false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                          color: kg?Color(0xff0E284D):Colors.blue,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50))
                        ),
                        child: Text('LBS',style: TextStyle(fontSize: 16),),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('kg', true);
                        setState(() {

                          kg=true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            color: kg?Colors.blue:Color(0xff0E284D),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50))
                        ),
                        child: Text('KG',style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(kg?'kg':'lbs',style: TextStyle(fontSize: 30,color:Color(0xff0E284D) ),),
                    Container(

                      width: width * 0.33,
                      child: TextField(
                        autofocus: true,
                        maxLength: 3,

                        maxLines: 1,
                        controller: controller,
                        onChanged: (v){
                          if(v.isNotEmpty){
                            print(v);
                            print(controller.text);
                            weight=int.parse(v);
                          }
                        },

                          style: TextStyle(fontSize: 44),
                          cursorColor: Color(0xff20B8F3),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            hintStyle: TextStyle(fontSize: 44),

                            hintText: '',
                            contentPadding: EdgeInsets.zero,

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff20B8F3)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff20B8F3)),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff20B8F3)),
                            ),
                          )),
                    ),
                    SizedBox(width: 5,),
                    Text(kg?'kg':'lbs',style: TextStyle(fontSize: 30),),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: ()async{
                    if(controller.text==null || controller.text.isEmpty)
                    {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "Please Enter Your Weight.",
                        ),
                      );
                      return;
                    }
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    try{
                      prefs.setBool('kg', kg);
                      //await MakeCommand.insertProtein(newweight);
                      print('setting weight..');
                      await Provider.of<Data>(context,listen: false).setWeight(weight);
                      print('getting 7 days..');
                      await Provider.of<Data>(context,listen: false).get7DaysState();
                      print(weight);
                      prefs.setInt('weight', weight);


                      Navigator.pushReplacementNamed(context, MainScreen.id);
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Container(
                    width: width*0.8,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: [Color(0xff20B8F3),Color(0xff20B8F3)])
                    ),
                    child: Center(child: Text('NEXT',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                  ),
                ),
                SizedBox(height: height*0.05,)
                // Container(
                //
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(primary: Color(0xff70E1F1),padding: EdgeInsets.symmetric(vertical: 8,horizontal: 32)),
                //     onPressed: () async{
                //         await Provider.of<Data>(context,listen: false).getWeight();
                //         await Provider.of<Data>(context,listen: false).get7DaysState();
                //         Navigator.pushReplacementNamed(context, MainScreen.id);
                //     },
                //     child: Text('Skip!',style: TextStyle(fontSize: 14),),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
