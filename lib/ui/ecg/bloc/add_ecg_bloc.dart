import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/repository/ecg_repo.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcgBloc extends Bloc<EcgEvent, EcgState> {
  final EcgRepo repo;

  EcgBloc(this.repo) : super(EcgState.initial()) {
    on<LoadUserSession>((event, emit) async {
      Account? account = await UserPref().getAccount();
      emit(state.copyWith(account: account));
    });
    on<OnEcgChanged>((event,emit) async{
      event.ecg.userid = state.account?.userId ?? 0;
      emit(state.copyWith(ecg: event.ecg));
    });
    on<OnSaveEvent>((event, emit) async {
      ApiResult<String> apiResult = await repo.saveEcg(event.ecg);
      apiResult.when(success: (String msg) {
        emit(state.copyWith(pageState: PageState(state: PageState.successState)));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class EcgState extends Equatable {
  final PageState pageState;
  final int pageIndex;
  final Account? account;
  final Ecg ecg;

  const EcgState({required this.pageState, required this.pageIndex,this.account, required this.ecg});

  EcgState.initial() : this(pageState: PageState(), pageIndex: 0, ecg: Ecg());

  EcgState copyWith({PageState? pageState, int? pageIndex, Ecg? ecg,Account? account}) {
    return EcgState(
      pageState: pageState ?? this.pageState,
      pageIndex: pageIndex ?? this.pageIndex,
      account: account ?? this.account,
      ecg: ecg ?? this.ecg,
    );
  }

  @override
  List<Object?> get props => [pageState, pageIndex,account, ecg];
}

abstract class EcgEvent {
  const EcgEvent();
}

class OnEcgChanged extends EcgEvent {
  final Ecg ecg;

  OnEcgChanged(this.ecg);
}

class OnSaveEvent extends EcgEvent {
  final Ecg ecg;

  OnSaveEvent(this.ecg);
}

class LoadUserSession extends EcgEvent{}
