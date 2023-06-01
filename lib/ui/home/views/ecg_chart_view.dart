import 'package:ehealth/ui/ecg/bloc/add_ecg_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_chart_bloc.dart';
import 'package:ehealth/ui/home/views/one_line_chart_view_ecg.dart';
import 'package:ehealth/ui/home/views/two_line_chart_view.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcgChartView extends StatelessWidget {
  const EcgChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return _Stateful();
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
    return BlocBuilder<EcgBloc, EcgState>(builder: (context, state) {
      return ListView(
        padding: const EdgeInsets.only(left: m1, right: m1, top: m1, bottom: m5),
        children: [
          OneLineChartViewEcg(state.ecg.ecgData,ECG_CHART),
        ],
      );
    });
  }
}
