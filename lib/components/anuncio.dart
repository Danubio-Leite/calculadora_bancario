import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MeuAnuncio extends StatefulWidget {
  const MeuAnuncio({super.key});

  @override
  _MeuAnuncioState createState() => _MeuAnuncioState();
}

class _MeuAnuncioState extends State<MeuAnuncio> {
  BannerAd? _ad;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: 'ca-app-pub-7650890469175543/2611614609',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) {
          print('Ad opened');
        },
        onAdClosed: (Ad ad) {
          print('Ad closed');
        },
        onAdImpression: (Ad ad) {
          print('Ad impression');
        },
      ),
    );

    _ad?.load();
  }

  @override
  Widget build(BuildContext context) {
    return isAdLoaded
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: AdWidget(ad: _ad!),
          )
        : Container();
  }

  @override
  void dispose() {
    super.dispose();
    _ad?.dispose();
  }
}
