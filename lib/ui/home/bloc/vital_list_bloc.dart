import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/ui/home/bloc/vital_datasource.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalListBloc extends Bloc<VitalListEvent, VitalListState> {
  final VitalRepo repository;

  VitalListBloc(this.repository) : super(VitalListState.initial()) {
    on<LoadData>((event, emit) async {
      if (!event.loadMore) {
        emit(state.copyWith(pageState: PageState(state: PageState.pageLoadingState)));
      } else {
        emit(state.copyWith(pageState: PageState(state: PageState.pageLoadMoreState)));
      }
      ApiResult<List<Vital>> apiResult = await repository.fetchVital(event.loadMore ? (state.dataSource.getLength() ~/ pageSize).toInt() + 1 : 1);
      apiResult.when(success: (List<Vital> result) {
        if (event.loadMore) {
          if (result.isNotEmpty) {
            int length = state.dataSource.getLength();
            if(length > (((length ~/ pageSize).toInt() * pageSize))){
              state.dataSource.removeRow(from: (((length ~/ pageSize).toInt() * pageSize)), to: length);
            }
            state.dataSource.addMoreRow(dataList: result);
            emit(state.copyWith(pageState: PageState(state: PageState.pageLoadedState)));
          } else {
            emit(state.copyWith(pageState: PageState(state: PageState.warningState)));
          }
        } else {
          VitalDataSource dataSource = VitalDataSource(dataList: result);
          emit(state.copyWith(dataSource: dataSource, pageState: PageState(state: PageState.pageLoadedState)));
        }
      }, failure: (NetworkExceptions error) {
        if (event.loadMore) {
          emit(state.copyWith(pageState: PageState(state: PageState.warningState, message: NetworkExceptions.getErrorMessage(error))));
        } else {
          emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
        }
      });
    });
    on<OnVitalDelete>((event, emit) async {
      ApiResult<String> apiResult = await repository.deleteVital(event.id);
      apiResult.when(success: (String msg) {
        emit(state.copyWith(actionState: PageState(state: PageState.successState,message: msg)));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(actionState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class VitalListState extends Equatable {
  final PageState pageState;
  final PageState actionState;

  final VitalDataSource dataSource;

  const VitalListState({
    required this.pageState,
    required this.actionState,
    required this.dataSource,
  });

  VitalListState.initial()
      : this(
    pageState: PageState(),
    actionState: PageState(),
    dataSource: VitalDataSource(dataList: []),
  );

  VitalListState copyWith({
    PageState? pageState,
    PageState? actionState,
    VitalDataSource? dataSource,
  }) {
    return VitalListState(
      actionState: actionState ?? PageState(),
      pageState: pageState ?? PageState(),
      dataSource: dataSource ?? this.dataSource
    );
  }

  @override
  List<Object?> get props => [pageState,actionState, dataSource];
}

abstract class VitalListEvent {
  const VitalListEvent();
}

class Init extends VitalListEvent {}

class LoadData extends VitalListEvent {
  final bool loadMore;
  final String? keyword;

  LoadData({required this.loadMore, this.keyword});
}

class OnVitalDelete extends VitalListEvent{
  final int id;

  OnVitalDelete(this.id);
}