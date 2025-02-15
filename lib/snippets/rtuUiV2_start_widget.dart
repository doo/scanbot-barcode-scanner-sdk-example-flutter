import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _startBarcodeScanner() async {
    // Create the default configuration object.
    var configuration = BarcodeScannerConfiguration();

    // TODO: configure as needed

    var result = await ScanbotBarcodeSdkUiV2.startBarcodeScanner(configuration);

    if(result.status == OperationStatus.OK)
    {
      // TODO: present barcode result as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _startBarcodeScanner,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
