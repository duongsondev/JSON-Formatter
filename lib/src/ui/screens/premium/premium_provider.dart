import 'package:json_formatter/src/utils/common_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumState {
  CommonState isState;
  List<ProductDetails> products = List<ProductDetails>();
  bool isAvailablePurchase;

  PremiumState(
      {this.isState = CommonState.Loading,
      this.products,
      this.isAvailablePurchase = false});

  PremiumState copyWith(
      {isState, List<ProductDetails> products, isAvailablePurchase}) {
    return PremiumState(
        isState: isState ?? this.isState,
        products: products ?? this.products,
        isAvailablePurchase: isAvailablePurchase ?? this.isAvailablePurchase);
  }
}

final premiumProvider = StateNotifierProvider<PremiumProvider, PremiumState>(
    (ref) => PremiumProvider());

class PremiumProvider extends StateNotifier<PremiumState> {
  PremiumProvider() : super(PremiumState());

  void init() async {
    try {
      final bool available =
          await InAppPurchaseConnection.instance.isAvailable();
      if (!available) {
        state = state.copyWith(
            products: [],
            isState: CommonState.Success,
            isAvailablePurchase: false);
      } else {
        const Set<String> _kIds = {
          'premium_week',
          //'android.test.purchased',
          'premium_1_month',
          'premium_3_month',
          'premium_6_month',
          'premium_year'
        };
        final ProductDetailsResponse response =
            await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
        List<ProductDetails> products = response.productDetails;
        state = state.copyWith(
            products: products,
            isState: CommonState.Success,
            isAvailablePurchase: true);
      }
    } catch (ex) {
      print("/// ${ex.toString()}");
      state = state.copyWith(
          products: [], isState: CommonState.Error, isAvailablePurchase: false);
    }
  }
}
