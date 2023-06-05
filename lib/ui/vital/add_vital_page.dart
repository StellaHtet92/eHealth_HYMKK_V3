//for tensor flow model
import 'dart:typed_data';

import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/ui/account_register/views/gender_tab.dart';
import 'package:ehealth/ui/home/bloc/vital_chart_bloc.dart';
import 'package:ehealth/ui/home/bloc/vital_list_bloc.dart';
import 'package:ehealth/ui/vital/bloc/add_vital_bloc.dart';
import 'package:ehealth/util/method.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../repository/vital_repo.dart';
//for tensor flow model
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class AddVitalPage extends StatelessWidget {
  const AddVitalPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => VitalBloc(VitalRepo())..add(LoadUserSession()),
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
  late Interpreter _interpreter;
  late Float32List _inputData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bpSysCtl = TextEditingController();
  final TextEditingController _bpDiaCtl = TextEditingController();
  final TextEditingController _pulseCtl = TextEditingController();
  final TextEditingController _heartRateCtl = TextEditingController();
  final TextEditingController _spO2Ctl = TextEditingController();
  final TextEditingController _tempCtl = TextEditingController();
  final TextEditingController _bloodSugarLevelCtl = TextEditingController();
  final TextEditingController _respRateCtl = TextEditingController();
  final TextEditingController _lmpCtl = TextEditingController();

  Vital vital = Vital();

  @override
  void initState() {
    super.initState();
    loadModel();
    // Initialize _interpreter
    /*_interpreter = Interpreter.fromAsset('latest_generated.tflite').then((value) {
      setState(() {
        _interpreter = value;
      });
    }).catchError((error) {
      print('Failed to load model: $error');
    }) as Interpreter;*/
  }

  void _prepareInputData(Vital vital) {
    _inputData = Float32List.fromList([27.0, vital.heartRate.toDouble(), vital.bpSys.toDouble(), vital.bpDia.toDouble(), vital.resp_rate, vital.temp, vital.spO2,vital.bloodSugarLevel,vital.ews.toDouble()]);
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('latest_generated.tflite');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  double _runModel() {
    var output = 0.0;
    _interpreter.run(_inputData,output);
    // print the output
    print(output);
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VitalBloc, VitalState>(
      listener: (context, state) {
        if (state.pageState.state == PageState.successState) {
          BlocProvider.of<VitalListBloc>(context).add(LoadData(loadMore: false));
          BlocProvider.of<VitalChartBloc>(context).add(InitVitalChart());
          Navigator.pop(context);
        } else if (state.pageState.state == PageState.failState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.pageState.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text("Add Vital", style: TextStyle(color: primary)),
          foregroundColor: primary,
          automaticallyImplyLeading: true,
          actions: [
            TextButton.icon(

              onPressed: () async {
                FocusScope.of(context).unfocus();
                final form = _formKey.currentState;
                if (form?.validate() ?? false) {

                  form?.save();
                  vital.ews = calculateEWS(vital);

                  if (_interpreter != null) {
                    // Prepare the input data
                    _prepareInputData(vital);
                    final numberOutput = _runModel();
                    vital.alert=numberOutput.round();
                    print('Number output of machine learning classifier: $numberOutput');
                  }
                  BlocProvider.of<VitalBloc>(context).add(OnSaveEvent(vital));

                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Save"),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(top: m1, bottom: m5),
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Blood Pressure", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bpSysCtl,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "* required";
                              } else {
                                int? data = int.tryParse(value!);
                                return data != null ? null : "* invalid.";
                              }
                            },
                            decoration: customInputDeco("Systolic", null),
                            onSaved: (String? data) {
                              vital.bpSys = int.parse(data!);
                            },
                          ),
                        ),
                        const SizedBox(width: m1),
                        Expanded(
                          child: TextFormField(
                            controller: _bpDiaCtl,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "* required";
                              } else {
                                int? data = int.tryParse(value!);
                                return data != null ? null : "* invalid.";
                              }
                            },
                            decoration: customInputDeco("Diastolic", null),
                            onSaved: (String? data) {
                              vital.bpDia = int.parse(data!);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: m1),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pulse", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    TextFormField(
                      controller: _pulseCtl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "* required";
                        } else {
                          int? data = int.tryParse(value!);
                          return data != null ? null : "* invalid.";
                        }
                      },
                      decoration: customInputDeco("", null, suffix: "min"),
                      onSaved: (String? data) {
                        vital.pulse = int.parse(data!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: m1),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Heart Rate", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    TextFormField(
                      controller: _heartRateCtl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "* required";
                        } else {
                          int? data = int.tryParse(value!);
                          return data != null ? null : "* invalid.";
                        }
                      },
                      decoration: customInputDeco("", null, suffix: "bpm"),
                      onSaved: (String? data) {
                        vital.heartRate = int.parse(data!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: m1),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Respiratory Rate", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    TextFormField(
                      controller: _respRateCtl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "* required";
                        } else {
                          double? data = double.tryParse(value!);
                          return data != null ? null : "* invalid.";
                        }
                      },
                      decoration: customInputDeco("", null, suffix: "min"),
                      onSaved: (String? data) {
                        vital.resp_rate = double.parse(data!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: m1),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("SPO2", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    TextFormField(
                      controller: _spO2Ctl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "* required";
                        } else {
                          double? data = double.tryParse(value!);
                          return data != null ? null : "* invalid.";
                        }
                      },
                      decoration: customInputDeco("", null),
                      onSaved: (String? data) {
                        vital.spO2 = double.parse(data!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: m1),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Body Temperature", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    TextFormField(
                      controller: _tempCtl,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "* required";
                        } else {
                          double? data = double.tryParse(value!);
                          return data != null ? null : "* invalid.";
                        }
                      },
                      decoration: customInputDeco("", null, suffix: "°C"),
                      onSaved: (String? data) {
                        vital.temp = double.parse(data!);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: m1),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(m2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Blood Sugar Level", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Expanded(
                            child: GenderTab(
                              onChange: (String title) {
                                setState(() {
                                  vital.isBeforeMeal = true;
                                });
                              },
                              selectedTab: vital.isBeforeMeal ? 'Pre-Meal' : 'Post-Meal',
                              tabTitle: 'Pre-Meal',
                            ),
                          ),
                          Expanded(
                            child: GenderTab(
                              onChange: (String title) {
                                setState(() {
                                  vital.isBeforeMeal = false;
                                });
                              },
                              selectedTab: vital.isBeforeMeal ? 'Pre-Meal' : 'Post-Meal',
                              tabTitle: 'Post-Meal',
                            ),
                          )
                        ]),
                        const SizedBox(height: m1),
                        TextFormField(
                          controller: _bloodSugarLevelCtl,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "* required";
                            } else {
                              double? data = double.tryParse(value!);
                              return data != null ? null : "* invalid.";
                            }
                          },
                          decoration: customInputDeco("", null, suffix: "mmol/L"),
                          onSaved: (String? data) {
                            vital.bloodSugarLevel = double.parse(data!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: m1),
              BlocBuilder<VitalBloc, VitalState>(builder: (context, state) {
                return state.account?.gender == Gender.Female.name
                    ? Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(m2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Last Menstruation Date", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                            const SizedBox(height: m1),
                            InkWell(
                              onTap: () {
                                showAppDatePicker(context, onDateChanged: (val) {
                                  _lmpCtl.text = changeDateFormat1(val.toString());
                                  vital.lastMenDate = val.toString();
                                });
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: _lmpCtl,
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return "* required";
                                  }
                                },
                                decoration: customInputDeco("", null),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
