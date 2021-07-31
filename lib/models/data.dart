import 'package:flutter/foundation.dart';
import 'sql_commands.dart';
import 'data_for_sql.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Data extends ChangeNotifier {

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
  List<SingleProtein> items=[SingleProtein(number: 0,text: 'Nothing to show')];
  String kg='kg!';
  DateTime now = DateTime.now();

  // final DateTime dateTime=DateTime.parse(now);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
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

  Future<Protein> getWeight() async {
    now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('image')!=null){
      imagePath=prefs.getString('image');
    }
    if(prefs.getString('name')!=null){
      userName=prefs.getString('name');
    }
    if(prefs.getBool('kg')==null){
      prefs.setBool('kg', true);
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

  addProtein(int addedProtein,String text) async {
    getWeight();
    kalanDaily = proteinDaily - (nowProtein.protein + addedProtein);
    final String formatted = formatter.format(now);
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
      await MakeCommand.insertProtein(Protein(
          date: formatted,
          weight: weight,
          protein: (nowProtein.protein + addedProtein),
          isDone: 0));

    await MakeCommand.addSingleProtein(SingleProtein(
        date: formatted,
        number: addedProtein,
        text: text));
      nowProtein = await MakeCommand.proteins(now);
      proteinTake = proteinTake + addedProtein;
      await MakeCommand.deleteProteins(DateTime.now().subtract(Duration(days: 7)));
      await getSingleProteins();
      notifyListeners();
  }

  Future<List<SingleProtein>> getSingleProteins() async{
    items= await MakeCommand.singleProteins();
    //items=items.reversed.toList();
    //print(items.length);
    return items;

  }

  get7DaysState() async {
    try {
      items= await MakeCommand.singleProteins();
      print('${items.length} kk');
      nowProtein = await MakeCommand.proteins(DateTime.now());
      protein1 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 1)));
      protein2 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 2)));
      protein3 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 3)));
      protein4 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 4)));
      protein5 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 5)));
      protein6 = await MakeCommand.proteins(
          DateTime.now().subtract(Duration(days: 6)));
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
