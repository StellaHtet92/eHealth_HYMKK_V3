import 'package:ehealth/models/vital/vital.dart';
import 'package:flutter/cupertino.dart';
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

DateTime changeDateFormat(String date) {
  return DateTime.parse(date);
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

void showAppDatePicker(BuildContext ctx, {required Function onDateChanged}) {
  showCupertinoModalPopup(
    context: ctx,
    builder: (_) => Container(
      height: 250,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                dateOrder: DatePickerDateOrder.ydm,
                onDateTimeChanged: (val) {
                  onDateChanged(val);
                }),
          ),
          CupertinoButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    ),
  );
}

int calculateEWS(Vital vital) {
  if (vital.bpSys >= 0) {
    if (vital.bpSys >= 111 && vital.bpSys <= 249) {
      return vital.ews + 0;
    } else if (vital.bpSys >= 101 && vital.bpSys <= 110) {
      return vital.ews + 1;
    } else if (vital.bpSys >= 91 && vital.bpSys <= 100) {
      return vital.ews + 2;
    } else {
      return vital.ews + 3;
    }
  }
  if (vital.pulse >= 0) {
    if (vital.pulse >= 51 && vital.pulse <= 90) {
      return vital.ews + 0;
    } else if (vital.pulse >= 41 && vital.pulse <= 50) {
      return vital.ews + 1;
    } else if (vital.pulse >= 91 && vital.pulse <= 110) {
      return vital.ews + 1;
    } else if (vital.pulse >= 111 && vital.pulse <= 130) {
      return vital.ews + 2;
    } else {
      return vital.ews + 3;
    }
  }
  if (vital.spO2 >= 0) {
    if (vital.spO2 >= 96) {
      return vital.ews + 0;
    } else if (vital.spO2 >= 94 && vital.spO2 <= 95) {
      return vital.ews + 1;
    } else if (vital.spO2 >= 92 && vital.spO2 <= 93) {
      return vital.ews + 2;
    } else {
      return vital.ews + 3;
    }
  }
  if (vital.temp >= 0) {
    if (vital.temp >= 36.1 && vital.temp <= 38.0) {
      return vital.ews + 0;
    } else if (vital.temp >= 35.1 && vital.temp <= 36.0) {
      return vital.ews + 1;
    } else if (vital.temp >= 38.1 && vital.temp <= 39.0) {
      return vital.ews + 1;
    } else if (vital.temp >= 39.1) {
      return vital.ews + 2;
    } else {
      return vital.ews + 3;
    }
  }
  if (vital.resp_rate >= 0) {
    if (vital.resp_rate >= 12 && vital.resp_rate <= 20) {
      return vital.ews + 0;
    } else if (vital.resp_rate >= 9 && vital.resp_rate <= 11) {
      return vital.ews + 1;
    } else if (vital.resp_rate >= 21 && vital.resp_rate <= 24) {
      return vital.ews + 2;
    } else {
      return vital.ews + 3;
    }
  }
  return vital.ews;
}
