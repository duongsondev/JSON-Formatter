import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  Future<dynamic> push(Widget Function(BuildContext context) builder,
      {String name}) {
    if (Platform.isAndroid) {
      return Navigator.of(this).push(MaterialPageRoute(
          builder: builder, settings: RouteSettings(name: name)));
    } else {
      return Navigator.of(this).push(CupertinoPageRoute(
          builder: builder, settings: RouteSettings(name: name)));
    }
  }

  void pop([dynamic result]) {
    Navigator.of(this).pop(result);
  }

  void popToRoot() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  Future<dynamic> pushReplacement(Widget Function(BuildContext context) builder,
      {dynamic result}) {
    if (Platform.isAndroid) {
      return Navigator.of(this)
          .pushReplacement(MaterialPageRoute(builder: builder), result: result);
    } else {
      return Navigator.of(this).pushReplacement(
          CupertinoPageRoute(builder: builder),
          result: result);
    }
  }
}
