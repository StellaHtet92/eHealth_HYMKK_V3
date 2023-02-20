import 'package:ehealth/ui/home/bloc/home_page_bloc.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisplayTypeView extends StatelessWidget {
  const DisplayTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(right: m1,top: m1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                BlocProvider.of<HomePageBloc>(context).add(OnChangeDisplayType(DisplayType.Chart.name));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: state.displayType == DisplayType.Chart.name ? primary[100] : Colors.white,
                  border: Border.all(color: primary[100]!),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    topLeft: Radius.circular(0.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: m2, vertical: p2),
                child: FaIcon(
                  FontAwesomeIcons.chartLine,
                  size: 16,
                  color: state.displayType == DisplayType.Chart.name ? primary : primary[100],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<HomePageBloc>(context).add(OnChangeDisplayType(DisplayType.List.name));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: state.displayType == DisplayType.List.name ? primary[100] : Colors.white,
                  border: Border.all(color: primary[100]!),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: m2, vertical: p2),
                child: FaIcon(
                  Icons.list_alt,
                  size: 16,
                  color: state.displayType == DisplayType.List.name ? primary : primary[100],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
