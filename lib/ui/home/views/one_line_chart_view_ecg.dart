import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OneLineChartViewEcg extends StatelessWidget {
  final List<Ecg> items;
  final String title;

  const OneLineChartViewEcg(this.items, this.title, {super.key});

  mapper(Ecg ecg) {
    switch (title) {
      case ECG_CHART:
        return ecg.ecg;
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
        series: <ChartSeries<Ecg, String>>[
          LineSeries<Ecg, String>(
            dataSource: items,
            xValueMapper: (Ecg ecg, _) => changeDateTimeFormatForGraph(ecg.ecg),
            yValueMapper: (Ecg ecg, _) => mapper(ecg),
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
