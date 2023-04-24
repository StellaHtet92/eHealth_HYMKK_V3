import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<Init>((event, emit) async {
      emit(state.copyWith(pageState: PageState(state: PageState.pageLoadingState)));
      Account? account = await UserPref().getAccount();
      emit(state.copyWith(accInfo: account, pageState: PageState(state: PageState.pageLoadedState)));
    });
  }
}

class ProfileState extends Equatable {
  final PageState pageState;
  final Account accInfo;

  const ProfileState({required this.pageState, required this.accInfo});

  ProfileState.initial() : this(pageState: PageState(), accInfo: Account(gender: Gender.Male.name));

  ProfileState copyWith({PageState? pageState, Account? accInfo, String? pwd}) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      accInfo: accInfo ?? this.accInfo,
    );
  }

  @override
  List<Object?> get props => [pageState, accInfo];
}

abstract class ProfileEvent {
  const ProfileEvent();
}

class Init extends ProfileEvent {
  Init();
}