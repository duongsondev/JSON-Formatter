
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_formatter/src/configs/app_theme.dart';

class AppErrorWidget extends StatelessWidget {
  String title;

  AppErrorWidget({this.title = 'Error'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: appFontMedium,
      ),
    );
  }
}
