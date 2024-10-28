import 'package:flutter/foundation.dart';
import 'package:dash_shield/dash_shield.dart';
import 'package:flutter/material.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  @override
  void initState() {
    // Secure only this screen from screen capture
    DashShield.secureScreen("ProtectedScreen");
    super.initState();
  }

  @override
  void dispose() {
    // DashShield.allowScreenshots(); // Allow screenshots when leaving this screen
    super.dispose();
  }

  @override
  void deactivate() {
    if (kDebugMode) {
      print('asda');
    }
    // DashShield.allowScreenshots(); // Allow screenshots when leaving this screen
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensitive Screen'),
      ),
      body: Center(
          child: Text(
              'Content on this screen is secure from screenshots and recording.')),
    );
  }
}
