import 'dart:async';
import 'dart:convert' show utf8;

import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/ui/ecg/bloc/add_ecg_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_chart_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_list_bloc.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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

  _Stateful(this.device);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<_Stateful> {
  late Interpreter _interpreter;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";

  //final String SERVICE_UUID= "4c018b6e-5b32-4768-a4ff-c35bfa3ccbf9";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady = false;
  late Stream<List<int>>? stream;
  List<int> _inputData = [];

  Ecg ecg = Ecg();

  @override
  void initState() {
    super.initState();
    discoverServices();
  }

  /*connectToDevice() async{
    if(widget.device == null)
    {
      _Pop();
      return;
    }
    new Timer(const Duration(seconds: 15),(){
      if(!isReady)
      {
        disconnectFromDevice();
        _Pop();
      }
    });
    //await widget.device.connect();
    discoverServices();
  }*/
  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }
    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _Pop();
      return;
    }
    await widget.device.connect();
    List<BluetoothService> services = await widget.device.discoverServices();
    //List<BluetoothCharacteristic> characteristics;
    //BluetoothCharacteristic ss; //https://github.com/pauldemarco/flutter_blue/issues/295
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            /*ss=characteristic;
            await ss.setNotifyValue(true);
            ss.value.listen((value) {
              //_status = value.elementAt(0);
              stream=ss.value;
            }*/
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    }

    if (!isReady) {
      _Pop();
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: [
                new TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No')),
                new TextButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes')),
              ],
            ));
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    print(dataFromDevice);
    return utf8.decode(dataFromDevice);
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.pageState.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title:
              const Text("Optial ECG Sensor", style: TextStyle(color: primary)),
          foregroundColor: primary,
          automaticallyImplyLeading: true,
          actions: [
            TextButton.icon(
              onPressed: () async {
                //disconnectFromDevice();
                ecg.ecgData = _inputData;
                BlocProvider.of<EcgBloc>(context).add(OnEcgChanged(ecg));
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Save"),
            ),
            TextButton.icon(
              onPressed: () async {
                disconnectFromDevice();
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Disconnect"),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              !isReady
                  ? const Center(
                      child: Text(
                        "Waiting....",
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    )
                  : StreamBuilder<List<int>>(
                    stream: stream,
                    builder: (BuildContext context,
                    AsyncSnapshot<List<int>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Snapshot Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    var data = snapshot.data;
                    String currentValue = "";
                    if (data != null) {
                      currentValue = _dataParser(data);
                      print(currentValue);
                      List<String> datas = currentValue
                          .replaceAll("[", "")
                          .replaceAll("]", "")
                          .split(',');
                      List<int> a = [];
                      for (var data in datas) {
                        a.add(int.tryParse(data) ?? 0);
                      }
                      //currentValue=(double.tryParse(currentValue)!/4095)!;
                      //print(double.tryParse(currentValue));
                      _inputData.addAll(a);
                    }
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children:<Widget>[
                              const Text('Current Sensor Value',
                              style: TextStyle(fontSize: 14)),
                              Text('$currentValue mV',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24)),
                        ],
                        ),
                        /*Expanded(

                            child:BlocBuilder<EcgBloc, EcgState>(
                                    builder: (context, state) {
                                      //return OneLineChartViewEcg(state.ecg.ecgData,ECG_CHART);
                                      return OneLineChartViewEcg(_inputData,ECG_CHART);
                                    }
                                    ),
                        ),*/

                      ],

                     );
                  } else {
                    return const Text('Check the Stream');
                  }
                    },
                  )
            ],
          ),
        ),
        ),
      );
  }
}
