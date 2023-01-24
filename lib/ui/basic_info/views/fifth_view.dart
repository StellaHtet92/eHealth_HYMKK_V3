import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/ui/account_register/views/gender_tab.dart';
import 'package:ehealth/ui/basic_info/bloc/basic_info_bloc.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FifthView extends StatelessWidget {
  final TextEditingController _noCigCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Function _onInfoChanged;

  FifthView(this._onInfoChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                padding: const EdgeInsets.only(bottom: m11, top: m2, left: m2, right: m2),
                shrinkWrap: true,
                primary: false,
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset("images/smoking.png"),
                  ),
                  const SizedBox(height: m2),
                  BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
                    return Text(questionList[state.pageIndex], style: const TextStyle(fontSize: fontTitle));
                  }),
                  const SizedBox(height: m4),
                  BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
                    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Expanded(
                        child: GenderTab(
                          onChange: (String title) {
                            BasicInfo i = BasicInfo.copy(state.info);
                            i.smokingStatus = true;
                            _onInfoChanged(i);
                          },
                          selectedTab: state.info.smokingStatus ? 'Yes' : 'No',
                          tabTitle: 'Yes',
                        ),
                      ),
                      Expanded(
                        child: GenderTab(
                          onChange: (String title) {
                            BasicInfo i = BasicInfo.copy(state.info);
                            i.smokingStatus = false;
                            i.noOfCigaPerDay = 0;
                            _onInfoChanged(i);
                          },
                          selectedTab: state.info.smokingStatus ? 'Yes' : 'No',
                          tabTitle: 'No',
                        ),
                      )
                    ]);
                  }),
                  const SizedBox(height: m4),
                  BlocBuilder<BasicInfoBloc, BasicInfoState>(buildWhen: (prev, cur) {
                    return prev.info.smokingStatus != cur.info.smokingStatus ? true : false;
                  }, builder: (context, state) {
                    return Visibility(
                      visible: state.info.smokingStatus,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: TextFormField(
                        controller: _noCigCtrl,
                        keyboardType: TextInputType.number,
                        validator: (value) => state.info.smokingStatus
                            ? value != null && value.isEmpty
                                ? "* required"
                                : null
                            : null,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 5.0),
                          ),
                          hintText: "Number of Cigarettes per day",
                          contentPadding: EdgeInsets.all(11.0),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
            return TextButton.icon(
              onPressed: () {
                FocusScope.of(context).unfocus();
                final form = _formKey.currentState;
                if (form?.validate() ?? false) {
                  form?.save();
                  int cig = 0;
                  if (_noCigCtrl.text.isNotEmpty) {
                    cig = int.parse(_noCigCtrl.text);
                  }
                  BlocProvider.of<BasicInfoBloc>(context).add(OnSaveEvent(cig));
                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Done"),
            );
          }),
        ),
      ],
    );
  }
}
