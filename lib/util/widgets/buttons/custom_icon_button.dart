import 'dart:async';

import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final Icon icon;
  final Function onPressed;
  final String toolTip;

  const CustomIconButton( {required this.icon,required this.toolTip,required this.onPressed, super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<CustomIconButton> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: debounceTime), () {
          widget.onPressed();
        });
      },
      tooltip: widget.toolTip,
      icon: widget.icon,
    );
  }
}
