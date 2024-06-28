// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthup/constants/front_constants.dart';

class FirestoreBarChart extends StatefulWidget {
  final String userId;

  FirestoreBarChart({required this.userId});

  @override
  _FirestoreBarChartState createState() => _FirestoreBarChartState();
}

class _FirestoreBarChartState extends State<FirestoreBarChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<BarChartGroupData> _data = [];
  double _maxY = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot caloriesSnapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('dailyCalories')
          .get();

      QuerySnapshot waterSnapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('dailyWaterIntake')
          .get();

      Map<int, double> monthlyCalories = {};
      Map<int, double> monthlyWater = {};

      for (var doc in caloriesSnapshot.docs) {
        DateTime date = DateTime.parse(doc.id);
        int month = date.month;
        double totalCalories = doc['totalCalories'].toDouble();
        monthlyCalories.update(month, (value) => value + totalCalories,
            ifAbsent: () => totalCalories);
      }

      for (var doc in waterSnapshot.docs) {
        DateTime date = DateTime.parse(doc.id);
        int month = date.month;
        double totalWaterIntake = doc['totalWaterIntake'].toDouble();
        monthlyWater.update(month, (value) => value + totalWaterIntake,
            ifAbsent: () => totalWaterIntake);
      }

      double maxY = 0;
      List<BarChartGroupData> data = [];
      for (int month = 1; month <= 12; month++) {
        double calories = monthlyCalories[month] ?? 0;
        double water = monthlyWater[month] ?? 0;
        maxY = maxY < calories ? calories : maxY;
        maxY = maxY < water ? water : maxY;
        data.add(BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: calories,
              color: AppColors.primaryColor,
              width: 5,
              borderRadius: BorderRadius.zero,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 0,
                color: AppColors.primaryColor.withOpacity(0.2),
              ),
            ),
            BarChartRodData(
              toY: water,
              color: AppColors.secondaryColor,
              width: 5,
              borderRadius: BorderRadius.zero,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 0,
                color: AppColors.secondaryColor.withOpacity(0.2),
              ),
            ),
          ],
        ));
      }

      setState(() {
        _data = data;
        _maxY = maxY;
      });
    } catch (e) {
      print("Erro ao buscar dados: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _data.isEmpty
          ? CircularProgressIndicator()
          : BarChart(
              BarChartData(
                maxY: _maxY,
                barGroups: _data,
                borderData: FlBorderData(show: true),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: _maxY / 10,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _maxY / 10,
                      reservedSize: 35,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 1:
                            text = Text('Jan', style: style);
                            break;
                          case 2:
                            text = Text('Fev', style: style);
                            break;
                          case 3:
                            text = Text('Mar', style: style);
                            break;
                          case 4:
                            text = Text('Abr', style: style);
                            break;
                          case 5:
                            text = Text('Mai', style: style);
                            break;
                          case 6:
                            text = Text('Jun', style: style);
                            break;
                          case 7:
                            text = Text('Jul', style: style);
                            break;
                          case 8:
                            text = Text('Ago', style: style);
                            break;
                          case 9:
                            text = Text('Set', style: style);
                            break;
                          case 10:
                            text = Text('Out', style: style);
                            break;
                          case 11:
                            text = Text('Nov', style: style);
                            break;
                          case 12:
                            text = Text('Dez', style: style);
                            break;
                          default:
                            text = Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: text,
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 10,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {},
                  handleBuiltInTouches: true,
                ),
              ),
            ),
    );
  }
}
