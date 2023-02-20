import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final VitalRepo repo;

  HomePageBloc(this.repo) : super(HomePageState.initial()) {
    on<OnChangeDisplayType>((event, emit) async {
      emit(state.copyWith(displayType: event.type));
    });
  }
}

class HomePageState extends Equatable {
  final PageState pageState;
  final String displayType;

  const HomePageState({required this.pageState, required this.displayType});

  HomePageState.initial() : this(pageState: PageState(), displayType: DisplayType.Chart.name);

  HomePageState copyWith({PageState? pageState, String? displayType}) {
    return HomePageState(
      pageState: pageState ?? this.pageState,
      displayType: displayType ?? this.displayType,
    );
  }

  @override
  List<Object?> get props => [pageState, displayType];
}

abstract class HomePageEvent {
  const HomePageEvent();
}

class OnChangeDisplayType extends HomePageEvent {
  final String type;

  OnChangeDisplayType(this.type);
}
