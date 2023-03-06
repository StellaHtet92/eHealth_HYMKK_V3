import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalChartBloc extends Bloc<VitalChartEvent, VitalChartState> {
  final VitalRepo repo;

  VitalChartBloc(this.repo) : super(VitalChartState.initial()) {
    on<InitVitalChart>((event, emit) async {
      ApiResult<List<Vital>> apiResult = await repo.fetchVital(1);
      apiResult.when(success: (List<Vital> result) {
        emit(state.copyWith(pageState: PageState(state: PageState.successState),result: result));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class VitalChartState extends Equatable {
  final PageState pageState;
  final List<Vital> result;

  const VitalChartState({required this.pageState,required this.result});

  VitalChartState.initial() : this(pageState: PageState(),result: []);

  VitalChartState copyWith({PageState? pageState,List<Vital>? result}) {
    return VitalChartState(
      pageState: pageState ?? this.pageState,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [pageState,result];
}

abstract class VitalChartEvent {
  const VitalChartEvent();
}

class InitVitalChart extends VitalChartEvent{}