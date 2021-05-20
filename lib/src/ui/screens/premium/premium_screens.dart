import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_formatter/src/configs/app_color.dart';
import 'package:json_formatter/src/configs/app_size.dart';
import 'package:json_formatter/src/configs/app_theme.dart';
import 'package:json_formatter/src/ui/screens/home/home_provider.dart';
import 'package:json_formatter/src/ui/screens/home/home_screens.dart';
import 'package:json_formatter/src/ui/screens/premium/premium_description_widget.dart';
import 'package:json_formatter/src/ui/widgets/error_widget.dart';
import 'package:json_formatter/src/ui/widgets/processing_widget.dart';
import 'package:json_formatter/src/utils/common_state.dart';
import 'package:json_formatter/src/utils/context_extensions.dart';

import 'premium_provider.dart';

class PremiumScreens extends StatefulWidget {
  @override
  _PremiumScreensState createState() => _PremiumScreensState();
}

class _PremiumScreensState extends State<PremiumScreens> {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print("////////sub done");
    }, onError: (err) {
      print("///////sub error");
    }, cancelOnError: false);
    context.read(premiumProvider.notifier).init();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("-------------Pendding");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('High-end purchase failed.')));
          print("--------error");
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Purchased successfully.')));
          print("-----------purchased");
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
          await context.read(homeProvider.notifier).checkPurchased();
          context.popToRoot();
          context.pushReplacement((context) => HomeScreens());
          print("-----------pendingCompletePurchase");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Premium'),
        backgroundColor: appColor.mainColor,
        elevation: 0.0,
      ),
      body: Consumer(builder: (ctx, w, _) {
        var state = w(premiumProvider);
        if (state.isState == CommonState.Success) {
          if (state.products.isEmpty) {
            return Center(
              child: Text(
                'Unable to make payment!',
                style: appFontMedium,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    var product = state.products[index];
                    return Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(appSize.sizeRadius)),
                      child: ListTile(
                        title: Text(
                          product.title,
                          style: appFontBold,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description,
                              style: appFontRegular,
                            ),
                            Text(
                              product.price,
                              style: appFontSemiBold.copyWith(
                                  color: Colors.orange, fontSize: 16.0),
                            )
                          ],
                        ),
                        trailing: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(appSize.sizeRadius)),
                          child: Text(
                            "Buy",
                            style:
                                appFontMedium.copyWith(color: Colors.white),
                          ),
                          color: appColor.mainColor,
                          onPressed: () async {
                            final PurchaseParam purchaseParam =
                                PurchaseParam(productDetails: product);
                            await InAppPurchaseConnection.instance.buyConsumable(
                              purchaseParam: purchaseParam,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              PremiumDescriptionWidget()
            ],
          );
        } else if (state.isState == CommonState.Error) {
          return AppErrorWidget(
            title: 'Please try again later!',
          );
        } else {
          return ProcessingWidget();
        }
      }),
    );
  }
}
