import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_protien_ez_controle/models/colors.dart';
import 'sql_commands.dart';
import 'data_for_sql.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Data extends ChangeNotifier {
  bool hasFreeTrial=true;

  bool  darkTheme=true;

void switchTheme(bool a)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setBool('dark',a);
    MyColors.defaultMode=a;
    darkTheme=a;
    notifyListeners();
}

  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool available = true;
  StreamSubscription subscription;
  final String myProductID = 'pro_tracker';


  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;
  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }




  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }


  List _products = [];
  List get products => _products;
  set products(List value) {
    _products = value;
    notifyListeners();
  }



  Future<void> initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      await _getPastPurchases();
      verifyPurchase();
      subscription = _iap.purchaseUpdatedStream.listen((data) {
        purchases.addAll(data);
        verifyPurchase();
      });
    }
  }


  void verifyPurchase() async{
    PurchaseDetails purchase = hasPurchased(myProductID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        if (purchase != null && purchase.status == PurchaseStatus.purchased) {
          isPurchased = true;
          SharedPreferences preferences=await SharedPreferences.getInstance();
          preferences.setBool('free', false);
        }
      }

    }
  }


  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere((purchase) => purchase.productID == productID);
  }



  Future<void> _getProducts() async {
    Set<String> ids = Set.from([myProductID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }


  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.consumePurchase(purchase);
      }
    } purchases = response.pastPurchases;

  }


  Protein nowProtein=Protein(protein: 0,weight: 0,isDone: 0),
      protein1 = Protein(protein: 0),
      protein2 = Protein(protein: 0),
      protein3 = Protein(protein: 0),
      protein4 = Protein(protein: 0),
      protein5 = Protein(protein: 0),
      protein6 = Protein(protein: 0);
  int weight = 0;
  int proteinDaily=1;
  int proteinWillBeAdded;
  int kalanDaily=1;
  int proteinTake = 0;
  String imagePath;
  String userName;
  List<SingleProtein> items=[];
  String kg='kg!';
  DateTime now = DateTime.now();

  // final DateTime dateTime=DateTime.parse(now);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterHour = DateFormat('HH:mm:ss');
  setImagePath(String path)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('image', path);
    imagePath=path;
    notifyListeners();
  }
  setGoal(int goal)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('goal', goal);
    proteinDaily=goal;

    notifyListeners();
  }
  setName(String name)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    userName=name;
    notifyListeners();
  }
  Future<String> getDefaultGoal() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('kg')) {
      return (weight * 2.1).toInt().toString();
    }else{
      return (weight).toInt().toString();
    }
}

  Future<Protein> getWeight() async {
    now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('dark')!=null){
      MyColors.defaultMode=prefs.getBool('dark');
      darkTheme=prefs.getBool('dark');
    }
    if(prefs.getBool('free')!=null){
      hasFreeTrial=false;
    }
    if(prefs.getString('image')!=null){
      imagePath=prefs.getString('image');
    }
    if(prefs.getString('name')!=null){
      userName=prefs.getString('name');
    }
    if(prefs.getBool('kg')==null){
      prefs.setBool('kg', false);
    }
    int goal =prefs.getInt('goal');
    final String formatted = formatter.format(now);
    nowProtein = await MakeCommand.proteins(now);
    if (nowProtein.weight!=0) {
      weight = nowProtein.weight;
      if(prefs.getBool('kg')) {
        kg='kg';
        goal==null ?proteinDaily = (weight * 2.1).toInt():proteinDaily=goal;
      }else{
        kg='Ibs';
        goal==null ?proteinDaily = (weight).toInt():proteinDaily=goal;
      }
    } else {
      await MakeCommand.insertProtein(Protein(
          date: formatted, weight: prefs.getInt('weight'), protein: 0, isDone: 0));
      nowProtein = await MakeCommand.proteins(now);
      weight = nowProtein.weight;
      get7DaysState();
    }
    kalanDaily = proteinDaily - nowProtein.protein;
    return nowProtein;
  }
  setKg(String s)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int goal =prefs.getInt('goal');
    kg=s;
    if(s=='kg') {

      kg='kg';
      goal==null ?proteinDaily = (weight * 2.1).toInt():proteinDaily=goal;
    }else{
      kg='Ibs';
      goal==null ?proteinDaily = (weight).toInt():proteinDaily=goal;
    }
    final String formatted = formatter.format(now);
    nowProtein = await MakeCommand.proteins(now);
    MakeCommand.insertProtein(Protein(
      date: formatted,
      weight: weight,
      protein: nowProtein.protein,
      isDone: 0,
    ));
    nowProtein = await MakeCommand.proteins(now);
    notifyListeners();
  }
  setWeight(newWeight) async {
    final String formatted = formatter.format(now);
    if (weight != 0) {
      MakeCommand.insertProtein(Protein(
        date: formatted,
        weight: newWeight,
        protein: 0,
        isDone: 0,
      ));
      nowProtein = await MakeCommand.proteins(now);
      weight = nowProtein.weight;
    } else {
      MakeCommand.insertProtein(Protein(
        date: formatted,
        weight: 0,
        protein: 0,
        isDone: 0,
      ));
      weight = 0;
    }

    notifyListeners();
  }
  editWeight(newWeight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('weight', newWeight);
    final String formatted = formatter.format(now);
    nowProtein = await MakeCommand.proteins(now);
    MakeCommand.insertProtein(Protein(
      date: formatted,
      weight: newWeight,
      protein: nowProtein.protein,
      isDone: 0,
    ));
    nowProtein = await MakeCommand.proteins(now);
    weight = nowProtein.weight;

    notifyListeners();
  }
  updateSingleProtein({String text,int number,String hour,String date})async{

    await MakeCommand.updateSingleProtein(SingleProtein(
        date: date,
        number: number,
        hour: hour,
        text: text));
    int x=await allproteins();
    await MakeCommand.insertProtein(Protein(
        date: date,
        weight: weight,
        protein: (x),
        isDone: 0));
    nowProtein = await MakeCommand.proteins(now);
    await getSingleProteins();
    notifyListeners();
  }
  addProtein(int addedProtein,String text) async {
    getWeight();
    kalanDaily = proteinDaily - (nowProtein.protein + addedProtein);
    final String formatted = formatter.format(now);
    final String formatted2 = formatterHour.format(now);
    //nowProtein = await MakeCommand.proteins(now);
    if (kalanDaily < 0) {
      kalanDaily = 0;
    }
    // if ((nowProtein.protein + addedProtein) >= proteinDaily) {
    //   await MakeCommand.insertProtein(Protein(
    //       date: formatted,
    //       weight: weight,
    //       protein: proteinDaily,
    //       isDone:  1));
    //   await MakeCommand.deleteProteins(DateTime.now().subtract(Duration(days: 7)));
    //   nowProtein = await MakeCommand.proteins(now);
    //   proteinTake = proteinDaily;
    // }else{


    await MakeCommand.addSingleProtein(SingleProtein(
        date: formatted,
        number: addedProtein,
        hour: formatted2,
        text: text));
    int x=await allproteins();
    await MakeCommand.insertProtein(Protein(
        date: formatted,
        weight: weight,
        protein: (x),
        isDone: 0));
      nowProtein = await MakeCommand.proteins(now);
      proteinTake = proteinTake + addedProtein;
      await MakeCommand.deleteProteins(DateTime.now().subtract(Duration(days: 7)));
      await getSingleProteins();
      notifyListeners();
  }
  addProteinWithDate(int addedProtein,String date) async {
    getWeight();
    Protein dayProtein=await MakeCommand.proteins(DateTime.parse(date));
    await MakeCommand.insertProtein(Protein(
        date: date,
        weight: weight,
        protein: (dayProtein.protein + addedProtein),
        isDone: 0));
    dayProtein=await MakeCommand.proteins(DateTime.parse(date));
    await MakeCommand.deleteProteins(DateTime.now().subtract(Duration(days: 7)));
    notifyListeners();
  }
  Future<List<SingleProtein>> getSingleProteins() async{
    items= await MakeCommand.singleProteins();
    //items=items.reversed.toList();
    //print(items.length);
    return items;

  }
  Future<int> allproteins()async{
    int x=await MakeCommand.countSingeProteins();
    print('ALL PRO IS $x');
    return x;
  }
  deleteDismiss(String text,int number,String hour)async{
    final String formatted = formatter.format(now);

    await MakeCommand.deleteSingleProtein(text, number,hour);
    int x= await allproteins()??0;
    await  MakeCommand.insertProtein(Protein(
        date: formatted,
        weight: weight,
        protein: (x),
        isDone: 0));
    nowProtein=await MakeCommand.proteins(now)??Protein(date: formatted,weight: weight,protein: 0,isDone: 0);
    notifyListeners();
  }

  get7DaysState() async {
    try {
      print('getting data 7');
      items= await MakeCommand.singleProteins();
      protein6 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 6)));
      protein5 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 5)));
      protein4 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 4)));
      protein3 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 3)));
      protein2 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 2)));
      protein1 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 1)));
      nowProtein = await MakeCommand.proteins(DateTime.now());
      print('done 7');
    } catch (e) {
      print(e);
    }

    // if(nowProtein.protein!=null) {
    //
    // }if (protein1.protein != null) {
    //   print(protein1.protein);
    // } if (protein2.weight != null) {
    //   print(protein2.protein);
    // } if (protein3.weight!= null) {
    //   print(protein3.protein);
    // } if (protein4.weight!= null) {
    //   print(protein4.protein);
    // } if (protein5.weight!= null) {
    //   print(protein5.protein);
    // } if (protein6.weight!=null) {
    //   print(protein6.protein);
    // } else {
    //   print('all null ');
    // }
  }
}
