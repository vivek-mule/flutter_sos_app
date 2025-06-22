// This file is responsible to communicate to the native service to send sms


import 'package:flutter/services.dart';

class SmsSender {
  static const MethodChannel _channel =
  MethodChannel('com.example.emergency_v1/sms');

  static Future<bool> sendSms(String phoneNumber, String message) async {
    try {
      final result = await _channel.invokeMethod('sendSms', {
        'phoneNumber': phoneNumber,
        'message': message,
      });
      return result == 'SMS_SENT';
    } on PlatformException catch (_) {
      return false; // failure
    }
  }
}
