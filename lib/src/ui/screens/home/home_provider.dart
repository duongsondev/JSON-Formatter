import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'home_screens.dart';

class HomeState {
  bool isRemoveAds;
  int countTapViewAds;

  HomeState({this.isRemoveAds = false, this.countTapViewAds = 0});

  copyWith({bool isRemoveAds, int countTapViewAds}) => HomeState(
      isRemoveAds: isRemoveAds ?? this.isRemoveAds,
      countTapViewAds: countTapViewAds ?? this.countTapViewAds);
}

final homeProvider =
    StateNotifierProvider<HomeProvider, HomeState>((ref) => HomeProvider());

class HomeProvider extends StateNotifier<HomeState> {
  HomeProvider() : super(HomeState());

  Future<void> checkPurchased() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      final QueryPurchaseDetailsResponse response =
          await InAppPurchaseConnection.instance.queryPastPurchases();
      if (response.error != null) {
        print("Error");
      } else {
        for (PurchaseDetails purchase in response.pastPurchases) {
          if (purchase.status == PurchaseStatus.purchased) {
            InAppPurchaseConnection.instance.completePurchase(purchase);
            state = state.copyWith(isRemoveAds: true);
            return;
          }
        }
      }
    }
  }

  Future<void> checkShowAds() async {
    if (state.countTapViewAds == 3 && !state.isRemoveAds) {
      if (await HomeScreens.interstitialAd.isLoaded()) {
        await HomeScreens.interstitialAd.show();
      }
    }
  }

  void changeCountViewAds() {
    var tap = state.countTapViewAds;
    tap++;
    state = state.copyWith(countTapViewAds: tap > 5 ? 0 : tap);
    checkShowAds();
  }

  String onFormatterJSON(String data) {
    var result = "";
    try {
      var jsonData = json.decode(data.replaceAll('\'', '\"'));
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      result = encoder.convert(jsonData);
      print(result);
    } catch (ex) {
      print(ex.toString());
      result = 'error';
    }
    return result;
  }
}
