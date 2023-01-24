import 'package:ehealth/util/values/colors.dart';
import 'package:ehealth/util/values/values.dart';
import 'package:flutter/material.dart';

class GenderTab extends StatelessWidget {
  final Function onChange;
  final String selectedTab;
  final String tabTitle;

  GenderTab({
    required this.onChange,
    required this.selectedTab,
    required this.tabTitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(tabTitle);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedTab == tabTitle ? primary : Colors.white,
          border: Border.all(color: Colors.grey,width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: m1, vertical: m1),
        child: Text(
          tabTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color:  selectedTab == tabTitle ? Colors.white: Colors.black),
        ),
      ),
    );
  }
}