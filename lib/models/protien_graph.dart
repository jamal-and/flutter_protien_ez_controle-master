import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProteinGraph extends StatefulWidget {
  final double height;
  ProteinGraph(this.height);
  @override
  _ProteinGraphState createState() => _ProteinGraphState(height);
}
int touchedIndex;
class _ProteinGraphState extends State<ProteinGraph> {
final double myH;
_ProteinGraphState(this.myH);
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        borderData: FlBorderData(show: false,),
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        sections: showingSection(),
      )
    );
  }
  List<PieChartSectionData> showingSection(){
    var myProvider=Provider.of<Data>(context);
    double takePer=(myProvider.nowProtein.protein/myProvider.proteinDaily)*100;
    double kalanPer=(myProvider.kalanDaily/myProvider.proteinDaily)*100;
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : myH*0.024;
      final double radius = isTouched ? 80 : myH*0.125;
      switch(i){
        case 0:
          return PieChartSectionData(
            color: Color(0xff243C5E),
            value: myProvider.kalanDaily.toDouble(),
            title: myProvider.kalanDaily.toDouble() ==myProvider.proteinDaily.toDouble()?'let\'s Start':myProvider.kalanDaily.toDouble()==0?'Done!':'%${kalanPer.toStringAsFixed(0)}',
            radius: radius,
            titleStyle:myProvider.kalanDaily.toDouble()==0?GoogleFonts.lato(textStyle:TextStyle(fontSize: fontSize,color: Color(0xffffffff),fontWeight: FontWeight.bold) ):GoogleFonts.lato(textStyle: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold,color: Colors.white,)) ,


          );
        case 1:
          return PieChartSectionData(
              color: const Color(0xffF27095),
              value: myProvider.nowProtein.protein.toDouble(),
              title: myProvider.nowProtein.protein==0?'':'%${takePer.toStringAsFixed(0)}',
              radius: radius,
              titleStyle: GoogleFonts.lato(textStyle:TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
    )
          );
        default:
          return null;
      }
      });
  }
}
