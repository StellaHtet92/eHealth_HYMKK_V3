import 'package:ehealth/repository/account_repo.dart';
import 'package:ehealth/repository/ecg_repo.dart';
import 'package:ehealth/repository/vital_repo.dart';
import 'package:ehealth/routing/redirect_config.dart';
import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/routing/router.dart';
import 'package:ehealth/ui/account_register/account_register_one.dart';
import 'package:ehealth/ui/account_register/account_register_three.dart';
import 'package:ehealth/ui/account_register/account_register_two.dart';
import 'package:ehealth/ui/account_register/bloc/account_register_bloc.dart';
import 'package:ehealth/ui/basic_info/basic_info.dart';
import 'package:ehealth/ui/ecg/add_ecg_page_one.dart';
import 'package:ehealth/ui/ecg/add_ecg_page_two.dart';
import 'package:ehealth/ui/ecg/bloc/add_ecg_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_chart_bloc.dart';
import 'package:ehealth/ui/home/bloc/ecg_list_bloc.dart';
import 'package:ehealth/ui/home/bloc/vital_chart_bloc.dart';
import 'package:ehealth/ui/home/bloc/vital_list_bloc.dart';
import 'package:ehealth/ui/home/home_page.dart';
import 'package:ehealth/ui/login/login_page.dart';
import 'package:ehealth/ui/profile/profile_page.dart';
import 'package:ehealth/ui/vital/add_vital_page.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RedirectPage page = await checkSession();

  runApp(MyApp(page: page));
}

class MyApp extends StatelessWidget {
  final RedirectPage page;

  const MyApp({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountRegisterBloc(AccountRepo()),
        ),
        BlocProvider(
          create: (context) => VitalChartBloc(VitalRepo()),
        ),
        BlocProvider(
          create: (context) => VitalListBloc(VitalRepo()),
        ),
        /*BlocProvider(
          create: (context) => EcgChartBloc(EcgRepo()),
        ),
        BlocProvider(
          create: (context) => EcgListBloc(EcgRepo()),
        )*/
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Health',
        theme: ThemeData(
          primarySwatch: primary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case loginRoute:
              return getPageRoute(LoginPage(), settings);
            case registerOneRoute:
              return getPageRoute(const AccountRegisterOne(), settings);
            case registerTwoRoute:
              return getPageRoute(const AccountRegisterTwo(), settings);
            case registerThreeRoute:
              return getPageRoute(const AccountRegisterThree(), settings);
            case homeRoute:
              return getPageRoute(const HomePage(), settings);
            case addVitalRoute:
              return getPageRoute(const AddVitalPage(), settings);
            case searchEcgDeviceRoute:
              return getPageRoute(const AddEcgPageOne(), settings);
            case getEcgResultsRoute:
              BluetoothDevice param = settings.arguments as BluetoothDevice;
              return getPageRoute(AddEcgPageTwo(device: param), settings);
            case basicInfoRoute:
              return getPageRoute(const BasicInfoPage(), settings);
            case profileRoute:
              return getPageRoute(const ProfilePage(), settings);
          }
        },
        initialRoute: page == RedirectPage.login ? loginRoute : homeRoute,
      ),
    );
  }
}
