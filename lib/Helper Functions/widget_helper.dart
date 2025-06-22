// This file is responsible to communicate to the native service for the widget


import 'package:flutter/services.dart';

class AndroidWidgetUpdater {
  static const _channel = MethodChannel('com.example.sosapp/widget');

  static Future<void> triggerSos() async {
    try {
      await _channel.invokeMethod('triggerSos');
    } on PlatformException catch (e) {
      print("Failed to trigger SOS: '${e.message}'.");
    }
  }
}