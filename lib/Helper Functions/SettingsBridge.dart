// This file contains helper functions to look for setting changes


import 'package:flutter/foundation.dart';

class SettingsBridge {
  static final ValueNotifier<bool> shakeModeChanged = ValueNotifier(false);
  static final ValueNotifier<bool> volumeModeChanged = ValueNotifier(false);

  static final ValueNotifier<bool> sosDurationChanged = ValueNotifier(false);
}
