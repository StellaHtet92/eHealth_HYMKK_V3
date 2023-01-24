import 'package:flutter/widgets.dart';

class SizingInformation {
  final Orientation orientation;
  final DeviceScreenType deviceType;
  final Size screenSize;

  SizingInformation({
    required this.orientation,
    required this.deviceType,
    required this.screenSize,
  });

  @override
  String toString() {
    return 'SizingInformation{orientation: $orientation, deviceType: $deviceType, screenSize: $screenSize}';
  }
}

enum DeviceScreenType {
  tablet,
  web
}

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  if (mediaQuery.size.width > 1080) {
    return DeviceScreenType.web;
  }
  return DeviceScreenType.tablet;
}