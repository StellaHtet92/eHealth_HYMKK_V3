import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/ui/home/bloc/vital_chart_bloc.dart';
import 'package:ehealth/ui/home/views/one_line_chart_view.dart';
import 'package:ehealth/ui/home/views/two_line_chart_view.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalChartView extends StatelessWidget {
  const VitalChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VitalChartBloc(VitalRepo())..add(Init()),
      child: _Stateful(),
    );
  }
}

class _Stateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Stateful> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VitalChartBloc, VitalChartState>(builder: (context, state) {
      return ListView(
        padding: const EdgeInsets.only(left: m1, right: m1, top: m1, bottom: m5),
        children: [
          OneLineChartView(state.result,EWS_CHART),
          OneLineChartView(state.result,TEMP_CHART),
          TwoLineChartView(state.result,BLOOD_PRESSURE_CHART),
          OneLineChartView(state.result,SPO2_CHART),
          OneLineChartView(state.result,PULSE_CHART),
          OneLineChartView(state.result,GLUCO_CHART),
          TwoLineChartView(state.result,COL_CHART),
          OneLineChartView(state.result,HEART_RATE_CHART),
        ],
      );
    });
  }
}
