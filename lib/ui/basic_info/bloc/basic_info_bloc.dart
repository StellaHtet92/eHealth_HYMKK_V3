import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicInfoBloc extends Bloc<BasicInfoEvent, BasicInfoState> {
  final AccountRepo repo;

  BasicInfoBloc(this.repo) : super(BasicInfoState.initial()) {
    on<OnPageIndexChanged>((event, emit) async {
      emit(state.copyWith(pageIndex: event.index));
    });
    on<OnSaveEvent>((event, emit) async {
      BasicInfo i = BasicInfo.copy(state.info);
      i.noOfCigaPerDay = event.noOfCigaPerDay;
      debugPrint(i.toJson().toString());
      ApiResult<String> apiResult = await repo.saveBasicInfo(i);
      await apiResult.when(success: (String msg) async {
        Account? acc = await UserPref().getAccount();
        if(acc != null){
          acc.basicInfo = true;
          UserPref().setAccount(acc);
        }
        emit(state.copyWith(pageState: PageState(state: PageState.successState)));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
    on<OnInfoChanged>((event, emit) async {
      emit(state.copyWith(info: event.info));
    });
  }
}

class BasicInfoState extends Equatable {
  final PageState pageState;
  final int pageIndex;
  final BasicInfo info;

  const BasicInfoState({required this.pageState,required this.pageIndex,required this.info});

  BasicInfoState.initial() : this(pageState: PageState(),pageIndex: 0,info: BasicInfo());

  BasicInfoState copyWith({PageState? pageState,int? pageIndex,BasicInfo? info}) {
    return BasicInfoState(
      pageState: pageState ?? this.pageState,
      pageIndex: pageIndex ?? this.pageIndex,
      info: info ?? this.info,
    );
  }

  @override
  List<Object?> get props => [pageState,pageIndex,info];
}

abstract class BasicInfoEvent {
  const BasicInfoEvent();
}

class OnInfoChanged extends BasicInfoEvent{
  final BasicInfo info;

  OnInfoChanged(this.info);
}

class OnSaveEvent extends BasicInfoEvent{
  final int noOfCigaPerDay;

  OnSaveEvent(this.noOfCigaPerDay);
}

class OnPageIndexChanged extends BasicInfoEvent{
  final int index;

  OnPageIndexChanged(this.index);
}