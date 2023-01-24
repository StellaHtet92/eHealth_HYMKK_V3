import 'package:country_code_picker/country_code_picker.dart';
import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/account_register/bloc/account_register_bloc.dart';
import 'package:ehealth/ui/account_register/views/gender_tab.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/values/colors.dart';

class AccountRegisterTwo extends StatelessWidget {
  const AccountRegisterTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return _Stateful();
  }
}

class _Stateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Stateful> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _genderCtrl = TextEditingController();
  var countryCode = '+95';

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 250,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.ydm,
                  onDateTimeChanged: (val) {
                    _dobCtrl.text = changeDateFormat1(val.toString());
                  }),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      ),
    );
  }

  _onGenderChange(String val) {
    BlocProvider.of<AccountRegisterBloc>(context).add(OnGenderChanged(val));
  }

  _onClickNext(){
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<AccountRegisterBloc>(context).add(OnPageTwoChanged(_mobileCtrl.text, _dobCtrl.text));
      Navigator.pushNamedAndRemoveUntil(context, registerThreeRoute, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountRegisterBloc, AccountRegisterState>(
      listener: (context, state) {
        if (state.pageState.state == PageState.successState) {
          Navigator.pop(context);
        } else if (state.pageState.state == PageState.failState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.pageState.message)));
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0.0,
                right: 0.0,
                child:IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (Route<dynamic> route) => false);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(m2),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: BlocBuilder<AccountRegisterBloc, AccountRegisterState>(builder: (context, state) {
                        return ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 100,
                              child: Image.asset("images/profile.png"),
                            ),
                            const SizedBox(height: m2),
                            const Center(
                              child: Text("Username", style: TextStyle(fontSize: fontSubTitle2)),
                            ),
                            Center(
                              child: Text(state.accInfo.fullName, style: const TextStyle(fontSize: fontTitle,fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: m2),
                            Row(
                              children: [
                                CountryCodePicker(
                                  dialogSize: const Size(300.0, 500.0),
                                  flagWidth: 15,
                                  textStyle: const TextStyle(color: primaryColor, fontSize: fontSubTitle2),
                                  padding: const EdgeInsets.only(left: p2, right: p2),
                                  onChanged: (e) => {countryCode = e.toString()},
                                  initialSelection: 'MM',
                                  showCountryOnly: true,
                                  favorite: ['+95', 'MM'],
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _mobileCtrl,
                                    validator: (value) => value != null && value.isEmpty ? "* required" : null,
                                    keyboardType: TextInputType.phone,
                                    decoration: customInputDeco("Mobile Number",const Icon(Icons.phone)),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: m1),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _showDatePicker(context);
                              },
                              child: TextFormField(
                                enabled: false,
                                validator: (value) => value != null && value.isEmpty ? "* required" : null,
                                controller: _dobCtrl,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  errorStyle: TextStyle(
                                    color: Theme.of(context).errorColor, // or any other color
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 5.0),
                                  ),
                                  hintText: "Date of birth",
                                  contentPadding: const EdgeInsets.all(11.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: m5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GenderTab(
                                    onChange: _onGenderChange,
                                    selectedTab: state.accInfo.gender ?? Gender.Male.name,
                                    tabTitle: Gender.Male.name,
                                  ),
                                ),
                                Expanded(
                                  child: GenderTab(
                                    onChange: _onGenderChange,
                                    selectedTab: state.accInfo.gender ?? Gender.Male.name,
                                    tabTitle: Gender.Female.name,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 100)
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: TextButton(
                  onPressed: () {
                    _onClickNext();
                  },
                  child: Row(
                    children: const [
                      Text("Next"),
                      SizedBox(width: m2),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
