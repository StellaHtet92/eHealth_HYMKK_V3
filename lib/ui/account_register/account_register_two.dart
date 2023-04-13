import 'package:country_picker/country_picker.dart';
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
  DateTime date = DateTime.now();
  var countryCode = '+95';

  _onGenderChange(String val) {
    BlocProvider.of<AccountRegisterBloc>(context).add(OnGenderChanged(val));
  }

  _onClickNext() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<AccountRegisterBloc>(context).add(OnPageTwoChanged(_mobileCtrl.text, date.toString()));
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
                child: IconButton(
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
                              child: Text(state.accInfo.fullname, style: const TextStyle(fontSize: fontTitle, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: m2),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        setState(() {
                                          countryCode = "+${country.phoneCode}";
                                        });
                                      },
                                    );
                                  },
                                  child: Text(countryCode),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _mobileCtrl,
                                    validator: (value) => value != null && value.isEmpty ? "* required" : null,
                                    keyboardType: TextInputType.phone,
                                    decoration: customInputDeco("Mobile Number", const Icon(Icons.phone)),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: m1),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                showAppDatePicker(context,onDateChanged:(val){
                                  date = val;
                                  _dobCtrl.text = changeDateFormat1(val.toString());
                                });
                              },
                              child: TextFormField(
                                enabled: false,
                                validator: (value) => value != null && value.isEmpty ? "* required" : null,
                                controller: _dobCtrl,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  errorStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.error, // or any other color
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
                    children: const [Text("Next"), SizedBox(width: m2), Icon(Icons.navigate_next)],
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
