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
  DateTime now = DateTime.now();

  // final DateTime dateTime=DateTime.parse(now);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<Protein> getWeight() async {
    now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String formatted = formatter.format(now);
    nowProtein = await MakeCommand.proteins(now);
    if (nowProtein.weight!=0) {
      weight = nowProtein.weight;

      proteinDaily = (weight * 2.1).toInt();
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

  addProtein(int addedProtein) async {
    getWeight();
    kalanDaily = proteinDaily - (nowProtein.protein + addedProtein);
    final String formatted = formatter.format(now);
    //nowProtein = await MakeCommand.proteins(now);
    if (kalanDaily < 0) {
      kalanDaily = 0;
    }
    if ((nowProtein.protein + addedProtein) >= proteinDaily) {
      await MakeCommand.insertProtein(Protein(
          date: formatted,
          weight: weight,
          protein: proteinDaily,
          isDone:  1));
      await MakeCommand.deleteProteins(DateTime.now().subtract(Duration(days: 7)));
      nowProtein = await MakeCommand.proteins(now);
      proteinTake = proteinDaily;
    }else{
      await MakeCommand.insertProtein(Protein(
          date: formatted,
          weight: weight,
          protein: (nowProtein.protein + addedProtein),
          isDone: 0));
      nowProtein = await MakeCommand.proteins(now);
      proteinTake = proteinTake + addedProtein;
      await MakeCommand.deleteProteins(DateTime.now().subtract(Duration(days: 7)));
    }
    notifyListeners();
  }

  get7DaysState() async {
    try {
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
