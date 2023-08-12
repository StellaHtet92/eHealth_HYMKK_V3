import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OneLineChartViewEcg extends StatelessWidget {
  final List<EcgForChart> items;
  final String title;

  const OneLineChartViewEcg(this.items, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return
      //SizedBox(
     // height: 100,
     // child:
      SfCartesianChart(
        primaryXAxis: CategoryAxis(isVisible: false),
        primaryYAxis: NumericAxis(),
        title: ChartTitle(text: title, textStyle: const TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold), alignment: ChartAlignment.near),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: '',
          format: 'point.x',
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
        ),
        series: <ChartSeries<EcgForChart, int>>[
          FastLineSeries<EcgForChart, int>(
            dataSource: items,
            xValueMapper: (EcgForChart ecg, _) => ecg.key,
            yValueMapper: (EcgForChart ecg, _) => ecg.value,
            name: title,
            color: Colors.green,
            markerSettings: MarkerSettings(isVisible: false, height: 3, width: 3, shape: DataMarkerType.circle, borderWidth: 3, borderColor: Colors.green[900]),
            dataLabelSettings: const DataLabelSettings(isVisible: false),
          )
        ],
      );
   // );
  }
}

class EcgForChart{
  final int key;
  final int value;

  EcgForChart(this.key,this.value);
}