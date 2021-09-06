import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/ads_manager.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({Key key,}) : super(key: key);
  static String id='personal_information';


  @override
  _PersonalInformationScreenState createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController weightController=TextEditingController();
  TextEditingController goalController;

  final key=GlobalKey<FormState>();
  bool kg=false;
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    var provider=Provider.of<Data>(context,listen: false);
    getPrefs(context);
    nameController=TextEditingController(text: provider.userName);
    emailController=TextEditingController(text: provider.email);
    weightController=TextEditingController(text: provider.weight.toString());
    goalController=TextEditingController(text: provider.proteinDaily.toString());
  }
  Future<bool> getPrefs(context)async{
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
    setState(() {
      kg=prefs.getBool('kg');
    });

    return prefs.getBool('kg');
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    var provider=Provider.of<Data>(context,listen: false);
    return Scaffold(

      appBar: AppBar(title: Text('Personal Information',style: TextStyle(color: MyColors.textColor),),backgroundColor: Colors.transparent,elevation: 0,iconTheme:Provider.of<Data>(context).darkTheme?ThemeData.dark().iconTheme: ThemeData.light().iconTheme,),
      backgroundColor: MyColors.background,
      body: Container(
          child: Form(
            key:key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  margin: EdgeInsets.only(left: 16,top: 16),
                  width: width*0.6,
                  child: TextFormField(
                    style: TextStyle(color: MyColors.textColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    maxLength: 18,
                    cursorColor: MyColors.accentColor,
                    controller: nameController,
                    decoration: InputDecoration(
                        focusColor: MyColors.accentColor,
                        fillColor: MyColors.accentColor,
                        hoverColor: MyColors.accentColor,
                        labelStyle: TextStyle(color:MyColors.accentColor ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.accentColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.accentColor),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.accentColor),
                        ),
                        icon: Icon(Icons.person_outline,color: MyColors.accentColor,),

                        labelText: 'Name',
                        counterText: '',
                        hintText: 'Enter your name'
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16,top: 16),
                  width: width*0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: MyColors.textColor),
                    validator: (value) {
                      if (value == null || value.isEmpty ||!value.contains('@')||!value.contains('.')) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    maxLength: 40,
                    cursorColor: MyColors.accentColor,
                    controller: emailController,
                    decoration: InputDecoration(
                        focusColor: MyColors.accentColor,
                        fillColor: MyColors.accentColor,
                        hoverColor: MyColors.accentColor,
                        labelStyle: TextStyle(color:MyColors.accentColor ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.accentColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.accentColor),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.accentColor),
                        ),
                        icon: Icon(Icons.email_outlined,color: MyColors.accentColor,),

                        labelText: 'Email',
                        counterText: '',
                        hintText: 'Enter your email'
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16,top: 16),
                      width: width*0.6,
                      child: TextFormField(
                        style: TextStyle(color: MyColors.textColor),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty||int.parse(value)<=0) {
                            return 'Please enter valid weight';
                          }
                          return null;
                        },
                        maxLength: 5,
                        cursorColor: MyColors.accentColor,
                        controller: weightController,
                        onChanged: (s){
                          if(kg){
                            goalController.text='${(int.parse(weightController.text)*2.1).toInt()}';
                          }else{
                            goalController.text='${int.parse(weightController.text)}';}
                        },
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color:MyColors.accentColor ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.accentColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.accentColor),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.accentColor),
                            ),
                          counterText: '',
                            focusColor: MyColors.accentColor,
                            fillColor: MyColors.accentColor,
                            hoverColor: MyColors.accentColor,
                            icon: Icon(Icons.monitor_weight_outlined,color: MyColors.accentColor,),
                            //border: OutlineInputBorder(borderSide: BorderSide(color: MyColors.accentColor),),
                            labelText: 'Weight',
                            hintText: 'Enter your weight'
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: ()async{
                                if(kg!=false) {
                                  SharedPreferences prefs = await SharedPreferences
                                      .getInstance();
                                  prefs.setBool('kg', false);
                                  setState(() {
                                    weightController.text =
                                    '${(double.parse(weightController.text) *
                                        2.20462262).roundToDouble().toInt()}';
                                    kg = false;
                                  });
                                }
                                if(kg){
                                  goalController.text='${(int.parse(weightController.text)*2.1).toInt()}';
                                }else{
                                  goalController.text='${int.parse(weightController.text)}';}
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: MyColors.accentColor),
                                    color: kg?MyColors.background:MyColors.accentColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5))
                                ),
                                child: Center(child: Text('LBS',style: TextStyle(fontSize: 14,color: MyColors.textColor,fontWeight: FontWeight.bold),)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: ()async{
                                if(!kg) {
                                  SharedPreferences prefs = await SharedPreferences
                                      .getInstance();
                                  prefs.setBool('kg', true);
                                  setState(() {
                                    weightController.text =
                                    '${(double.parse(weightController.text) *
                                        0.45359237).roundToDouble().toInt()}';
                                    kg = true;
                                  });
                                }
                                if(kg){
                                  goalController.text='${(int.parse(weightController.text)*2.1).toInt()}';
                                }else{
                                  goalController.text='${int.parse(weightController.text)}';}
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: MyColors.accentColor),
                                    color: kg?MyColors.accentColor:MyColors.background,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5))
                                 ),
                                child: Center(child: Text('KG',style: TextStyle(fontSize: 14,color: MyColors.textColor,fontWeight: FontWeight.bold),)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8,),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16,top: 16),
                      width: width*0.6,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty ||int.parse(value)<=0) {
                            return 'Please enter valid goal';
                          }
                          return null;
                        },
                        controller: goalController,
                        maxLength: 3,
                        cursorColor: MyColors.accentColor,

                        style: TextStyle(color: MyColors.textColor),
                        decoration: InputDecoration(

                            focusColor: MyColors.accentColor,
                            fillColor: MyColors.accentColor,
                            hoverColor: MyColors.accentColor,
                            labelStyle: TextStyle(color:MyColors.accentColor ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.accentColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.accentColor),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.accentColor),
                            ),
                          icon: Icon(Icons.adjust_outlined,color: MyColors.accentColor,),
                          counterText: '',

                            labelText: 'Goal',
                            hintText: 'Enter your goal'
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    OutlinedButton (
                      onPressed: (){
                      if(kg){
                        goalController.text='${(int.parse(weightController.text)*2.1).toInt()}';
                      }else{
                        goalController.text='${int.parse(weightController.text)}';
                      }
                    }, child: Text('Default goal',style: TextStyle(color: MyColors.accentColor),)
                    )],
                ),
                Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      if (key.currentState.validate()) {
                        provider.setName(nameController.text);
                        provider.setGoal(int.parse(goalController.text));
                        provider.editWeight(int.parse(weightController.text));
                        provider.setEmail(emailController.text);

                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      width: width*0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: MyColors.accentColor
                      ),
                      child:  Center(child: Text('Update',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),
                SizedBox(height: 32,)
              ],
            ),
          ),
      ),
    );
  }
}
