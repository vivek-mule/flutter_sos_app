import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'MySliverAppBar.dart';
import 'LocationContainer.dart';
import 'SosButton.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
    });
  }


  // This function checks if this is the first time user opens the app, if it is then prompt them to enable all permissions
  Future<void> _checkAndRequestPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Permissions Required',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'To ensure proper functioning, please grant the following permissions:\n\n- Location\n- Phone\n- SMS\n- Contacts\n\n\nYou can also enable these permissions later from settings :)',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog

                // Request permissions
                await [
                  Permission.location,
                  Permission.sms,
                  Permission.phone,
                  Permission.contacts,
                ].request();

                await prefs.setBool('isFirstLaunch', false);
              },
              child: const Text(
                'OKAY',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const MySliverAppBar(),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Stack(
                children: [
                  // Top: Location Container
                  const Positioned(
                    top: 36,
                    left: 20,
                    right: 20,
                    child: LocationContainer(),
                  ),

                  // Bottom: Instruction text and SOS button
                  Positioned(
                    bottom: 150,
                    left: 20,
                    right: 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'In case of emergency, tap the button below.\nYour location will be sent to your emergency contacts.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        SosButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
