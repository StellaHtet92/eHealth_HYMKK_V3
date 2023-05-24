import 'package:ehealth/ui/ecg/views/bluetooth_off_screen.dart';
import 'package:ehealth/ui/ecg/views/find_device_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AddEcgPageOne extends StatelessWidget {
  const AddEcgPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on || state == BluetoothState.turningOn || state == BluetoothState.unknown) {
            return FindDevicesScreen();
          }
          return BluetoothOffScreen(state: state);
        });
  }
}
