import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/ui/home/bloc/vital_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VitalDataSource extends DataGridSource {
  VitalDataSource({required List<Vital> dataList}) {
    _dataList = buildDataGridRow(dataList: dataList);
  }

  List<DataGridRow> _dataList = [];

  @override
  List<DataGridRow> get rows => _dataList;

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  List<DataGridRow> buildDataGridRow({required List<Vital> dataList}) {
    return dataList
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<int>(columnName: VitalColId.id.name, value: e.id),
            DataGridCell<int>(columnName: VitalColId.serialNo.name, value: 1),
            DataGridCell<int>(columnName: VitalColId.ews.name, value: e.ews),
            DataGridCell<String>(columnName: VitalColId.bloodPressure.name, value: "${e.bpSys}/${e.bpDia}"),
            DataGridCell<String>(columnName: VitalColId.temp.name, value: "${e.temp}"),
            DataGridCell<String>(columnName: VitalColId.pulse.name, value: "${e.pulse}"),
            DataGridCell<String>(columnName: VitalColId.heartRate.name, value: "${e.heartRate}"),
            DataGridCell<String>(columnName: VitalColId.spo2.name, value: "${e.spO2}"),
            DataGridCell<String>(columnName: VitalColId.bloodSugar.name, value: "${e.bloodSugarLevel}"),
            DataGridCell<String>(columnName: VitalColId.mealStatus.name, value: e.isBeforeMeal ? "Before Meal" : "After Meal"),
            DataGridCell<String>(columnName: VitalColId.actions.name, value: ""),
          ]),
        )
        .toList();
  }

  addMoreRow({required List<Vital> dataList}) {
    _dataList.addAll(buildDataGridRow(dataList: dataList));
    notifyListeners();
  }

  removeRow({required int from, required int to}) {
    if (from < to) {
      _dataList.removeRange(from, to);
      notifyListeners();
    }
  }

  int getLength() {
    return _dataList.length;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (e.columnName != VitalColId.actions.name)
            ? Text(
                e.value.toString(),
                style: const TextStyle(fontWeight: FontWeight.normal),
              )
            : LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (builderContext) => AlertDialog(
                            title: const Text("Are you sure to delete?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                    BlocProvider.of<VitalListBloc>(context).add(OnVitalDelete(row.getCells()[0].value));
                                  },
                                  child: const Text("OK", style: TextStyle(color: Colors.green))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  },
                                  child: const Text("CANCEL", style: TextStyle(color: Colors.red)))
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                );
              }),
      );
    }).toList());
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(const Duration(seconds: 4));
  }
}

class VitalTable {
  final String colName;
  final String description;

  VitalTable({required this.colName, required this.description});
}

enum VitalColId { id, serialNo, ews, bloodPressure, temp, pulse, heartRate, spo2, bloodSugar, mealStatus, actions }

List<VitalTable> tableColumns = [
  VitalTable(colName: VitalColId.id.name, description: "Id"),
  VitalTable(colName: VitalColId.serialNo.name, description: "Serial No"),
  VitalTable(colName: VitalColId.ews.name, description: "EWS"),
  VitalTable(colName: VitalColId.bloodPressure.name, description: "Blood \nPressure (mmHg)"),
  VitalTable(colName: VitalColId.temp.name, description: "Body \nTemperature(°C)"),
  VitalTable(colName: VitalColId.pulse.name, description: "Pulse\n(bpm)"),
  VitalTable(colName: VitalColId.heartRate.name, description: "Heart Rate\n(bpm)"),
  VitalTable(colName: VitalColId.spo2.name, description: "SPO2\n(%)"),
  VitalTable(colName: VitalColId.bloodSugar.name, description: "Blood Sugar\n(mmol/L)"),
  VitalTable(colName: VitalColId.mealStatus.name, description: "Meal Status"),
  VitalTable(colName: VitalColId.actions.name, description: ""),
];

late Map<String, double> VitalColumnWidths = {
  VitalColId.id.name: 50,
  VitalColId.serialNo.name: 50,
  VitalColId.ews.name: 80,
  VitalColId.bloodPressure.name: 130,
  VitalColId.temp.name: 130,
  VitalColId.pulse.name: 90,
  VitalColId.heartRate.name: 100,
  VitalColId.spo2.name: 100,
  VitalColId.bloodSugar.name: 130,
  VitalColId.mealStatus.name: 90,
  VitalColId.actions.name: 80,
};
