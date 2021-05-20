
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_formatter/src/configs/app_theme.dart';

import 'height.dart';

class ProcessingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(),
          Height(5.0),
          Text(
            'Processing...',
            style: appFontMedium,
          )
        ],
      ),
    );
  }
}
