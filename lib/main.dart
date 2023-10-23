import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:sensordevices/bluetooth_devices/bluetooth_screen.dart';
import 'package:sensordevices/flutterBlue/bluePage/blue_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devices Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
//!floating butoms
  bool? initialOpen;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = initialOpen ?? false;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  static const methodChannel = MethodChannel('com.example.test/devices');
  static const pressureChannel = EventChannel('com.example.test/pressure');
  static const deviceChannel = EventChannel('tesPhysicalDevices');

  String _blutoothDevices = 'Pair';

  late StreamSubscription deviceSubscription;

  //invoke the message u want to show
  Future<void> _checkPairing() async {
    try {
      var pair = await methodChannel.invokeMethod('Paired');
      setState(() {
        _blutoothDevices = pair.toString();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // read from device
  _startPairing() {
    deviceSubscription = deviceChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _pressureReading = event;
      });
    });
  }

  String _sensorAvailable = 'Unknown';
  double _pressureReading = 0;
  late StreamSubscription pressureSubscription;

  //invoke the message u want to show
  Future<void> _checkAvailability() async {
    try {
      var available = await methodChannel.invokeMethod('isSensorAvailable');
      setState(() {
        _sensorAvailable = available.toString();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  //reading function
  _startReading() {
    pressureSubscription =
        pressureChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _pressureReading = event;
      });
    });
  }

  _stopReading() {
    setState(() {
      _pressureReading = 0;
    });
    pressureSubscription.cancel();
  }

//connecting pgysical devices

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Testing..:  $_sensorAvailable',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            // Container(
            //   padding: const EdgeInsets.all(5),
            //   height: 50,
            //   width: 300,
            //   decoration: BoxDecoration(
            //       color: Colors.red, borderRadius: BorderRadius.circular(17)),
            //   child: Center(
            //       child: Text('Sensor Reading: $_pressureReading',
            //           style: const TextStyle(color: Colors.white))),
            // ),

            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConnectDevicesScreen()));
                },
                child: const Text('Devices Screen')),

            // SizedBox(
            //   height: 10,
            // ),
            // Text('Connect Devices:  $_blutoothDevices'),

            // SizedBox(
            //   height: 10,
            // ),
            // ElevatedButton(
            //     onPressed: () => _startPairing(), child: Text('Blutooth Scan')),

            // SizedBox(
            //   height: 50,
            // ),
            // ElevatedButton(
            //     onPressed: () => _startReading(), child: Text('start reading')),
            // ElevatedButton(
            //     onPressed: () => _stopReading(), child: Text('Stop reading')),

            // const SizedBox(
            //   height: 50,
            // ),

          ],
        ),
      ),
      //this floating action shows there's a connection between native android and flutter
      floatingActionButton: FloatingActionButton(
        onPressed: () => _checkAvailability(),
        tooltip: 'Increment',
        splashColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
