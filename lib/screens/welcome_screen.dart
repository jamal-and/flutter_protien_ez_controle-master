import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  int weight;
  static String id = 'welcome_screen';
  static void getPrefs(context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('weight')!=null){
      if((await Provider.of<Data>(context,listen: false).getWeight())!=null){
      }
      // await Provider.of<Data>(context,listen: false).getWeight();
      // await Provider.of<Data>(context,listen: false).get7DaysState();
      Navigator.pushReplacementNamed(context, MainScreen.id);
    }
  }
  @override
  Widget build(BuildContext context) {
    getPrefs(context);

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
                  height: height * 0.1,
                ),
                Text(
                  'Welcome',
                  style: TextStyle(
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),

                Container(
                  width: width * 0.8,
                  child: TextField(
                    onChanged: (v){
                      if(v.isNotEmpty){
                        print(v);
                        weight=int.parse(v);
                      }
                    },
                      style: TextStyle(fontSize: 30),
                      cursorColor: Color(0xff70E1F1),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Enter your weight here',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      )),
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                Container(

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff70E1F1),padding: EdgeInsets.symmetric(vertical: 8,horizontal: 32)),
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      try{
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
                    child: Text('Go!',style: TextStyle(fontSize: 24),),
                  ),
                ),
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
