import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/login/bloc/login_bloc.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:ehealth/util/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(AccountRepo()),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();

  _login() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<LoginBloc>(context).add(OnLogin(_userNameCtrl.text, _pwCtrl.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.pageState.state == PageState.successState) {
          Navigator.pushNamedAndRemoveUntil(context, homeRoute, (Route<dynamic> route) => false);
        } else if (state.pageState.state == PageState.failState) {
          showToast(state.pageState.message, context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(m2),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                        return ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 65,
                              child: Image.asset("images/icons/logo_two.png"),
                            ),
                            const SizedBox(height: m5),
                            TextFormField(
                              controller: _userNameCtrl,
                              validator: (value) => value != null && value.isEmpty ? "* required" : null,
                              decoration: customInputDeco("Username", const Icon(Icons.account_circle)),
                            ),
                            const SizedBox(height: m1),
                            TextFormField(
                              controller: _pwCtrl,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) => value != null && value.isEmpty ? "* required" : null,
                              decoration: customInputDeco("Password", const Icon(Icons.password)),
                            ),
                            const SizedBox(height: m3),
                            CustomTextButton(
                              text: "Login",
                              bgColor: primary,
                              onPressed: () {
                                _login();
                              },
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
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: primary[50],
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, registerOneRoute, (Route<dynamic> route) => false);
                    },
                    child: const Text("Register", style: TextStyle(color: accentColor)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
