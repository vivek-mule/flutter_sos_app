import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../Helper Functions/SettingsBridge.dart";

class EmergencyActivaitonModesPage extends StatefulWidget {
  const EmergencyActivaitonModesPage({super.key});

  @override
  State<EmergencyActivaitonModesPage> createState() =>
      _EmergencyActivaitonModeState();
}

class _EmergencyActivaitonModeState extends State<EmergencyActivaitonModesPage> {


  // Variable declaration starts
  bool _isVolumeButtonModeEnabled = false;
  bool _isShakePhoneModeEnabled = false;

  int _selectedTapCount = 3;
  double _shakeSensitivity = 50.0;

  bool _isLoading = true;
  // Variable declaration ends


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }


  // This function loads all the saved shared preferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVolumeButtonModeEnabled = prefs.getBool('volumeButtonMode') ?? false;
      _selectedTapCount = prefs.getInt('volumeTaps') ?? 3;
      _isShakePhoneModeEnabled = prefs.getBool('shakeMode') ?? false;
      _shakeSensitivity = prefs.getDouble('sensitivity') ?? 50.0;
      _isLoading = false;
    });
  }


  // Responsible to save the settings of volume button mode
  Future<void> _setVolumeButtonMode(bool isEnabled, int tapCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('volumeButtonMode', isEnabled);
    await prefs.setInt('volumeTaps', tapCount);

    SettingsBridge.volumeModeChanged.value = !SettingsBridge.volumeModeChanged.value;
  }


  // Responsible to save the settings of shake phone mode
  Future<void> _setShakeMode(bool isEnabled, double sensitivity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shakeMode', isEnabled);
    await prefs.setDouble('sensitivity', sensitivity);

    SettingsBridge.shakeModeChanged.value = !SettingsBridge.shakeModeChanged.value;
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Activation Modes",
          style: GoogleFonts.lato(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "Volume Button Mode",
              subtitle: "In this, you have to press the volume button to activate SOS.",
              switchTitle: "Press Volume Button to Activate SOS",
              isEnabled: _isVolumeButtonModeEnabled,
              onToggle: (val) {
                setState(() => _isVolumeButtonModeEnabled = val);
                _setVolumeButtonMode(val, _selectedTapCount);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: _isVolumeButtonModeEnabled ? 1.0 : 0.5,
                    child: Text(
                      "Select number of taps to activate SOS",
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                  for (int taps in [3, 4, 5])
                    RadioListTile<int>(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      activeColor: Colors.redAccent,
                      tileColor: Colors.transparent, // ensures no background color
                      title: Text(
                        "$taps Taps",
                        style: GoogleFonts.lato(color: Colors.white),
                      ),
                      value: taps,
                      groupValue: _selectedTapCount,
                      onChanged: _isVolumeButtonModeEnabled
                          ? (int? value) {
                        if (value != null) {
                          setState(() => _selectedTapCount = value);
                          _setVolumeButtonMode(true, value);
                        }
                      }
                          : null,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Shake Mode",
              subtitle: "Shake your phone to trigger SOS instantly.",
              switchTitle: "Shake Phone to Activate SOS",
              isEnabled: _isShakePhoneModeEnabled,
              onToggle: (val) {
                setState(() => _isShakePhoneModeEnabled = val);
                _setShakeMode(val, _shakeSensitivity);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: _isShakePhoneModeEnabled ? 1.0 : 0.5,
                    child: Text(
                      "Shake Sensitivity: ${_shakeSensitivity.toStringAsFixed(0)}",
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                  Slider(
                    value: _shakeSensitivity,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    activeColor: Colors.redAccent,
                    inactiveColor: Colors.white24,
                    label: _shakeSensitivity.toStringAsFixed(0),
                    onChanged: _isShakePhoneModeEnabled
                        ? (double value) {
                      setState(() => _shakeSensitivity = value);
                      _setShakeMode(true, value);
                    }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // This builds the cards UI for the settings
  Widget _buildCard({
    required String title,
    required String subtitle,
    required String switchTitle,
    required bool isEnabled,
    required Function(bool) onToggle,
    required Widget child,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: GoogleFonts.lato(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(switchTitle,
                  style: GoogleFonts.lato(color: Colors.white)),
              value: isEnabled,
              activeColor: Colors.redAccent,
              onChanged: onToggle,
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
