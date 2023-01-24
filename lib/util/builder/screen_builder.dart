
import 'package:flutter/material.dart';

import 'sizing_information.dart';

class ScreenBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, SizingInformation sizingInformation) builder;

  const ScreenBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, boxSizing) {
      var sizingInformation = SizingInformation(
        orientation: mediaQuery.orientation,
        deviceType: getDeviceType(mediaQuery),
        screenSize: mediaQuery.size,
      );
      return SafeArea(child: builder(context, sizingInformation));
    });
  }
}
