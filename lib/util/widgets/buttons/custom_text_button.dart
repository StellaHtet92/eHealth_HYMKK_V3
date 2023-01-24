import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';

class CustomTextButton extends StatefulWidget{
  final String text;
  final Color? bgColor;
  final Function onPressed;

  const CustomTextButton({required this.text,this.bgColor,required this.onPressed,super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<CustomTextButton>{
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: widget.bgColor,
        foregroundColor: widget.bgColor == null ? primary: Colors.white,
      ),
      child: Text(widget.text,style: const TextStyle(fontSize: fontCaption)),
      onPressed: () {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: debounceTime), () {
          widget.onPressed();
        });
      },
    );
  }
}