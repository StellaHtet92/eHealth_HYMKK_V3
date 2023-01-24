import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/ui/basic_info/bloc/basic_info_bloc.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThirdView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Function _onInfoChanged;

  ThirdView(this._onInfoChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: ListView(
              padding: const EdgeInsets.only(bottom: m11, top: m2, left: m2, right: m2),
              shrinkWrap: true,
              primary: false,
              children: [
                SizedBox(
                  height: 80,
                  child: Image.asset("images/allergy.png"),
                ),
                const SizedBox(height: m2),
                BlocBuilder<BasicInfoBloc, BasicInfoState>(builder: (context, state) {
                  return Text(questionList[state.pageIndex], style: const TextStyle(fontSize: fontTitle));
                }),
                const SizedBox(height: m4),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLines: 2,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
                      ),
                      hintText: "Example - Pollen",
                      contentPadding: EdgeInsets.all(11.0),
                    ),
                    onSaved: (String? val) {
                      BasicInfoState state = BlocProvider.of<BasicInfoBloc>(context).state;
                      BasicInfo i = BasicInfo.copy(state.info);
                      i.allergies = val ?? "";
                      _onInfoChanged(i);
                    },
                  ),
                ),
              ],
            ),
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
