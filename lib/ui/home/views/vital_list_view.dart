import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/ui/home/bloc/vital_datasource.dart';
import 'package:ehealth/ui/home/bloc/vital_list_bloc.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../util/widgets/loading_circle.dart';

class VitalListView extends StatelessWidget {
  const VitalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VitalListBloc(VitalRepo())..add(LoadData(loadMore: false)),
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
  final DataGridController _gridController = DataGridController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VitalListBloc, VitalListState>(
      listener: (context, state) {
        if (state.actionState.state == PageState.successState) {
          showToast(state.actionState.message, context, bgColor: Colors.green, textColor: Colors.white, icon: Icons.check_circle);
          BlocProvider.of<VitalListBloc>(context).add(LoadData(loadMore: false));
        } else if (state.actionState.state == PageState.failState) {
          showToast(state.actionState.state == PageState.failState ? state.actionState.message : state.actionState.message, context);
        }
      },
      child: BlocBuilder<VitalListBloc, VitalListState>(buildWhen: (prev, cur) {
        if (prev.pageState.state != cur.pageState.state || prev.dataSource != cur.dataSource) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: m1),
          child: SfDataGridTheme(
            data: SfDataGridThemeData(
              headerColor: primary[50],
              rowHoverColor: primary[50],
            ),
            child: SfDataGrid(
              controller: _gridController,
              gridLinesVisibility: GridLinesVisibility.both,
              source: state.dataSource,
              columnWidthMode: ColumnWidthMode.fill,
              headerGridLinesVisibility: GridLinesVisibility.both,
              footer: BlocBuilder<VitalListBloc, VitalListState>(buildWhen: (prev, cur) {
                if (prev.pageState != cur.pageState) {
                  return true;
                }
                return false;
              }, builder: (context, curState) {
                return curState.pageState.state == PageState.pageLoadMoreState
                    ? Container(
                        height: 60.0,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(top: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
                        alignment: Alignment.center,
                        child: const LoadingCircle())
                    : const SizedBox();
              }),
              loadMoreViewBuilder: (BuildContext context, LoadMoreRows loadMoreRows) {
                Future<String> loadRows() async {
                  BlocProvider.of<VitalListBloc>(context).add(LoadData(loadMore: true));
                  await loadMoreRows();
                  return Future<String>.value('Completed');
                }

                return FutureBuilder<String>(
                    initialData: 'loading',
                    future: loadRows(),
                    builder: (context, snapShot) {
                      return Container();
                    });
              },
              columns: VitalColId.values.toList().map((VitalColId column) {
                return GridColumn(
                  visible: !(column.name == VitalColId.id.name || column.name == VitalColId.serialNo.name),
                  width: VitalColumnWidths[column.name]!,
                  columnName: column.name,
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text(tableColumns.firstWhere((element) => element.colName == column.name).description),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
