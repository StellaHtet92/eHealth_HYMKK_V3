

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ehealth/util/values/colors.dart';

class LoadingCircle extends StatelessWidget{

  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 80.0,
        height: 80.0,
        child: /*Image.asset(
          "images/heart_beat_loading.gif",
          height: 125.0,
          width: 125.0,
        ),*/SpinKitFadingCube(
          size: 20.0,
          color: primary,
          duration: Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}