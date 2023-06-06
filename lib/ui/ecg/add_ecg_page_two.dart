import 'dart:async';
import 'dart:convert' show utf8;

import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/ui/ecg/bloc/add_ecg_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_chart_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_list_bloc.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../repository/ecg_repo.dart';
import '../../util/values/string.dart';
import '../home/views/one_line_chart_view_ecg.dart';

class AddEcgPageTwo extends StatelessWidget {
  final BluetoothDevice device;

  const AddEcgPageTwo({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EcgBloc(EcgRepo())..add(LoadUserSession()),
      child: _Stateful(device),
    );
  }
}

class _Stateful extends StatefulWidget {
  final BluetoothDevice device;

  const _Stateful(this.device);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Stateful> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late Stream<List<int>>? stream;
  List<int> _inputData = [];
  bool isReady = false;
  bool isRecording = false;
  Ecg ecg = Ecg();
  late Stopwatch _stopwatch;
  late Timer _timer;

  startTimer() {
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isRecording) {
        timer.cancel();
        disconnectFromDevice();
      }
    });
  }

  discoverServices() async {
    await widget.device.connect();
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;
            _stopwatch.start();
            setState(() {
              isRecording = true;
              isReady = true;
              _inputData = [];
            });
          }
        });
      }
    }
    if (!isReady) {
      setState(() {
        isRecording = false;
      });
    }
  }

  disconnectFromDevice() {
    widget.device.disconnect();
    setState(() {
      isRecording = false;
      isReady = false;
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to disconnect device and go back?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
          TextButton(
              onPressed: () {
                disconnectFromDevice();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EcgBloc, EcgState>(
      listener: (context, state) {
        if (state.pageState.state == PageState.successState) {
          BlocProvider.of<EcgListBloc>(context).add(LoadData(loadMore: false));
          BlocProvider.of<EcgChartBloc>(context).add(InitEcgChart());
          Navigator.pop(context);
        } else if (state.pageState.state == PageState.failState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.pageState.message)));
        }
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: const Text("Optial ECG Sensor", style: TextStyle(color: primary)),
            foregroundColor: primary,
            automaticallyImplyLeading: true,
            actions: [
              TextButton.icon(
                onPressed: () async {
                  ecg.ecgData = _inputData;
                  BlocProvider.of<EcgBloc>(context).add(OnEcgChanged(ecg));
                },
                icon: const Icon(Icons.check_circle),
                label: const Text("Save"),
              ),
            ],
          ),
          body: !isRecording
              ? Column(
                  mainAxisAlignment: _inputData.isNotEmpty ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            discoverServices();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _inputData.isNotEmpty ? const Icon(Icons.repeat) : const SizedBox(),
                              SizedBox(width: _inputData.isNotEmpty ? m1 : 0),
                              Text(
                                _inputData.isNotEmpty ? "Record Again" : "START",
                                style: TextStyle(fontSize: _inputData.isNotEmpty ? fontSubTitle2 : fontH2),
                              ),
                            ],
                          )),
                    ),
                    _inputData.isNotEmpty ? OneLineChartViewEcg(_inputData, ECG_CHART) : const SizedBox()
                  ],
                )
              : !isReady && isRecording
                  ? const Center(
                      child: Text(
                        "Waiting....",
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    )
                  : isReady && isRecording
                      ? StreamBuilder<List<int>>(
                          stream: stream,
                          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Snapshot Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState == ConnectionState.active) {
                              var data = snapshot.data;
                              String currentValue = "";
                              if (data != null) {
                                currentValue = utf8.decode(data);
                                List<String> datas = currentValue.replaceAll("[", "").replaceAll("]", "").split(',');
                                List<int> a = [];
                                for (var data in datas) {
                                  a.add(int.tryParse(data) ?? 0);
                                }
                                _inputData.addAll(a);
                              }
                              return Column(
                                children: <Widget>[
                                  const Text('Sensor Values', style: TextStyle(fontSize: 14)),
                                  Text(_inputData.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                                ],
                              );
                            } else {
                              return const Text("Check the sensor value.");
                            }
                          },
                        )
                      : const SizedBox(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }
}
