import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/ui/home/bloc/ecg_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EcgDataSource extends DataGridSource {
  EcgDataSource({required List<Ecg> dataList}) {
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

  List<DataGridRow> buildDataGridRow({required List<Ecg> dataList}) {
    return dataList
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
        DataGridCell<int>(columnName: EcgColId.id.name, value: e.id),
        DataGridCell<int>(columnName: EcgColId.userid.name, value: e.userid),
        DataGridCell<String>(columnName: EcgColId.ecg.name, value: e.ecg),
       // DataGridCell<String>(columnName: EcgColId.ecgResults.name, value: "${e.bpSys}/${e.bpDia}"),
        DataGridCell<String>(columnName: EcgColId.actions.name, value: ""),
      ]),
    )
        .toList();
  }

  addMoreRow({required List<Ecg> dataList}) {
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
            child: (e.columnName != EcgColId.actions.name)
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
                                  BlocProvider.of<EcgListBloc>(context).add(OnEcgDelete(row.getCells()[0].value));
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

class EcgTable {
  final String colName;
  final String description;

  EcgTable({required this.colName, required this.description});
}

enum EcgColId { id, userid, ecg, ecgResults, actions }

List<EcgTable> tableColumns = [
  EcgTable(colName: EcgColId.id.name, description: "Id"),
  EcgTable(colName: EcgColId.userid.name, description: "User ID"),
  EcgTable(colName: EcgColId.ecg.name, description: "Electrocardiogram"),
  EcgTable(colName: EcgColId.ecgResults.name, description: "Results"),
  EcgTable(colName: EcgColId.actions.name, description: ""),
];

late Map<String, double> VitalColumnWidths = {
  EcgColId.id.name: 50,
  EcgColId.userid.name: 50,
  EcgColId.ecg.name: 80,
  EcgColId.ecgResults.name: 130,
  EcgColId.actions.name: 80,
};
