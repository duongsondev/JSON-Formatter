
import 'package:json_formatter/src/ui/screens/home/home_screens.dart';
import 'package:flutter/material.dart';

import 'configs/app_string.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      title: appString.appName,
      home: HomeScreens(),
    );
  }
}
