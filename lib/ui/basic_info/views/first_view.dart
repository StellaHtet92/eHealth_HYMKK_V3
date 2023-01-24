import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/ui/account_register/views/gender_tab.dart';
import 'package:ehealth/ui/basic_info/bloc/basic_info_bloc.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstView extends StatelessWidget {
  final Function _onInfoChanged;

  const FirstView(this._onInfoChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
      return Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: ListView(
                padding: const EdgeInsets.only(bottom: m11,top: m2,left: m2,right: m2),
                shrinkWrap: true,
                primary: false,
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset("images/blood.png"),
                  ),
                  const SizedBox(height: m2),
                  Text(questionList[state.pageIndex], style: const TextStyle(fontSize: fontTitle)),
                  const SizedBox(height: m4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GenderTab(
                          onChange: (String title) {
                            BasicInfo i = BasicInfo.copy(state.info);
                            i.bloodType = title;
                            _onInfoChanged(i);
                          },
                          selectedTab: state.info.bloodType,
                          tabTitle: 'A',
                        ),
                      ),
                      Expanded(
                        child: GenderTab(
                          onChange: (String title) {
                            BasicInfo i = BasicInfo.copy(state.info);
                            i.bloodType = title;
                            _onInfoChanged(i);
                          },
                          selectedTab: state.info.bloodType,
                          tabTitle: 'B',
                        ),
                      ),
                      Expanded(
                        child: GenderTab(
                          onChange: (String title) {
                            BasicInfo i = BasicInfo.copy(state.info);
                            i.bloodType = title;
                            _onInfoChanged(i);
                          },
                          selectedTab: state.info.bloodType,
                          tabTitle: 'AB',
                        ),
                      ),
                      Expanded(
                        child: GenderTab(
                          onChange: (String title) {
                            BasicInfo i = BasicInfo.copy(state.info);
                            i.bloodType = title;
                            _onInfoChanged(i);
                          },
                          selectedTab: state.info.bloodType,
                          tabTitle: 'O',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: TextButton(
              onPressed: () {
                BlocProvider.of<BasicInfoBloc>(context).add(OnPageIndexChanged(state.pageIndex + 1));
              },
              child: Row(
                children: const [Text("Next"), SizedBox(width: m2), Icon(Icons.navigate_next)],
              ),
            ),
          ),
        ],
      );
    });
  }
}
