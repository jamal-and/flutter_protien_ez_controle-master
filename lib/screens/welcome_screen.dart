import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  int weight;
  final controller=TextEditingController();
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
                  height: height * 0.15,
                ),
                Text(
                  'Enter your weight below',
                  style: TextStyle(

                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 55,
                      width: width * 0.13,
                      child: TextField(
                        autofocus: true,
                        maxLength: 3,
                        controller: controller,
                        onChanged: (v){
                          if(v.isNotEmpty){
                            print(v);
                            print(controller.text);
                            weight=int.parse(v);
                          }
                        },

                          style: TextStyle(fontSize: 24),
                          cursorColor: Color(0xff20B8F3),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 24),

                            hintText: '70',
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
                    Container(height: 55,child: MyDropDown()),
                  ],
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                Container(

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff20B8F3),padding: EdgeInsets.symmetric(vertical: 8,horizontal: 32)),
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

class MyDropDown extends StatefulWidget {
  const MyDropDown({
    Key key,
  }) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String dropValue='kg';
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropValue,
      onChanged: (String newValue)async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          dropValue=newValue;
          if(newValue=='kg'){
            prefs.setBool('kg', true);
          }else{
            prefs.setBool('kg', false);
          }
        });
      },

      style: TextStyle(fontSize: 24),

      underline: Container(height: 0.6,color: Color(0xff20B8F3),),

      items:<String>['kg','Ibs'].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),);
  }
}
