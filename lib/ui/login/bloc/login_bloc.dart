import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AccountRepo repo;

  LoginBloc(this.repo) : super(LoginState.initial()){
    on<OnLogin>((event, emit) async {
      ApiResult<Account> apiResult = await repo.login(event.userName, event.pw);
      apiResult.when(success: (Account account) {
        print(account.toString());
        UserPref().setAccount(account);
        emit(state.copyWith(pageState: PageState(state: PageState.successState),));
      }, failure: (NetworkExceptions error) {
        emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
      });
    });
  }
}

class LoginState extends Equatable {
  final PageState pageState;

  const LoginState({required this.pageState});

  LoginState.initial() : this(pageState: PageState());

  LoginState copyWith({PageState? pageState}) {
    return LoginState(
      pageState: pageState ?? this.pageState,
    );
  }

  @override
  List<Object?> get props => [pageState];
}

abstract class LoginEvent{
  const LoginEvent();
}

class OnLogin extends LoginEvent{
  final String userName;
  final String pw;

  OnLogin(this.userName,this.pw);
}