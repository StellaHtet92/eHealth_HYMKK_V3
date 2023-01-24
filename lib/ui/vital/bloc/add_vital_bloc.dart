import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalBloc extends Bloc<VitalEvent, VitalState> {
  final VitalRepo repo;

  VitalBloc(this.repo) : super(VitalState.initial()) {
    on<OnSaveEvent>((event, emit) async {
      ApiResult<String> apiResult = await repo.saveVital(event.v);
      apiResult.when(success: (String msg) {
        emit(state.copyWith(pageState: PageState(state: PageState.successState)));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class VitalState extends Equatable {
  final PageState pageState;
  final int pageIndex;
  final Vital v;

  const VitalState({required this.pageState, required this.pageIndex, required this.v});

  VitalState.initial() : this(pageState: PageState(), pageIndex: 0, v: Vital());

  VitalState copyWith({PageState? pageState, int? pageIndex, Vital? v}) {
    return VitalState(
      pageState: pageState ?? this.pageState,
      pageIndex: pageIndex ?? this.pageIndex,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props => [pageState, pageIndex, v];
}

abstract class VitalEvent {
  const VitalEvent();
}

class OnVitalChanged extends VitalEvent {
  final Vital v;

  OnVitalChanged(this.v);
}

class OnSaveEvent extends VitalEvent {
  final Vital v;

  OnSaveEvent(this.v);
}
