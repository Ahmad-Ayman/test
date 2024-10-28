import 'package:flutter/foundation.dart';
import 'package:dash_shield/dash_shield.dart';
import 'package:dashtest/test2.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DashShield.preventScreenshotsGlobally();
  final securityConfig = SecurityConfig(
    androidSigningSHA256Hashes: [
      '25:54:B1:7D:51:6E:AA:24:69:B3:AA:6A:80:74:CC:0C:3F:1F:BB:03:F8:E9:DD:E6:2B:EB:02:AB:C0:AE:2B:24',
    ],
    androidPackageName: 'com.example.dashtest',
    iosBundleIds: ['com.example.dashtest'],
    iosTeamId: 'TEAMID',
    watcherEmail: 'security@example.com',
    enableOnAndroid: true,
    enableOniOS: true,
    isProduction: true,
    checksToEnable: [
      // SecOnControlsToApply.debug,
      SecOnControlsToApply.devMode,
      SecOnControlsToApply.obfuscationIssues,
      SecOnControlsToApply.debug,
    ],
    specificActions: {
      SecOnControlsToApply.devMode: (issue) {
if (kDebugMode) {
}
      },
      SecOnControlsToApply.obfuscationIssues: (issue) {
if (kDebugMode) {
}
      },
    },
  );
  DashShield.initSecurity(config: securityConfig);
  // await applySecurityControlsExample();
  // final _flutterPreventScreenshot = FlutterPreventScreenshot.instance;
  // final result = await _flutterPreventScreenshot.screenshotOff();
  // if (kDebugMode) {
  //   print(result);
  // }
  // await ScreenProtector.preventScreenshotOn();
  // await ScreenProtector.protectDataLeakageWithColorOff();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return DashShieldOverlay(
            overlayWidget: Container(
              color: Colors.teal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't Sneak",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Icon(
                    Icons.no_accounts,
                    size: 100,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            child: child!);
      },
      home: const MyHomePage(title: 'Dash Shield Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getAllDio() async {
    //https://cat-fact.herokuapp.com/facts
    //https://fakestoreapi.com/products
    final respo = await ApiServiceDio.getInstance()
        .get('https://fakestoreapi.com/products');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Secure the entire app from screen capture
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  DashShield.allowScreenshotsGlobally();
                },
                child: Text('Press to allow screenshot')),
            ElevatedButton(
                onPressed: () {
                  DashShield.preventScreenshotsGlobally();
                },
                child: Text('Press to disable screenshot')),
            ElevatedButton(
                onPressed: getAllDio, child: Text('Test SSL Pinning')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Step2()));
                },
                child: Text('Test prevent screenshot for single page')),
          ],
        ),
      ),
    );
  }
}
