import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRegisterBloc extends Bloc<AccountRegisterEvent, AccountRegisterState> {
  final AccountRepo repo;

  AccountRegisterBloc(this.repo) : super(AccountRegisterState.initial()) {
    on<OnPageOneChanged>((event, emit) async {
      Account account = Account.copy(state.accInfo);
      account.userName = event.userName;
      account.fullName = event.fullName;
      emit(state.copyWith(accInfo: account));
    });
    on<OnGenderChanged>((event, emit) async {
      Account account = Account.copy(state.accInfo);
      account.gender = event.val;
      emit(state.copyWith(accInfo: account));
    });
    on<OnPageTwoChanged>((event, emit) async {
      Account account = Account.copy(state.accInfo);
      account.mobile = event.mobile;
      account.dob = event.dob;
      emit(state.copyWith(accInfo: account));
    });
    on<OnPageThreeChanged>((event, emit) async {
      Account account = Account.copy(state.accInfo);
      account.password = event.pwd;
      ApiResult<Account> apiResult = await repo.register(account);
      apiResult.when(success: (Account account) {
        UserPref().setAccount(account);
        emit(state.copyWith(pageState: PageState(state: PageState.successState),));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class AccountRegisterState extends Equatable {
  final PageState pageState;
  final Account accInfo;
  final String pwd;

  const AccountRegisterState({required this.pageState, required this.accInfo, required this.pwd});

  AccountRegisterState.initial() : this(pageState: PageState(), accInfo: Account(gender: Gender.Male.name), pwd: "");

  AccountRegisterState copyWith({PageState? pageState,Account? accInfo, String? pwd}) {
    return AccountRegisterState(
      pageState: pageState ?? this.pageState,
      accInfo: accInfo ?? this.accInfo,
      pwd: pwd ?? this.pwd,
    );
  }

  @override
  List<Object?> get props => [pageState,accInfo,pwd];
}

abstract class AccountRegisterEvent {
  const AccountRegisterEvent();
}

class OnPageOneChanged extends AccountRegisterEvent {
  final String userName;
  final String fullName;

  OnPageOneChanged(this.userName, this.fullName);
}

class OnPageTwoChanged extends AccountRegisterEvent {
  final String mobile;
  final String dob;

  OnPageTwoChanged(this.mobile, this.dob);
}

class OnPageThreeChanged extends AccountRegisterEvent {
  final String pwd;

  OnPageThreeChanged(this.pwd);
}

class OnGenderChanged extends AccountRegisterEvent{
  final String val;

  OnGenderChanged(this.val);
}