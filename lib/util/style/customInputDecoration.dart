import 'package:flutter/material.dart';

InputDecoration customInputDeco(String hint, Icon? iconData,{String? suffix}){
  return InputDecoration(
    isDense: true,
    prefixIcon: iconData,
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 5.0),
    ),
    hintText: hint,
    suffix: Text(suffix ?? ""),
    contentPadding: const EdgeInsets.all(11.0),
  );
}