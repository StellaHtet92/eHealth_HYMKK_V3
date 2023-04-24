import 'package:ehealth/core/user_pref.dart';
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
      create: (context) => ProfileBloc()..add(Init()),
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
              _infoView(title: "User Name", data: state.accInfo.username),
              const SizedBox(height: m1),
              _infoView(title: "Full Name", data: state.accInfo.fullname),
              const SizedBox(height: m1),
              _infoView(title: "Mobile", data: state.accInfo.mobile ?? "-"),
              const SizedBox(height: m1),
              _infoView(title: "Date of birth", data: state.accInfo.dob),
              const SizedBox(height: m1),
              _infoView(title: "Gender", data: state.accInfo.gender ?? "-"),
              const SizedBox(height: m1),
              /*Card(
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
              ),*/
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
