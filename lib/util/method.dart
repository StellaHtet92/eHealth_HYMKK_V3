import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'values/colors.dart';
import 'values/values.dart';

showToast(String msg, BuildContext context, {Color? bgColor, IconData? icon, Color? textColor}) {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: bgColor ?? toastBackgroundColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.error, color: textColor ?? toastBodyColor),
            const SizedBox(
              width: 12.0,
            ),
            Flexible(child: Text(msg, style: TextStyle(fontSize: fontCaption, color: textColor ?? toastBodyColor)))
          ],
        ),
      ),
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 4),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: 70.0,
          left: 8,
          right: 8,
        );
      });
}

DateTime changeDateFormat(String date){
  return  DateTime.parse(date);
}

String changeDateFormat1(String date) {
  if (date != "") {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat("MMM dd, yyyy").format(dateTime);
    return formattedDate;
  }
  return "";
}

String changeDateTimeFormatForGraph(String date) {
  if (date != "") {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat("MMM dd, hh:mm a").format(dateTime);
    return formattedDate;
  }
  return "";
}
