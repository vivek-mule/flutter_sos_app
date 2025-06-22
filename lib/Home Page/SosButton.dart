import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_listener/volume_listener.dart';

import '../Helper Functions/SettingsBridge.dart';
import '../Helper Functions/sms_sender.dart';
import '../Helper Functions/DatabaseHelper.dart';

/// Simple broadcast service for Home-Screen widget trigger
class _WidgetTriggerService {
  static bool _pending = false;
  static final _controller = StreamController<void>.broadcast();

  static void notify() {
    _pending = true;
    _controller.add(null);
  }

  static Stream<void> get onTrigger => _controller.stream;

  static bool consumePending() {
    if (_pending) {
      _pending = false;
      return true;
    }
    return false;
  }
}

class SosButton extends StatefulWidget {
  const SosButton({super.key});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> {


  // Variable Declaration Starts
  static const MethodChannel _channel =
  MethodChannel('com.example.sosapp/widget');

  bool _isVolumeButtonModeEnabled = false;
  int _selectedTapCount = 3;
  bool _isShakePhoneModeEnabled = false;
  double _shakeSensitivity = 50.0;
  int _sosDurationMinutes = 0;

  bool _sosActive = false;

  int _volumeTapCounter = 0;
  DateTime? _lastVolumeTapTime;

  StreamSubscription? _accelerometerSubscription;
  Timer? _periodicSosTimer;
  StreamSubscription<void>? _widgetTriggerSub;
  // Variable Declaration Ends


  // This is the first method which is called
  @override
  void initState() {
    super.initState();
    _bindWidgetChannel();
    _loadSettings();
    _loadSosState();

    _listenToSettingsChanges();
  }


  // This function is responsible to bing the widget logic
  void _bindWidgetChannel() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'triggerSos') {
        _WidgetTriggerService.notify();
      }
    });

    _widgetTriggerSub = _WidgetTriggerService.onTrigger.listen((_) {
      Future.delayed(const Duration(milliseconds: 500), _handleTap);
    });

    if (_WidgetTriggerService.consumePending()) {
      Future.delayed(const Duration(milliseconds: 500), _handleTap);
    }
  }


  // This function loads all the shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isVolumeButtonModeEnabled = prefs.getBool('volumeButtonMode') ?? false;
    _selectedTapCount = prefs.getInt('taps') ?? 3;
    _isShakePhoneModeEnabled = prefs.getBool('shakeMode') ?? false;
    _shakeSensitivity = prefs.getDouble('sensitivity') ?? 50.0;
    _sosDurationMinutes = prefs.getInt('sos_duration') ?? 0;


    if (_isVolumeButtonModeEnabled) _initVolumeButtonListener();
    if (_isShakePhoneModeEnabled) _initShakeDetection();
  }


  // This function loads the sos state which is responsible to handle sos logic
  Future<void> _loadSosState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sosActive = prefs.getBool('sosActive') ?? false;
    });
  }


  // This function listens to the settings and reloads them when they are changed
  void _listenToSettingsChanges() {
    SettingsBridge.volumeModeChanged.addListener(() {
      _reloadVolumeSettings();

      debugPrint("Volume Settings Reloaded");
    });

    SettingsBridge.shakeModeChanged.addListener(() {
      _reloadShakeSettings();

      debugPrint("Shake Settings Reloaded");
    });

    SettingsBridge.sosDurationChanged.addListener(() {
      _loadSettings();

      debugPrint("All Settings Reloaded");
    });
  }


  // It is responsible to reload all the volume mode settings
  Future<void> _reloadVolumeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isVolumeButtonModeEnabled = prefs.getBool('volumeButtonMode') ?? false;
    _selectedTapCount = prefs.getInt('volumeTaps') ?? 3;

    VolumeListener.removeListener();

    if (_isVolumeButtonModeEnabled) {
      _initVolumeButtonListener();
    }
  }


  // It is responsible to reload all the shake phone mode settings
  Future<void> _reloadShakeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isShakePhoneModeEnabled = prefs.getBool('shakeMode') ?? false;
    _shakeSensitivity = prefs.getDouble('sensitivity') ?? 50.0;

    _accelerometerSubscription?.cancel();

    if (_isShakePhoneModeEnabled) {
      _initShakeDetection();
    }
  }


  // This method is called when the app is removed from the screen
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _periodicSosTimer?.cancel();
    _widgetTriggerSub?.cancel();
    VolumeListener.removeListener();
    super.dispose();
  }


  // This method is responsible to handle the volume button mode logic
  void _initVolumeButtonListener() {
    VolumeListener.addListener((event) {
      if (!_isVolumeButtonModeEnabled || _sosActive) return;

      final now = DateTime.now();
      if (_lastVolumeTapTime == null ||
          now.difference(_lastVolumeTapTime!) > const Duration(seconds: 4)) {
        _volumeTapCounter = 1;
      } else {
        _volumeTapCounter++;
      }
      _lastVolumeTapTime = now;

      if (_volumeTapCounter >= _selectedTapCount) {
        _volumeTapCounter = 0;
        _startSOSLoop();
      }
    });
  }


  // This method is responsible to handle the shake phone mode logic
  void _initShakeDetection() {
    const int requiredShakeCount = 7; // Thala for a reason (requires at least 7 spikes before triggering SOS within 1 second)
    const Duration shakeWindow = Duration(seconds: 1);

    int shakeCount = 0;
    DateTime? shakeWindowStart;

    _accelerometerSubscription = userAccelerometerEvents.listen((event) {
      if (!_isShakePhoneModeEnabled || _sosActive) return;

      final double magnitude = sqrt(
        event.x * event.x +
            event.y * event.y +
            event.z * event.z,
      );

      final now = DateTime.now();

      if (magnitude > _shakeSensitivity) {
        if (shakeWindowStart == null ||
            now.difference(shakeWindowStart!) > shakeWindow) {
          // Start new window
          shakeWindowStart = now;
          shakeCount = 1;
        } else {
          shakeCount++;
        }

        if (shakeCount >= requiredShakeCount) {
          _startSOSLoop();
          shakeCount = 0;
          shakeWindowStart = null;
        }
      } else if (shakeWindowStart != null &&
          now.difference(shakeWindowStart!) > shakeWindow) {
        // Reset if window expired and not enough shakes
        shakeCount = 0;
        shakeWindowStart = null;
      }
    });
  }


  // Method responsible to send SOS to all the contacts
  Future<void> _sendSOSMessage() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final url =
          'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}';
      final prefs = await SharedPreferences.getInstance();
      String message = prefs.getString('custom_emergency_message') ??
          'Help me, I am in Danger!';
      message += '\nLocation: $url';

      final contacts = await DatabaseHelper().getContacts();

      int successCount = 0;
      for (final c in contacts) {
        final phone = c['phone']?.toString();
        if (phone != null && phone.isNotEmpty) {
          final success = await SmsSender.sendSms(phone, message);
          if (success) successCount++;
        }
      }

      if (mounted) {
        if (successCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('SOS message sent to $successCount contact(s)! 📍'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send SOS message'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending SOS: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }


  // This function starts the SOS loop
  Future<void> _startSOSLoop() async {
    if (_sosActive) return;

    int countdown = 5;
    bool isCancelled = false;
    bool dialogMounted = true;
    late Timer countdownTimer;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (!dialogMounted) {
                timer.cancel();
                return;
              }

              if (countdown <= 1) {
                timer.cancel();
                if (Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                }
              } else {
                setDialogState(() {
                  countdown--;
                });
              }
            });

            return AlertDialog(
              backgroundColor: const Color(0xFF121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Sending SOS in $countdown...',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'Tap the button below to cancel SOS activation.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                GestureDetector(
                  onTap: () {
                    isCancelled = true;
                    countdownTimer.cancel();
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 3),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    ).then((_) {
      dialogMounted = false;
    });

    // If cancelled, don't start SOS
    if (isCancelled) return;

    // Proceed with SOS trigger if not cancelled
    setState(() => _sosActive = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sosActive', true);

    await _sendSOSMessage();

    if (_sosDurationMinutes > 0) {
      _periodicSosTimer = Timer.periodic(
        Duration(minutes: _sosDurationMinutes),
            (_) {
          if (!_sosActive) {
            _periodicSosTimer?.cancel();
          } else {
            _sendSOSMessage();
          }
        },
      );
    }
  }


  // It stops the SOS loop
  Future<void> _stopSOSLoop() async {
    setState(() => _sosActive = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sosActive', false);
    _periodicSosTimer?.cancel();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS service stopped.'),
          backgroundColor: Color(0xFF2A2A2A),
        ),
      );
    }
  }


  // This function handles manual taps to the SOS Button
  void _handleTap() {
    _sosActive ? _stopSOSLoop() : _startSOSLoop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _sosActive
                ? Colors.red.shade900
                : Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: (_sosActive
                    ? Colors.red.shade900
                    : Colors.redAccent)
                    .withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              _sosActive ? 'STOP SOS' : 'START SOS',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
