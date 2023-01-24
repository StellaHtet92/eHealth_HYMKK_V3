import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/account_register/bloc/account_register_bloc.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRegisterThree extends StatelessWidget {
  const AccountRegisterThree({super.key});

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
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _cpasswordCtrl = TextEditingController();

  _onClickNext() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<AccountRegisterBloc>(context).add(OnPageThreeChanged(_passwordCtrl.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountRegisterBloc, AccountRegisterState>(
      listener: (context, state) {
        if (state.pageState.state == PageState.successState) {
          Navigator.pushNamedAndRemoveUntil(context, homeRoute, (Route<dynamic> route) => false);
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
                              child: Image.asset("images/password.png"),
                            ),
                            const Center(
                              child: Text("Create your own password.", style: TextStyle(fontSize: fontSubTitle4)),
                            ),
                            const SizedBox(height: m2),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) => value != null && value.isEmpty ? "* required" : null,
                              decoration: customInputDeco("Password", const Icon(Icons.password)),
                            ),
                            const SizedBox(height: m1),
                            TextFormField(
                              controller: _cpasswordCtrl,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) => value != null && value.isEmpty
                                  ? "* required"
                                  : _passwordCtrl.value.text != value
                                      ? 'Password and confirm password do not match.'
                                      : null,
                              decoration: customInputDeco("Confirm Password", const Icon(Icons.password)),
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
                child: TextButton.icon(
                  onPressed: () {
                    _onClickNext();
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Done"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
