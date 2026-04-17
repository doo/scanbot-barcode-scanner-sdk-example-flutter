import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:flutter/material.dart';

Widget buildBarcodeScannerCamera() {
  return BarcodeScannerCamera(
    configuration: BarcodeCameraConfiguration(
      scannerConfiguration: BarcodeClassicScannerConfiguration(),
    ),
    barcodeListener: (barcodeItems) async {
      // Handle barcode scanning results
      print(barcodeItems);
    },
  );
}
