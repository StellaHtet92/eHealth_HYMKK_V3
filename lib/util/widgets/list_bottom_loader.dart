
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../values/colors.dart';
import '../values/values.dart';

class ListBottomLoader extends StatelessWidget{
  const ListBottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(m3),
      alignment: Alignment.center,
      child: const Center(
        child: SizedBox(
          width: m3,
          height: m3,
          child: SpinKitThreeBounce(
            size: 10.0,
            color: secondaryAccentColor,
            duration: Duration(milliseconds: 1000),
          ),
        ),
      ),
    );
  }
}