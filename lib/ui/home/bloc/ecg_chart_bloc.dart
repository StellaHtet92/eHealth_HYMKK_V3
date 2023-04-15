import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/repository/ecg_repo.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcgChartBloc extends Bloc<EcgChartEvent, EcgChartState> {
  final EcgRepo repo;

  EcgChartBloc(this.repo) : super(EcgChartState.initial()) {
    on<InitEcgChart>((event, emit) async {
      ApiResult<List<Ecg>> apiResult = await repo.fetchEcg(1);
      apiResult.when(success: (List<Ecg> result) {
        emit(state.copyWith(pageState: PageState(state: PageState.successState),result: result));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class EcgChartState extends Equatable {
  final PageState pageState;
  final List<Ecg> result;

  const EcgChartState({required this.pageState,required this.result});

  EcgChartState.initial() : this(pageState: PageState(),result: []);

  EcgChartState copyWith({PageState? pageState,List<Ecg>? result}) {
    return EcgChartState(
      pageState: pageState ?? this.pageState,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [pageState,result];
}

abstract class EcgChartEvent {
  const EcgChartEvent();
}

class InitEcgChart extends EcgChartEvent{}