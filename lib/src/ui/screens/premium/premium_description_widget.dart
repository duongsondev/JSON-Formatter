import 'package:flutter/material.dart';
import 'package:json_formatter/src/configs/app_color.dart';
import 'package:json_formatter/src/configs/app_theme.dart';
import 'package:json_formatter/src/ui/widgets/height.dart';

class PremiumDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Premium benefits",
            style: appFontBold.copyWith(fontSize: 16.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "√ No ads",
              style: appFontMedium.copyWith(color: appColor.mainColor),
            ),
          ),
          Height(10.0),
          Text(
            "Your subscription will auto-renew and you will be charged the amount specified above each week, month, 3 month, 6 month or year (as applicable) until you cancel your subcription before the end of the then-current subscription period.",
            style: appFontRegular.copyWith(color: Colors.blueGrey),
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
