import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:flutter_protien_ez_controle/models/data_for_sql.dart';
import 'package:flutter_protien_ez_controle/screens/premium_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AddMealScreen extends StatefulWidget {
  static String id = 'AddMealScreen';
  final Meal meal;
  const AddMealScreen({Key key,this.meal}) : super(key: key);

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final key = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String color='teal';
  Color appBarColor=Colors.teal;
  RewardedAd myRewarded;
  int _numRewardedLoadAttempts = 0;

  int maxFailedLoadAttempts = 9000;
  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-8571844432257036/2586187895',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            myRewarded = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            myRewarded = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (myRewarded == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    myRewarded.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    myRewarded.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      if(widget.meal==null) {
        Provider.of<Data>(context, listen: false).addMeal(Meal(
            name: nameController.text,
            protein: int.parse(proteinController.text),
            description: descriptionController.text,
            color: color));
      }else{
        Provider.of<Data>(context, listen: false).updateMeal(Meal(
            name: nameController.text,
            id: widget.meal.id,
            protein: int.parse(proteinController.text),
            description: descriptionController.text,
            color: color));
      }
      Navigator.pop(context);
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    myRewarded = null;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createRewardedAd();
    if(widget.meal!=null){
      nameController=TextEditingController(text: widget.meal.name);
      proteinController=TextEditingController(text: widget.meal.protein.toString());
      descriptionController=TextEditingController(text: widget.meal.description);
      color=widget.meal.color;
      if(color=='pink'){
        appBarColor=Colors.pink;
      }else if(color=='teal'){
        appBarColor=Colors.teal;
      }else if(color=='orange'){
        appBarColor=Colors.orange;
      }else if(color=='blue'){
        appBarColor=Colors.blue;
      }else if(color=='cyan'){
        appBarColor=Colors.cyan;
      }else if(color=='purple'){
        appBarColor=Colors.purple;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        actions: [IconButton(icon:widget.meal==null?Icon(Icons.add):Icon(Icons.done), onPressed: () {
          if (key.currentState.validate()){
            if( Provider.of<Data>(context, listen: false).isPurchased) {
              if (widget.meal == null) {
                Provider.of<Data>(context, listen: false).addMeal(
                    Meal(
                        name: nameController.text,
                        protein: int.parse(proteinController.text),
                        description: descriptionController.text,
                        color: color));
              } else {
                Provider.of<Data>(context, listen: false).updateMeal(
                    Meal(
                        name: nameController.text,
                        id: widget.meal.id,
                        protein: int.parse(proteinController.text),
                        description: descriptionController.text,
                        color: color));
              }
              Navigator.pop(context);
            }else{
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Premium Feature',
                        style: TextStyle(
                            color: MyColors.accentColor,
                            fontWeight: FontWeight.bold)),
                    content: Text(
                        'Watch an ad to add meal for free or you can upgrade premium'),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Go premium'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, PremiumScreen.id)
                              .then((value) => setState(() {}));
                        },
                      ),
                      TextButton(
                        child: Text(
                          'watch ad'.toUpperCase(),
                          style: TextStyle(
                              color: MyColors.accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showRewardedAd();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }},)],
        iconTheme: Provider.of<Data>(context).darkTheme?ThemeData.dark().iconTheme:ThemeData.dark().iconTheme,
        brightness: Brightness.dark,
        backgroundColor: appBarColor,
        title: Text(widget.meal==null?'Add Meal':'Update Meal'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.4,
                child: TextFormField(
                  validator: (v){
                    if(v.isEmpty){
                      return 'please enter food name';
                    }
                    return null;
                  },
                  controller: nameController,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: MyColors.textColor),
                  maxLength: 24,
                  decoration: InputDecoration(
                    focusColor: appBarColor,
                    fillColor: appBarColor,
                    hoverColor: appBarColor,

                    labelStyle: TextStyle(color: appBarColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    labelText: 'Food name',
                    counterText: '',
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                width: width * 0.4,
                child: TextFormField(
                  validator: (v){
                    if(v.isEmpty ||int.parse(v)<1) return'please enter valid protein amount';
                    return null;
                  },
                  controller: proteinController,
                  maxLines: 1,
                  maxLength: 3,
                  style: TextStyle(color: MyColors.textColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusColor: appBarColor,
                    fillColor: appBarColor,
                    hoverColor: appBarColor,
                    labelStyle: TextStyle(color:appBarColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    labelText: 'Protein amount',
                    counterText: '',
                    hintText: '30g'
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: width * 0.8,
                child: TextFormField(
                  controller: descriptionController,
                  minLines: 2,
                  maxLines: 3,
                  maxLength: 80,
                  style: TextStyle(color: MyColors.textColor),    
                  decoration: InputDecoration(
                    focusColor: appBarColor,
                    fillColor: appBarColor,
                    hoverColor: appBarColor,
                    labelStyle: TextStyle(color: appBarColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: appBarColor),
                    ),
                    labelText: 'Description',

                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Color:',
                style: TextStyle(
                    color: MyColors.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: width*0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          color='pink';
                          appBarColor=Colors.pink; 
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Visibility(
                          visible: color=='pink',
                          child: Icon(Icons.done,color: Colors.white,),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                            color: Colors.pink),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          color='orange';
                          appBarColor=Colors.orange;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 30,
                        height: 30,
                        child: Visibility(
                          visible: color=='orange',
                          child: Icon(Icons.done,color: Colors.white,),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            color: Colors.orange),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          color='teal';
                          appBarColor=Colors.teal;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 30,
                        height: 30,
                        child: Visibility(
                          visible: color=='teal',
                          child: Icon(Icons.done,color: Colors.white,),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            color: Colors.teal),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          color='cyan';
                          appBarColor=Colors.cyan;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 30,
                        height: 30,
                        child: Visibility(
                          visible: color=='cyan',
                          child: Icon(Icons.done,color: Colors.white,),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            color: Colors.cyan),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          color='blue';
                          appBarColor=Colors.blue;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 30,
                        height: 30,
                        child: Visibility(
                          visible: color=='blue',
                          child: Icon(Icons.done,color: Colors.white,),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            color: Colors.blue),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          color='purple';
                          appBarColor=Colors.purple;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 30,
                        height: 30,
                        child: Visibility(
                          visible: color=='purple',
                          child: Icon(Icons.done,color: Colors.white,),
                        ),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                            color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Row(children: [
                Visibility(
                  visible: widget.meal!=null,
                  child: OutlinedButton(
                    onPressed: (){
                      if (key.currentState.validate()){

                          Provider.of<Data>(context, listen: false).deleteMeal(Meal(
                              name: nameController.text,
                              id: widget.meal.id,
                              protein: int.parse(proteinController.text),
                              description: descriptionController.text,
                              color: color));

                        Navigator.pop(context);
                      }
                    },
                    child: Text('DELETE MEAL'),style: OutlinedButton.styleFrom(primary: Colors.pink),),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: (){
                    if (key.currentState.validate()){
                      if( Provider.of<Data>(context, listen: false).isPurchased) {
                        if (widget.meal == null) {
                          Provider.of<Data>(context, listen: false).addMeal(
                              Meal(
                                  name: nameController.text,
                                  protein: int.parse(proteinController.text),
                                  description: descriptionController.text,
                                  color: color));
                        } else {
                          Provider.of<Data>(context, listen: false).updateMeal(
                              Meal(
                                  name: nameController.text,
                                  id: widget.meal.id,
                                  protein: int.parse(proteinController.text),
                                  description: descriptionController.text,
                                  color: color));
                        }
                        Navigator.pop(context);
                      }else{
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Premium Feature',
                                  style: TextStyle(
                                      color: MyColors.accentColor,
                                      fontWeight: FontWeight.bold)),
                              content: Text(
                                  'Watch an ad to add meal for free or you can upgrade premium'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Go premium'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, PremiumScreen.id)
                                        .then((value) => setState(() {}));
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'watch ad'.toUpperCase(),
                                    style: TextStyle(
                                        color: MyColors.accentColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showRewardedAd();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(widget.meal==null?'ADD MEAL':'UPDATE MEAL'),style: ElevatedButton.styleFrom(primary: appBarColor),),
                SizedBox(width: width*0.1,),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
