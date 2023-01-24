import 'package:flutter/material.dart';
import 'package:ehealth/util/widgets/buttons/custom_text_button_icon.dart';

import '../values/colors.dart';
import '../values/values.dart';

class LoadFailWidget extends StatelessWidget {
  final Function _onTap;
  final String message;

  const LoadFailWidget(this._onTap, this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(m1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: TextStyle(color: Colors.grey[500]), textAlign: TextAlign.center),
            const SizedBox(height: m1),
            CustomTextButtonIcon(
              text: 'Try Again',
              icon: Icons.refresh,
              color: secondaryAccentColor,
              onPressed: () {
                _onTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
