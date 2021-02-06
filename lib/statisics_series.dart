import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

class PercentageSeries {
  final int day;
  final int percentage;
  final charts.Color color;

  PercentageSeries({@required this.day, @required this.percentage, @required this.color});
}