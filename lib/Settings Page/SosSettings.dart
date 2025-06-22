import 'package:emergency_v1/Helper%20Functions/SettingsBridge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosSettings extends StatefulWidget {
  const SosSettings({super.key});

  @override
  State<SosSettings> createState() => _SosSettingsState();
}

class _SosSettingsState extends State<SosSettings> {


  // Variable declaration starts
  int _durationBetweenEachMessage = 1;
  bool _isLoading = true;
  // Variable declaration ends

  @override
  void initState() {
    super.initState();
    _loadSavedDuration();
    _loadCustomEmergencyMessage();
  }


  // Function to load the saved duration prefs
  Future<void> _loadSavedDuration() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _durationBetweenEachMessage = prefs.getInt('sos_duration') ?? 1;
      _isLoading = false;
    });
  }


  // Function to load the saved custom message prefs
  Future<String?> _loadCustomEmergencyMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('custom_emergency_message');
  }


  // Function to save the prefs
  Future<void> _saveCustomEmergencyMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_emergency_message', message);
  }


  // Function to save the prefs
  Future<void> _saveDuration(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sos_duration', value);

    SettingsBridge.sosDurationChanged.value = !SettingsBridge.sosDurationChanged.value;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'SOS Settings',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Custom Message Card
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _buildEmergencyMessageDialog(context, screenWidth),
                child: ListTile(
                  leading: Icon(Icons.message, color: Colors.redAccent, size: 28),
                  title: Text('Custom Emergency Message', style: GoogleFonts.lato(fontSize: 16, color: Colors.white)),
                  subtitle: Text('Set your own message', style: GoogleFonts.lato(fontSize: 14, color: Colors.white70)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            // Duration Selection Card
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration Between SOS Messages',
                      style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Column(

                        // Builds the radio button setting to choose the sos duration between each message
                        children: [
                          for (final duration in [1, 2, 5, 10, 15])
                            RadioListTile<int>(
                              activeColor: Colors.redAccent,
                              tileColor: const Color(0xFF1E1E1E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: Text('$duration Min', style: GoogleFonts.lato(fontSize: 14, color: Colors.white)),
                              value: duration,
                              groupValue: _durationBetweenEachMessage,
                              onChanged: (int? value) {
                                if (value != null) {
                                  setState(() => _durationBetweenEachMessage = value);
                                  _saveDuration(value);
                                }
                              },
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // This function builds the dialog to enter custom emergency message
  Future<void> _buildEmergencyMessageDialog(BuildContext context, double screenWidth) {
    final TextEditingController messageController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FutureBuilder<String?>(
              future: _loadCustomEmergencyMessage(),
              builder: (context, snapshot) {
                final String currentMessage = snapshot.data ?? "Help me, I am in Danger!";

                return AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Set Custom Emergency Message',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: SizedBox(
                    width: screenWidth * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Current Message:',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentMessage,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Fixed-size, scrollable text area
                        SizedBox(
                          height: 120,
                          child: TextField(
                            controller: messageController,
                            style: const TextStyle(color: Colors.white),
                            expands: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Enter new emergency message',
                              hintStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: const Color(0xFF2A2A2A),
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: GoogleFonts.lato(fontSize: 16)),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                      onPressed: () async {
                        await _saveCustomEmergencyMessage(messageController.text);
                        Navigator.of(context).pop();
                      },
                      child: Text('Save', style: GoogleFonts.lato(fontSize: 16)),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
