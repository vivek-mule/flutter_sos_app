import 'package:emergency_v1/Settings%20Page/EmergencyActivationModesPage.dart';
import 'package:emergency_v1/Settings%20Page/EmergencyContactsPage.dart';
import 'package:emergency_v1/Settings%20Page/SosSettings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_settings/app_settings.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Functional Settings'),
                const SizedBox(height: 8),
                _buildSettingCard(
                  icon: Icons.settings,
                  title: 'SOS Settings',
                  subtitle: 'Control SOS behavior',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SosSettings()),
                  ),
                ),
                _buildSettingCard(
                  icon: Icons.contacts_rounded,
                  title: 'Emergency Contacts',
                  subtitle: 'Add or edit contacts',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmergencyContactsPage()),
                  ),
                ),
                _buildSettingCard(
                  icon: Icons.emergency,
                  title: 'Activation Modes',
                  subtitle: 'Configure trigger types',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmergencyActivaitonModesPage()),
                  ),
                ),
                _buildSettingCard(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy & Permissions',
                  subtitle: 'Manage app permissions',
                  onTap: () => _buildPrivacyPolicyDialog(context, screenWidth),
                ),
                _buildSettingCard(
                  icon: Icons.now_widgets_rounded,
                  title: 'Add Widget',
                  subtitle: 'Enable home screen widget',
                  onTap: () {
                    _buildWidgetInstructionDialog(context);
                  },
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Non-Functional Settings'),
                const SizedBox(height: 8),
                _buildSettingCard(
                  icon: Icons.tips_and_updates_rounded,
                  title: 'Safety Tips',
                  subtitle: 'Important emergency tips',
                  onTap: () => _buildSafetyTipsDialog(context, screenWidth),
                ),
                _buildSettingCard(
                  icon: Icons.share_rounded,
                  title: 'Share App',
                  subtitle: 'Let others know',
                  onTap: () {},
                ),
                _buildSettingCard(
                  icon: Icons.star_rate_rounded,
                  title: 'Rate Us',
                  subtitle: 'Give your feedback',
                  onTap: () {},
                ),
                _buildSettingCard(
                  icon: Icons.info_rounded,
                  title: 'About Us',
                  subtitle: '',
                  onTap: () => _buildAboutUsDialog(context, screenWidth),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // This just print if they are functional or non functional settings
  Widget _buildSectionHeader(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
        letterSpacing: 1.2,
      ),
    );
  }


  // This function builds the cards for the settings
  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
            ],
          ),
        ),
      ),
    );
  }


  // This builds dialog for privacy policy
  Future<void> _buildPrivacyPolicyDialog(BuildContext context, double screenWidth) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Privacy Policy & Permissions",
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
            textAlign: TextAlign.center,
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Privacy Policy",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Introduction:\n"
                        "This Privacy Policy outlines how we collect, use, and protect your information. By using this app, you agree to this policy.",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Data Collection:\n"
                        "We only collect the information necessary to provide our services and improve your experience.",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Data Use & Sharing:\n"
                        "Your information is used solely for enhancing app performance and security. We do not sell your data to third parties.",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Security:\n"
                        "We take appropriate measures to protect your data from unauthorized access and disclosure.",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Policy Updates:\n"
                        "We may update this policy periodically. Changes will be posted within the app.",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.white24),
                  const SizedBox(height: 8),
                  Text(
                    "Manage Permissions",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        AppSettings.openAppSettings();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          leading: const Icon(Icons.security_rounded, color: Colors.redAccent),
                          title: Text(
                            "Open App Settings",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "Manage permissions for this app",
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


  // This builds dialog for widget instruction
  void _buildWidgetInstructionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.widgets_rounded, size: 48, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text(
                  "Add SOS Widget",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "To add the SOS widget to your home screen:\n\n"
                      "1. Long-press on your home screen\n"
                      "2. Tap 'Widgets'\n"
                      "3. Search for 'SOS App'\n"
                      "4. Drag the widget to your home screen",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Got it!",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // This builds dialog for the safety tips
  Future<void> _buildSafetyTipsDialog(BuildContext context, double screenWidth) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Safety Tips & Resources",
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
            textAlign: TextAlign.center,
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Emergency Safety Steps",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "1. Stay Calm:\nTake deep breaths and remain as calm as possible.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "2. Call for Help:\nDial emergency numbers or contact saved people for help.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "3. Share Accurate Info:\nState your location and nature of emergency clearly.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "4. Follow Instructions:\nListen carefully to responders and follow directions.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "5. Move to Safety:\nIf it’s safe, get away from immediate danger.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "6. Assist Others:\nHelp others only if it is safe for you.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "7. Stay Updated:\nKeep your phone on and check for alerts or updates.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Emergency Contacts",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "• Police: 100\n"
                        "• Ambulance: 102\n"
                        "• Fire Brigade: 101\n"
                        "• Women’s Helpline: 1091\n"
                        "• Child Helpline: 1098\n"
                        "• Disaster Management: 108\n"
                        "• Road Emergency: 1073\n"
                        "• All-in-One Emergency: 112",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


  // This builds dialog for about us
  Future<void> _buildAboutUsDialog(BuildContext context, double screenWidth) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "About Us",
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
            textAlign: TextAlign.center,
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Safety, Our Priority",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "SOS Emergency App is designed to help you reach out for help when you need it most. Whether you’re in danger, feeling unsafe, or facing a medical emergency, this app lets you quickly alert your trusted contacts and share your live location in seconds.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We believe that safety should be accessible and instant. With a simple interface and essential features like emergency messaging, contact management, and GPS integration, this app serves as a personal safety companion — right in your pocket.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This application is built with care to empower individuals in critical moments. It is not affiliated with any official agency, but aims to support real-life safety through technology.",
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "— Made by Vivek Mule",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


}
