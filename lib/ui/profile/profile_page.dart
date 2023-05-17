import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/profile/bloc/profile_bloc.dart';
import 'package:ehealth/util/models/page_state.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:ehealth/util/widgets/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(repo:AccountRepo())..add(Init()),
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

  Widget _infoView({required String title, required String data}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(p5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: fontSubTitle2, color: Colors.grey[600])),
            const SizedBox(height: m1),
            Text(data, style: const TextStyle(fontSize: fontSubTitle)),
          ],
        ),
      ),
    );
  }

  Widget _labeledTextView({required String label, required String value}) {
    return  RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black
        ),
        children: [
          TextSpan(
            text: label.isNotEmpty ? '${label}: ' : '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '${value}',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text("Profile"),
        foregroundColor: primary,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: m3, horizontal: m1),
        child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          return state.pageState.state == PageState.pageLoadedState? ListView(
            children: [
              const Text("Personal Details", style: TextStyle(fontSize: fontSubTitle, fontWeight: FontWeight.bold)),
              const SizedBox(height: m2),
              _infoView(title: "User Name", data: state.profile?.user.username ?? ""),
              const SizedBox(height: m1),
              _infoView(title: "Full Name", data: state.profile?.user.fullname ?? ""),
              const SizedBox(height: m1),
              _infoView(title: "Mobile", data: state.profile?.user.mobile ?? "-"),
              const SizedBox(height: m1),
              _infoView(title: "Date of birth", data: state.profile?.user.dob ?? "-"),
              const SizedBox(height: m1),
              _infoView(title: "Gender", data: state.profile?.user.gender ?? "-"),
              const SizedBox(height: m1),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(p5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Basic Info", style: TextStyle(fontSize: fontSubTitle2, color: Colors.grey[600])),
                      const SizedBox(height: m1),
                      _labeledTextView(label: "Blood Type",value: state.profile?.userDetail.bloodType ?? "-"),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "HCV",value: state.profile?.userDetail.hcv ?? false ? "Positive": "Negative" ),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "HCB",value: state.profile?.userDetail.hcb ?? false ? "Positive": "Negative" ),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "TB",value: state.profile?.userDetail.tb ?? false ? "Positive": "Negative" ),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "HIV",value: state.profile?.userDetail.hiv ?? false ? "Positive": "Negative" ),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "Diabetes",value: state.profile?.userDetail.diabetes ?? false ? "Positive": "Negative" ),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "Others",value: state.profile?.userDetail.other ?? "-"),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "Allergies",value: state.profile?.userDetail.allergies ?? "-"),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "Weight",value: "${state.profile?.userDetail.weight ?? "-"}"),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "Height",value: "${state.profile?.userDetail.height ?? "-"}"),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "BMI",value: "${state.profile?.userDetail.bmi ?? "-"}"),
                      const SizedBox(height: p2),
                      _labeledTextView(label: "Smoking Status",value: state.profile?.userDetail.diabetes ?? false ? "Smoking": "No Smoking" ),
                      const SizedBox(height: p2),
                      state.profile?.userDetail.diabetes ?? false ? _labeledTextView(label: "No. of cigarette per day",value: "${state.profile?.userDetail.noOfCigaPerDay}"): const SizedBox(),
                      const SizedBox(height: m2),
                      Center(
                        child: TextButton(onPressed: (){
                          Navigator.pop(context);
                          Navigator.pushNamed(context, basicInfoRoute);
                        }, child: Text("Update Basic Info")),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: m1),
              InkWell(
                onTap: (){
                  UserPref().removeSession();
                  Navigator.pushNamed(context, loginRoute);
                },
                child: const Card(
                  child: Padding(
                    padding:  EdgeInsets.all(m2),
                    child: Center(
                      child: Text("Logout", style:  TextStyle(fontSize: fontSubTitle,color: primary)),
                    ),
                  ),
                ),
              )
            ],
          ): const LoadingCircle();
        }),
      ),
    );
  }
}
