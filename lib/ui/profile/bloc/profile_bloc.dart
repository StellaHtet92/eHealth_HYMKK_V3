import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/models/profile.dart';
import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountRepo repo;

  ProfileBloc({required this.repo}) : super(ProfileState.initial()) {
    on<Init>((event, emit) async {
      emit(state.copyWith(pageState: PageState(state: PageState.pageLoadingState)));
      Account? account = await UserPref().getAccount();
      if(account != null){
        ApiResult<Profile> apiResult = await repo.getUserDetail(account.userId);
        apiResult.when(success: (Profile profile) {
          UserPref().setAccount(profile.user);
          emit(state.copyWith(profile: profile, pageState: PageState(state: PageState.pageLoadedState)));
        }, failure: (NetworkExceptions error) {
          emit(state.copyWith(pageState: PageState(state: PageState.failState, message: NetworkExceptions.getErrorMessage(error))));
        });
      }
    });
  }
}

class ProfileState extends Equatable {
  final PageState pageState;
  final Profile? profile;

  const ProfileState({required this.pageState, this.profile});

  ProfileState.initial() : this(pageState: PageState());

  ProfileState copyWith({PageState? pageState, Profile? profile, String? pwd}) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [pageState, profile];
}

abstract class ProfileEvent {
  const ProfileEvent();
}

class Init extends ProfileEvent {
  Init();
}