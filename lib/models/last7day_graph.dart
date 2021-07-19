import 'package:flutter_protien_ez_controle/models/data.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class Last7DaysGraph extends StatefulWidget {
  @override
  _Last7DaysGraphState createState() => _Last7DaysGraphState();
}

class _Last7DaysGraphState extends State<Last7DaysGraph> {

  @override
  Widget build(BuildContext context) {

    var myProvider=Provider.of<Data>(context);
    myProvider.get7DaysState();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          enabled: false,

          touchTooltipData: BarTouchTooltipData(
            tooltipMargin: 0,
            tooltipPadding: EdgeInsets.zero,
            tooltipBgColor: Colors.transparent,
            getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
                ) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              );
            },
          )
        ),
        maxY: Provider.of<Data>(context).proteinDaily.toDouble(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (v)=>TextStyle(color: Colors.white),
            margin: 20,
            getTitles: (double v){
              switch (v.toInt()){
                case 1:
                  return 'Mn';
                case 2:
                  return 'Te';
                case 3:
                  return 'Wd';
                case 4:
                  return 'Tu';
                case 5:
                  return 'Fr';
                case 6:
                  return 'St';
                case 7:
                  return 'Sn';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          show: false,
        ),
         barGroups: getSections()//[
        //   BarChartGroupData(
        //     x: ((now.subtract(Duration(days: 5))).weekday),
        //     barRods: [
        //       BarChartRodData(y: myProvider.protein5.protein.toDouble(), colors: [Colors.lightBlue,Color(0xff6FE1F0)])
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
        //   BarChartGroupData(
        //     x: ((now.subtract(Duration(days: 4))).weekday),
        //     barRods: [
        //       BarChartRodData(y: myProvider.protein4.protein.toDouble(), colors: [Colors.lightBlue,Color(0xff6FE1F0)])
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
        //   BarChartGroupData(
        //     x: ((now.subtract(Duration(days: 3))).weekday),
        //     barRods: [
        //       BarChartRodData(y: myProvider.protein3.protein.toDouble(), colors: [Colors.lightBlue,Color(0xff6FE1F0)])
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
        //   BarChartGroupData(
        //     x: ((now.subtract(Duration(days: 2))).weekday),
        //     barRods: [
        //       BarChartRodData(y: myProvider.protein2.protein.toDouble(), colors: [Colors.lightBlue,Color(0xff6FE1F0)])
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
        //   BarChartGroupData(
        //     x: ((now.subtract(Duration(days: 1))).weekday),
        //     barRods: [
        //       BarChartRodData(y: myProvider.protein1.protein.toDouble(), colors: [Colors.lightBlue,Color(0xff6FE1F0)])
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
        //   BarChartGroupData(
        //     x: now.weekday,
        //     barRods: [
        //       BarChartRodData(y: myProvider.nowProtein.protein.toDouble(),
        //           colors: [ Colors.lightBlue,Color(0xff6FE1F0),])
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
        // ],
      )
    );

  }
  List<BarChartGroupData> getSections(){
    var myProvider=Provider.of<Data>(context);
    myProvider.get7DaysState();
    DateTime now=DateTime.now();
    return [
      BarChartGroupData(
        x: ((now.subtract(Duration(days: 6))).weekday),
        barRods: [
          BarChartRodData(y: myProvider.protein6.protein.toDouble(), colors: ((myProvider.protein6.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: ((now.subtract(Duration(days: 5))).weekday),
        barRods: [
          BarChartRodData(y: myProvider.protein5.protein.toDouble(), colors: ((myProvider.protein5.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: ((now.subtract(Duration(days: 4))).weekday),
        barRods: [
          BarChartRodData(y: myProvider.protein4.protein.toDouble(), colors: ((myProvider.protein4.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: ((now.subtract(Duration(days: 3))).weekday),
        barRods: [
          BarChartRodData(y: myProvider.protein3.protein.toDouble(), colors: ((myProvider.protein3.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: ((now.subtract(Duration(days: 2))).weekday),
        barRods: [
          BarChartRodData(y: myProvider.protein2.protein.toDouble(), colors: ((myProvider.protein2.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: ((now.subtract(Duration(days: 1))).weekday),
        barRods: [
          BarChartRodData(y: myProvider.protein1.protein.toDouble(), colors: ((myProvider.protein1.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: now.weekday,
        barRods: [
          BarChartRodData(y: myProvider.nowProtein.protein.toDouble(),
              colors: ((myProvider.nowProtein.protein)==(myProvider.proteinDaily))?[Colors.pinkAccent[100],Color(0xfff27095)]:[Colors.lightBlue,Color(0xff6FE1F0)])
        ],
        showingTooltipIndicators: [0],
      ),
    ];
  }
}
