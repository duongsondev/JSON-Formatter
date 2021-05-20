import 'package:json_formatter/src/configs/app_color.dart';
import 'package:json_formatter/src/configs/app_size.dart';
import 'package:json_formatter/src/configs/app_theme.dart';
import 'package:json_formatter/src/ui/screens/premium/premium_screens.dart';
import 'package:json_formatter/src/ui/widgets/width.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_formatter/src/utils/context_extensions.dart';

class ButtonPremiumWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: () {
          context.push((context) => PremiumScreens());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.checkmark_seal,
              color: Colors.white,
            ),
            Width(5.0),
            Text("Buy Premium",
                style: appFontMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
