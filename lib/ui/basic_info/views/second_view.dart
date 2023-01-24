import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/ui/basic_info/bloc/basic_info_bloc.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecondView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Function _onInfoChanged;

  SecondView(this._onInfoChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child:  Center(
            child: ListView(
              padding: const EdgeInsets.only(bottom: m11,top: m2,left: m2,right: m2),
              shrinkWrap: true,
              primary: false,
              children: [
                BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: Image.asset("images/disease.png"),
                      ),
                      const SizedBox(height: m2),
                      Text(questionList[state.pageIndex], style: const TextStyle(fontSize: fontTitle)),
                      const SizedBox(height: m4),
                      Wrap(
                        spacing: m1,
                        children: [
                          InkWell(
                            child: Chip(
                              backgroundColor: state.info.hcv ? primary[50] : Colors.grey[300],
                              label: const Text("HCV"),
                              avatar: Icon(Icons.check_circle, color: state.info.hcv ? primary : Colors.grey),
                            ),
                            onTap: () {
                              BasicInfo i = BasicInfo.copy(state.info);
                              i.hcv = !state.info.hcv;
                              _onInfoChanged(i);
                            },
                          ),
                          InkWell(
                            child: Chip(
                              backgroundColor: state.info.hcb ? primary[50] : Colors.grey[300],
                              label: const Text("HCB"),
                              avatar: Icon(Icons.check_circle, color: state.info.hcb ? primary : Colors.grey),
                            ),
                            onTap: () {
                              BasicInfo i = BasicInfo.copy(state.info);
                              i.hcb = !state.info.hcb;
                              _onInfoChanged(i);
                            },
                          ),
                          InkWell(
                            child: Chip(
                              backgroundColor: state.info.tb ? primary[50] : Colors.grey[300],
                              label: const Text("TB"),
                              avatar: Icon(Icons.check_circle, color: state.info.tb ? primary : Colors.grey),
                            ),
                            onTap: () {
                              BasicInfo i = BasicInfo.copy(state.info);
                              i.tb = !state.info.tb;
                              _onInfoChanged(i);
                            },
                          ),
                          InkWell(
                            child: Chip(
                              backgroundColor: state.info.hiv ? primary[50] : Colors.grey[300],
                              label: const Text("HIV"),
                              avatar: Icon(Icons.check_circle, color: state.info.hiv ? primary : Colors.grey),
                            ),
                            onTap: () {
                              BasicInfo i = BasicInfo.copy(state.info);
                              i.hiv = !state.info.hiv;
                              _onInfoChanged(i);
                            },
                          ),
                          InkWell(
                            child: Chip(
                              backgroundColor: state.info.diabetes ? primary[50] : Colors.grey[300],
                              label: const Text("Diabetes"),
                              avatar: Icon(Icons.check_circle, color: state.info.diabetes ? primary : Colors.grey),
                            ),
                            onTap: () {
                              BasicInfo i = BasicInfo.copy(state.info);
                              i.diabetes = !state.info.diabetes;
                              _onInfoChanged(i);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: m3),
                const Center(
                  child: Text("Or other diseases? Please describe below."),
                ),
                const SizedBox(height: m3),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: customInputDeco("", null),
                    onSaved: (String? data) {
                      BasicInfoState state = BlocProvider.of<BasicInfoBloc>(context).state;
                      BasicInfo i = BasicInfo.copy(state.info);
                      i.other = data;
                      _onInfoChanged(i);
                    },
                  ),
                ),
              ],
            )
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
            return TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                final form = _formKey.currentState;
                if (form?.validate() ?? false) {
                  form?.save();
                  BlocProvider.of<BasicInfoBloc>(context).add(OnPageIndexChanged(state.pageIndex + 1));
                }
              },
              child: Row(
                children: const [Text("Next"), SizedBox(width: m2), Icon(Icons.navigate_next)],
              ),
            );
          }),
        ),
      ],
    );
  }
}