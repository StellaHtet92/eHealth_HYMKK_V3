import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/account_register/bloc/account_register_bloc.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRegisterOne extends StatelessWidget {
  const AccountRegisterOne({super.key});

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
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _fullNameCtrl = TextEditingController();

  _onClickNext() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<AccountRegisterBloc>(context).add(OnPageOneChanged(_usernameCtrl.text, _fullNameCtrl.text));
      Navigator.pushNamedAndRemoveUntil(context, registerTwoRoute, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                            height: 65,
                            child: Image.asset("images/icons/logo_two.png"),
                          ),
                          const SizedBox(height: m1),
                          const Text("", style: TextStyle(fontSize: fontH3, fontWeight: FontWeight.bold, color: primaryColor)),
                          const SizedBox(height: m1),
                          TextFormField(
                            controller: _usernameCtrl,
                            validator: (value) => value != null && value.isEmpty ? "* required" : null,
                            decoration: customInputDeco("Username",const Icon(Icons.account_circle)),
                          ),
                          const SizedBox(height: m1),
                          TextFormField(
                            controller: _fullNameCtrl,
                            validator: (value) => value != null && value.isEmpty ? "* required" : null,
                            decoration: customInputDeco("Full Name",const Icon(Icons.account_circle)),
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
            )
          ],
        ),
      ),
    );
  }
}
