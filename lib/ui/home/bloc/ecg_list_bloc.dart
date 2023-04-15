import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/repository/ecg_repo.dart';
import 'package:ehealth/ui/home/bloc/ecg_datasource.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcgListBloc extends Bloc<EcgListEvent, EcgListState> {
  final EcgRepo repository;

  EcgListBloc(this.repository) : super(EcgListState.initial()) {
    on<LoadData>((event, emit) async {
      if (!event.loadMore) {
        emit(state.copyWith(pageState: PageState(state: PageState.pageLoadingState)));
      } else {
        emit(state.copyWith(pageState: PageState(state: PageState.pageLoadMoreState)));
      }
      ApiResult<List<Ecg>> apiResult = await repository.fetchEcg(event.loadMore ? (state.dataSource.getLength() ~/ pageSize).toInt() + 1 : 1);
      apiResult.when(success: (List<Ecg> result) {
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
          EcgDataSource dataSource = EcgDataSource(dataList: result);
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
    on<OnEcgDelete>((event, emit) async {
      ApiResult<String> apiResult = await repository.deleteEcg(event.id);
      apiResult.when(success: (String msg) {
        emit(state.copyWith(actionState: PageState(state: PageState.successState,message: msg)));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(actionState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class EcgListState extends Equatable {
  final PageState pageState;
  final PageState actionState;

  final EcgDataSource dataSource;

  const EcgListState({
    required this.pageState,
    required this.actionState,
    required this.dataSource,
  });

  EcgListState.initial()
      : this(
    pageState: PageState(),
    actionState: PageState(),
    dataSource: EcgDataSource(dataList: []),
  );

  EcgListState copyWith({
    PageState? pageState,
    PageState? actionState,
    EcgDataSource? dataSource,
  }) {
    return EcgListState(
        actionState: actionState ?? PageState(),
        pageState: pageState ?? PageState(),
        dataSource: dataSource ?? this.dataSource
    );
  }

  @override
  List<Object?> get props => [pageState,actionState, dataSource];
}

abstract class EcgListEvent {
  const EcgListEvent();
}

class Init extends EcgListEvent {}

class LoadData extends EcgListEvent {
  final bool loadMore;
  final String? keyword;

  LoadData({required this.loadMore, this.keyword});
}

class OnEcgDelete extends EcgListEvent{
  final int id;

  OnEcgDelete(this.id);
}