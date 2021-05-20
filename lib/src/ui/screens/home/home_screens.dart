import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:json_formatter/src/configs/app_admob.dart';
import 'package:json_formatter/src/configs/app_color.dart';
import 'package:json_formatter/src/configs/app_size.dart';
import 'package:json_formatter/src/configs/app_string.dart';
import 'package:json_formatter/src/ui/screens/home/button_premium_widget.dart';
import 'home_provider.dart';

class HomeScreens extends StatefulWidget {
  static InterstitialAd interstitialAd;

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  static final AdRequest request = AdRequest(
    keywords: <String>['json formatter', 'flutter'],
    nonPersonalizedAds: true,
  );
  TextEditingController _controllerInput;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((value) {
        createInterstitialAd();
      });
    });
    _controllerInput = TextEditingController();
    context.read(homeProvider.notifier).checkPurchased();
  }

  void createInterstitialAd() {
    HomeScreens.interstitialAd ??= InterstitialAd(
      adUnitId: appAdMob.interstitialAds,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          HomeScreens.interstitialAd = null;
          createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          ad.load();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    HomeScreens.interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(appString.appName),
        backgroundColor: appColor.mainColor,
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Consumer(builder: (ctx, w, _) {
        var state = w(homeProvider);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColor.mainColor,
            title: Text(appString.appName),
            actions: [ButtonPremiumWidget()],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerInput,
                    textInputAction: TextInputAction.done,
                    maxLines: double.maxFinite.toInt(),
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "JSON input",
                      labelText: "JSON input",
                      fillColor: Color(0xffEBEBEB),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.circular(appSize.sizeRadius)),
                    ),
                  ),
                ),
                _buildJsonControlWidget()
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildJsonControlWidget() {
    return Column(
      children: [
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(appSize.sizeRadius)),
          textColor: Colors.white,
          color: Colors.green,
          onPressed: () {
            _onFormatterJSON();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.play_arrow), Text(" Format")],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCopyPasteAndClearWidget(paste: true),
            _buildCopyPasteAndClearWidget(),
            _buildClearWidget()
          ],
        )
      ],
    );
  }

  Widget _buildCopyPasteAndClearWidget({bool paste = false}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appSize.sizeRadius)),
      textColor: appColor.mainColor,
      color: appColor.mainColor.withOpacity(0.25),
      elevation: 0,
      onPressed: () async {
        context.read(homeProvider.notifier).changeCountViewAds();
        if (paste) {
          _controllerInput.text = (await Clipboard.getData('text/plain')).text;
        } else {
          Clipboard.setData(ClipboardData(text: _controllerInput.text));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(paste ? Icons.paste : Icons.copy),
          Text("${paste ? " Paste" : " Copy"}")
        ],
      ),
    );
  }

  Widget _buildClearWidget() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appSize.sizeRadius)),
      textColor: Colors.red,
      color: Colors.red.withOpacity(0.25),
      elevation: 0,
      onPressed: () async {
        context.read(homeProvider.notifier).changeCountViewAds();
        _controllerInput.clear();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.clear_all), Text(" Clear")],
      ),
    );
  }

  void _onFormatterJSON() {
    context.read(homeProvider.notifier).changeCountViewAds();
    var res = context
        .read(homeProvider.notifier)
        .onFormatterJSON(_controllerInput.text);
    if (res == 'error') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("The json data is malformed")));
    }
    _controllerInput.text = res;
  }
}
