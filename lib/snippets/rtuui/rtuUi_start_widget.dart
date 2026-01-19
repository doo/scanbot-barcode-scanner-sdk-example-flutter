import 'package:flutter/material.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:scanbot_barcode_sdk_example/utility/utils.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _startBarcodeScanner() async {
    // Create the default configuration object.
    var configuration = BarcodeScannerScreenConfiguration();

    // TODO: configure as needed

    var result = await ScanbotBarcodeSdk.barcode.startScanner(configuration);

    if (result is Ok<BarcodeScannerUiResult>) {
      // TODO: present barcode result as needed
    } else {
      await showAlertDialog(context, title: "Info", result.toString());
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
