import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OneLineChartView extends StatelessWidget {
  final List<Vital> items;
  final String title;

  const OneLineChartView(this.items, this.title, {super.key});

  mapper(Vital v) {
    switch (title) {
      case EWS_CHART:
        return v.ews;
      case TEMP_CHART:
        return v.temp;
      case SPO2_CHART:
        return v.spO2;
      case PULSE_CHART:
        return v.pulse;
      case GLUCO_CHART:
        return v.bloodSugarLevel;
      case HEART_RATE_CHART:
        return v.heartRate;
      default:
        return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: SfCartesianChart(
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
            xValueMapper: (Vital v, _) => changeDateTimeFormatForGraph(v.createdDateTime),
            yValueMapper: (Vital v, _) => mapper(v),
            name: title,
            color: Colors.green,
            markerSettings: MarkerSettings(isVisible: true, height: 3, width: 3, shape: DataMarkerType.circle, borderWidth: 3, borderColor: Colors.green[900]),
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}
