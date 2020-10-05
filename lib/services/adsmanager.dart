import 'dart:io';

class AdManager {

  String appId() {
    if(Platform.isAndroid){
      return "ca-app-pub-6018702380435080~9322156402";
    } else{
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String bannerAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-6018702380435080/7434359666";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String interstitialAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-6018702380435080/3906194102";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  String rewardedAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-6018702380435080/6547302336";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}