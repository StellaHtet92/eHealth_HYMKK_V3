
import 'package:flutter/material.dart';
import 'package:ehealth/util/widgets/buttons/custom_text_button_icon.dart';

import '../values/colors.dart';
import '../values/values.dart';

class NoRecordView extends StatelessWidget{
  final Function _onTap;

  const NoRecordView(this._onTap,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No Record.",style: TextStyle(color: Colors.grey,fontSize: fontSubTitle2,fontWeight: FontWeight.bold),),
            const SizedBox(height: m2),
            CustomTextButtonIcon(
              text: 'Reload',
              icon: Icons.refresh,
              color: secondaryAccentColor,
              onPressed: () {
                _onTap();
              },
            ),
          ],
        )
    );
  }
}