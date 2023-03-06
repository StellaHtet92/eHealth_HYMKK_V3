import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/ui/account_register/views/gender_tab.dart';
import 'package:ehealth/ui/home/bloc/vital_chart_bloc.dart';
import 'package:ehealth/ui/home/bloc/vital_list_bloc.dart';
import 'package:ehealth/ui/vital/bloc/add_vital_bloc.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/style/customInputDecoration.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/vital_repo.dart';

class AddVitalPage extends StatelessWidget {
  const AddVitalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VitalBloc(VitalRepo()),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Vital vital = Vital();

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
              onPressed: () {
                FocusScope.of(context).unfocus();
                final form = _formKey.currentState;
                if (form?.validate() ?? false) {
                  form?.save();
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
                    const Text("SPO2", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
                    const SizedBox(height: m1),
                    TextFormField(
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
