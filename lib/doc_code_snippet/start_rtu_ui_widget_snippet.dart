import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _startBarcodeScanner() async {
    // Create the default configuration object.
    var configuration = BarcodeScannerConfiguration();

    // TODO: configure as needed

    var result = await ScanbotBarcodeSdk.startBarcodeScanner(configuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _startBarcodeScanner,
        tooltip: 'Start Barcode Scanning',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
