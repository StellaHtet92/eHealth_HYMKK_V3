import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ehealth/util/values/values.dart';

class CustomTextButtonIcon extends StatefulWidget{
  final String text;
  final IconData icon;
  final Color color;
  final Function onPressed;

  const CustomTextButtonIcon({required this.text,required this.icon,required this.color,required this.onPressed,super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<CustomTextButtonIcon>{
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: debounceTime), () {
          widget.onPressed();
        });
      },
      icon: Icon(widget.icon, size: 16.0),
      label: Text(
        widget.text,
        style: const TextStyle(fontSize: fontSubTitle4),
      ),
    );
  }
}