import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../util/method.dart';

class TwoLineChartView extends StatelessWidget {
  final List<Vital> items;
  final String title;

  const TwoLineChartView(this.items, this.title, {super.key});

  mapperOne(Vital v) {
    switch (title) {
      case BLOOD_PRESSURE_CHART:
        return v.bpSys;
      case COL_CHART:
        return v.hdl;
      default:
        return '0';
    }
  }

  mapperTwo(Vital v) {
    switch (title) {
      case BLOOD_PRESSURE_CHART:
        return v.bpDia;
      case COL_CHART:
        return v.ldl;
      default:
        return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: SfCartesianChart(
        enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(isVisible: false),
        primaryYAxis: NumericAxis(),
        title: ChartTitle(text: title, textStyle: const TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: 'Date',
          format: 'point.x',
        ),
        series: <ChartSeries<Vital, String>>[
          LineSeries<Vital, String>(
            dataSource: items,
            xValueMapper: (Vital v, _) => changeDateTimeFormatForGraph(v.createdDateTime ?? ""),
            yValueMapper: (Vital v, _) => mapperOne(v),
            color: Colors.blue,
            markerSettings: MarkerSettings(isVisible: true, height: 3, width: 3, shape: DataMarkerType.circle, borderWidth: 3, borderColor: Colors.blue[900]),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
          LineSeries<Vital, String>(
            dataSource: items,
            xValueMapper: (Vital v, _) => changeDateTimeFormatForGraph(v.createdDateTime ?? ""),
            yValueMapper: (Vital v, _) => mapperTwo(v),
            color: Colors.green,
            markerSettings: MarkerSettings(isVisible: true, height: 3, width: 3, shape: DataMarkerType.circle, borderWidth: 3, borderColor: Colors.green[900]),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}
