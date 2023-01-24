import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/basic_info/bloc/basic_info_bloc.dart';
import 'package:ehealth/ui/basic_info/views/fifth_view.dart';
import 'package:ehealth/ui/basic_info/views/first_view.dart';
import 'package:ehealth/ui/basic_info/views/fourth_view.dart';
import 'package:ehealth/ui/basic_info/views/second_view.dart';
import 'package:ehealth/ui/basic_info/views/third_view.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicInfoPage extends StatelessWidget {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BasicInfoBloc(AccountRepo()),
      child: _Stateful(),
    );
  }
}

class _Stateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Stateful> {
  _onInfoChanged(BasicInfo info) {
    BlocProvider.of<BasicInfoBloc>(context).add(OnInfoChanged(info));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text("Answer Basic Information", style: TextStyle(color: primary)),
        foregroundColor: primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: BlocListener<BasicInfoBloc, BasicInfoState>(
        listener: (context, state) {
          if (state.pageState.state == PageState.successState) {
            Navigator.pop(context);
            Navigator.pushNamed(context, addVitalRoute);
          } else if (state.pageState.state == PageState.failState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.pageState.message)));
          }
        },
        child: BlocBuilder<BasicInfoBloc, BasicInfoState>(buildWhen: (prev, cur) {
          return prev.pageIndex != cur.pageIndex ? true : false;
        }, builder: (context, state) {
          return state.pageIndex == 0
              ? FirstView(_onInfoChanged)
              : state.pageIndex == 1
                  ? SecondView(_onInfoChanged)
                  : state.pageIndex == 2
                      ? ThirdView(_onInfoChanged)
                      : state.pageIndex == 3
                          ? FourthView(_onInfoChanged)
                          : state.pageIndex == 4
                              ? FifthView(_onInfoChanged)
                              : Container();
        }),
      ),
    );
  }
}
