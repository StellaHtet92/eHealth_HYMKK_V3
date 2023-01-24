import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "E-Health",
          style: TextStyle(color: primary),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: m2, top: m1, bottom: m1),
          child: Icon(Icons.account_circle, color: primary, size: 40),
        ),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: const Text('11', style: TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
                ),
              )
            ],
          ),
        ],
      ),
      body: Container(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.monitor_heart),
              label: 'ADD VITAL',
              onTap: () async {
                Account? account = await UserPref().getAccount();
                if (account != null && account.basicInfo) {
                  Navigator.pushNamed(context, addVitalRoute);
                } else {
                  Navigator.pushNamed(context, basicInfoRoute);
                }
              })
        ],
      ),
    );
  }
}
