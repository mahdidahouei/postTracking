import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlatformChannel {
  static const platform = MethodChannel('post.mahdidahouei.com/tracking');

  Future<void> openVpnSettings() async {
    try {
      await platform.invokeMethod('openVpnSettings');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
